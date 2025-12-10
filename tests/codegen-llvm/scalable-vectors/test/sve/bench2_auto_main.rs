// main_auto.rs

#![allow(non_camel_case_types, unused)]
#![feature(aarch64_target_feature)]

include!("bench2_auto.rs");

fn main() {
    const N: u32 = 4_000_000;
    const COMPLEXITY: u32 = 1024;

    let x = vec![1.0f32; N as usize];
    let mut y = vec![2.0f32; N as usize];
    let a: f32 = 1.5;

    unsafe {
        saxpy_auto_tuned(x.as_ptr(), y.as_mut_ptr(), a, N, COMPLEXITY);
    }

    println!("{}", y[0]);
}
