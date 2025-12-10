// main_sve.rs
// 直接把 bench2_sve.rs 并入 crate 根，避免其 crate 级属性在模块内变成非法的“内层属性”
#![allow(incomplete_features, internal_features)]
#![feature(simd_ffi, rustc_attrs, link_llvm_intrinsics, aarch64_target_feature)]
#![allow(non_camel_case_types, unused)]
include!("bench2_sve.rs");

fn main() {
    // 向量长度
    const N: u32 = 4_000_000;
    // 控制“复杂度”的参数（比如内部多做几层运算）
    const COMPLEXITY: u32 = 16;;

    // 准备输入数据：x 全是 1.0，y 全是 2.0
    let x = vec![1.0f32; N as usize];
    let mut y = vec![2.0f32; N as usize];
    let a: f32 = 1.5;

    unsafe {
        saxpy_sve_tuned(x.as_ptr(), y.as_mut_ptr(), a, N, COMPLEXITY);
    }

    // 防止被编译器“认为结果没用”而优化掉计算
    println!("{}", y[0]);
}

