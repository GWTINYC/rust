//@ edition: 2021
//@ only-aarch64


/// 仅靠自动向量化版本，不使用显式 SVE Intrinsic。
/// 功能尽量与 `saxpy_sve_tuned` 保持一致。
#[inline(never)]
#[no_mangle]
#[cfg(target_arch = "aarch64")]
#[target_feature(enable = "sve,sve2")] // 只作为 hint，实际由自动向量化决定是否用 SVE
pub unsafe fn saxpy_auto_tuned(
    x: *const f32,
    y: *mut f32,
    a: f32,
    n: u32,
    complexity: u32,
) {
    let mut i: u32 = 0;

    while i < n {
        // 标量方式处理单个元素，让编译器自行决定是否向量化
        let mut yi: f32 = *y.add(i as usize);
        let xi: f32 = *x.add(i as usize);

        let mut k: u32 = 0;
        while k < complexity {
            // 与 SVE 版本保持大致同样的“工作量模式”
            let tmp = a * xi;
            let k_scale = (k as f32) * 1e-3;

            // 每一轮依赖上一轮的 yi，形成循环依赖，自动向量化难度较高
            yi = yi + tmp + k_scale;

            k = k.wrapping_add(1);
        }

        *y.add(i as usize) = yi;
        i = i.wrapping_add(1);
    }
}
