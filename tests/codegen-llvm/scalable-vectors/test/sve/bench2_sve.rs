//@ edition: 2021
//@ only-aarch64

/// 32-bit 浮点 SVE 向量：等价 LLVM 的 `<vscale x 4 x float>`
#[derive(Copy, Clone)]
#[rustc_scalable_vector(4)]
pub struct svfloat32_t(f32);

/// 32-bit 谓词向量：等价 `<vscale x 4 x i1>`
#[derive(Copy, Clone)]
#[rustc_scalable_vector(4)]
pub struct svbool32_t(bool);

/// cntw：返回当前 SVE 向量中 32-bit 元素个数
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svcntw_all() -> u64 {
    extern "C" {
        // i64 @llvm.aarch64.sve.cntw(i32)
        #[link_name = "llvm.aarch64.sve.cntw"]
        fn llvm_cntw(pattern: i32) -> u64;
    }
    // pattern = 31 => 所有 lane 都 active，对应 C 里的 svcntw()
    llvm_cntw(31)
}

/// whilelt：根据 i < n 生成谓词
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svwhilelt_b32_s32(i: i32, n: i32) -> svbool32_t {
    extern "C" {
        // <vscale x 4 x i1> @llvm.aarch64.sve.whilelt.nxv4i1.i32(i32, i32)
        #[link_name = "llvm.aarch64.sve.whilelt.nxv4i1.i32"]
        fn llvm_whilelt(i: i32, n: i32) -> svbool32_t;
    }
    llvm_whilelt(i, n)
}

/// ld1：按谓词从内存加载一段 f32 向量
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svld1_f32(pg: svbool32_t, base: *const f32) -> svfloat32_t {
    extern "C" {
        // <vscale x 4 x float> @llvm.aarch64.sve.ld1.nxv4f32(<vscale x 4 x i1>, ptr)
        #[link_name = "llvm.aarch64.sve.ld1.nxv4f32"]
        fn llvm_ld1(pg: svbool32_t, base: *const f32) -> svfloat32_t;
    }
    llvm_ld1(pg, base)
}

/// st1：按谓词把向量数据存回内存
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svst1_f32(pg: svbool32_t, base: *mut f32, data: svfloat32_t) {
    extern "C" {
        // 注意顺序：data, pred, ptr （LLVM 的真实签名）
        // void @llvm.aarch64.sve.st1.nxv4f32(<vscale x 4 x float>, <vscale x 4 x i1>, ptr)
        #[link_name = "llvm.aarch64.sve.st1.nxv4f32"]
        fn llvm_st1(data: svfloat32_t, pg: svbool32_t, base: *mut f32);
    }
    llvm_st1(data, pg, base)
}

/// dup：把标量 a 复制到整个 SVE 向量
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svdup_n_f32(a: f32) -> svfloat32_t {
    extern "C" {
        // <vscale x 4 x float> @llvm.aarch64.sve.dup.x.nxv4f32(float)
        #[link_name = "llvm.aarch64.sve.dup.x.nxv4f32"]
        fn llvm_dup(a: f32) -> svfloat32_t;
    }
    llvm_dup(a)
}

/// fmul：按谓词执行逐元素乘法
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svmul_f32_m(pg: svbool32_t, x: svfloat32_t, y: svfloat32_t) -> svfloat32_t {
    extern "C" {
        // <vscale x 4 x float> @llvm.aarch64.sve.fmul.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
        #[link_name = "llvm.aarch64.sve.fmul.nxv4f32"]
        fn llvm_fmul(pg: svbool32_t, x: svfloat32_t, y: svfloat32_t) -> svfloat32_t;
    }
    llvm_fmul(pg, x, y)
}

/// fadd：按谓词执行逐元素加法
#[inline]
#[target_feature(enable = "sve")]
unsafe fn svadd_f32_m(pg: svbool32_t, x: svfloat32_t, y: svfloat32_t) -> svfloat32_t {
    extern "C" {
        // <vscale x 4 x float> @llvm.aarch64.sve.fadd.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
        #[link_name = "llvm.aarch64.sve.fadd.nxv4f32"]
        fn llvm_fadd(pg: svbool32_t, x: svfloat32_t, y: svfloat32_t) -> svfloat32_t;
    }
    llvm_fadd(pg, x, y)
}

/// 带“复杂度参数”的 SVE 版本：
/// 等价于：
/// for i in 0..n {
///     let mut yi = y[i];
///     let xi = x[i];
///     for k in 0..complexity {
///         yi = yi + a * xi + (k as f32) * 1e-3;
///     }
///     y[i] = yi;
/// }
#[inline(never)]
#[no_mangle]
#[cfg(target_arch = "aarch64")]
#[target_feature(enable = "sve,sve2")]
pub unsafe fn saxpy_sve_tuned(
    x: *const f32,
    y: *mut f32,
    a: f32,
    n: u32,
    complexity: u32,
) {
    let mut i: u32 = 0;

    // 一个 SVE 向量里有多少个 f32 元素（运行时依赖 vscale）
    let num_vals: u32 = svcntw_all() as u32;

    // 把标量 a 复制成一个向量，后面反复用
    let avec: svfloat32_t = svdup_n_f32(a);

    // 外层：以“向量步长”遍历整个数组
    while i < n {
        // 1. 谓词：哪些 lane 是 “i < n”
        let pg: svbool32_t = svwhilelt_b32_s32(i as i32, n as i32);

        // 2. 加载 x[i .. i+num_vals)、y[i .. i+num_vals)
        let xseg: svfloat32_t = svld1_f32(pg, x.add(i as usize));
        let mut yseg: svfloat32_t = svld1_f32(pg, y.add(i as usize));

        // 3. 在寄存器里做多轮混合计算（由 complexity 控制轮数）
        let mut k: u32 = 0;
        while k < complexity {
            // tmp = a * x
            let tmp: svfloat32_t = svmul_f32_m(pg, xseg, avec);

            // 小扰动：加入与 k 相关的常数，避免编译器把多轮运算完全合并掉
            let k_scale: f32 = (k as f32) * 1e-3;
            let kvec: svfloat32_t = svdup_n_f32(k_scale);

            // y = y + tmp + k * eps
            yseg = svadd_f32_m(pg, yseg, tmp);
            yseg = svadd_f32_m(pg, yseg, kvec);

            k = k.wrapping_add(1);
        }

        // 4. 写回这一段 y
        svst1_f32(pg, y.add(i as usize), yseg);

        // 5. i += num_vals;
        i = i.wrapping_add(num_vals);
    }
}
