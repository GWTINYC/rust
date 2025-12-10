; ModuleID = 'bench2_sve_main.90583c5891424a42-cgu.0'
source_filename = "bench2_sve_main.90583c5891424a42-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h3df9c1ffed3fcadfE", ptr @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h24849099b29417a4E", ptr @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h24849099b29417a4E" }>, align 8

; std::rt::lang_start
; Function Attrs: uwtable
define hidden noundef i64 @_ZN3std2rt10lang_start17hce13726d52834ce9E(ptr noundef nonnull %main, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe) unnamed_addr #0 {
start:
  %_7 = alloca [8 x i8], align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %_7)
  store ptr %main, ptr %_7, align 8
; call std::rt::lang_start_internal
  %_0 = call noundef i64 @_ZN3std2rt19lang_start_internal17h00d463d4b0499a77E(ptr noundef nonnull align 1 %_7, ptr noalias noundef readonly align 8 dereferenceable(48) @vtable.0, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %_7)
  ret i64 %_0
}

; std::rt::lang_start::{{closure}}
; Function Attrs: inlinehint uwtable
define internal noundef i32 @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h24849099b29417a4E"(ptr noalias noundef readonly align 8 captures(none) dereferenceable(8) %_1) unnamed_addr #1 {
start:
  %_4 = load ptr, ptr %_1, align 8, !nonnull !3, !noundef !3
; call std::sys::backtrace::__rust_begin_short_backtrace
  tail call fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hadcdd4e1723e7450E(ptr noundef nonnull %_4)
  ret i32 0
}

; std::sys::backtrace::__rust_begin_short_backtrace
; Function Attrs: noinline uwtable
define internal fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hadcdd4e1723e7450E(ptr noundef nonnull readonly captures(none) %f) unnamed_addr #2 {
start:
  tail call void %f()
  tail call void asm sideeffect "", "~{memory}"() #11, !srcloc !4
  ret void
}

; core::ops::function::FnOnce::call_once{{vtable.shim}}
; Function Attrs: inlinehint uwtable
define internal noundef i32 @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h3df9c1ffed3fcadfE"(ptr noundef readonly captures(none) %_1) unnamed_addr #1 personality ptr @rust_eh_personality {
start:
  %0 = load ptr, ptr %_1, align 8, !nonnull !3, !noundef !3
; call std::sys::backtrace::__rust_begin_short_backtrace
  tail call fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hadcdd4e1723e7450E(ptr noundef nonnull readonly %0), !noalias !5
  ret i32 0
}

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @saxpy_sve_tuned(ptr noundef readonly captures(none) %x, ptr noundef captures(none) %y, float noundef %a, i32 noundef %n, i32 noundef %complexity) unnamed_addr #3 {
start:
  %0 = tail call i64 @llvm.vscale.i64()
  %.tr = trunc i64 %0 to i32
  %num_vals = shl i32 %.tr, 2
  %.splatinsert.i = insertelement <vscale x 4 x float> poison, float %a, i64 0
  %_0.i13 = shufflevector <vscale x 4 x float> %.splatinsert.i, <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer
  %_1025.not = icmp eq i32 %n, 0
  br i1 %_1025.not, label %bb20, label %bb3.lr.ph

bb3.lr.ph:                                        ; preds = %start
  %_2622.not = icmp eq i32 %complexity, 0
  br i1 %_2622.not, label %bb3, label %bb3.us

bb3.us:                                           ; preds = %bb3.lr.ph, %bb9.bb16_crit_edge.us
  %i.sroa.0.026.us = phi i32 [ %_0.i8.us, %bb9.bb16_crit_edge.us ], [ 0, %bb3.lr.ph ]
  %_0.i14.us = tail call <vscale x 4 x i1> @llvm.aarch64.sve.whilelt.nxv4i1.i32(i32 noundef %i.sroa.0.026.us, i32 noundef %n) #11
  %_18.us = zext i32 %i.sroa.0.026.us to i64
  %_0.i11.us = getelementptr inbounds nuw float, ptr %x, i64 %_18.us
  %_0.i15.us = tail call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0(ptr readonly %_0.i11.us, i32 1, <vscale x 4 x i1> %_0.i14.us, <vscale x 4 x float> zeroinitializer)
  %_0.i10.us = getelementptr inbounds nuw float, ptr %y, i64 %_18.us
  %_0.i16.us = tail call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0(ptr readonly %_0.i10.us, i32 1, <vscale x 4 x i1> %_0.i14.us, <vscale x 4 x float> zeroinitializer)
  %_0.i17.us = tail call <vscale x 4 x float> @llvm.aarch64.sve.fmul.nxv4f32(<vscale x 4 x i1> %_0.i14.us, <vscale x 4 x float> %_0.i15.us, <vscale x 4 x float> %_0.i13) #11
  br label %bb10.us

bb10.us:                                          ; preds = %bb3.us, %bb10.us
  %yseg.024.us = phi <vscale x 4 x float> [ %_0.i16.us, %bb3.us ], [ %_0.i21.us, %bb10.us ]
  %k.sroa.0.023.us = phi i32 [ 0, %bb3.us ], [ %_0.i.us, %bb10.us ]
  %_30.us = uitofp i32 %k.sroa.0.023.us to float
  %k_scale.us = fmul float %_30.us, 0x3F50624DE0000000
  %.splatinsert.i18.us = insertelement <vscale x 4 x float> poison, float %k_scale.us, i64 0
  %_0.i19.us = shufflevector <vscale x 4 x float> %.splatinsert.i18.us, <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer
  %_0.i20.us = tail call <vscale x 4 x float> @llvm.aarch64.sve.fadd.nxv4f32(<vscale x 4 x i1> %_0.i14.us, <vscale x 4 x float> %yseg.024.us, <vscale x 4 x float> %_0.i17.us) #11
  %_0.i21.us = tail call <vscale x 4 x float> @llvm.aarch64.sve.fadd.nxv4f32(<vscale x 4 x i1> %_0.i14.us, <vscale x 4 x float> %_0.i20.us, <vscale x 4 x float> %_0.i19.us) #11
  %_0.i.us = add nuw i32 %k.sroa.0.023.us, 1
  %exitcond.not = icmp eq i32 %_0.i.us, %complexity
  br i1 %exitcond.not, label %bb9.bb16_crit_edge.us, label %bb10.us

bb9.bb16_crit_edge.us:                            ; preds = %bb10.us
  tail call void @llvm.masked.store.nxv4f32.p0(<vscale x 4 x float> %_0.i21.us, ptr %_0.i10.us, i32 1, <vscale x 4 x i1> %_0.i14.us)
  %_0.i8.us = add i32 %i.sroa.0.026.us, %num_vals
  %_10.us = icmp ult i32 %_0.i8.us, %n
  br i1 %_10.us, label %bb3.us, label %bb20

bb20:                                             ; preds = %bb9.bb16_crit_edge.us, %bb3, %start
  ret void

bb3:                                              ; preds = %bb3.lr.ph, %bb3
  %i.sroa.0.026 = phi i32 [ %_0.i8, %bb3 ], [ 0, %bb3.lr.ph ]
  %_0.i14 = tail call <vscale x 4 x i1> @llvm.aarch64.sve.whilelt.nxv4i1.i32(i32 noundef %i.sroa.0.026, i32 noundef %n) #11
  %_18 = zext i32 %i.sroa.0.026 to i64
  %_0.i10 = getelementptr inbounds nuw float, ptr %y, i64 %_18
  %_0.i16 = tail call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0(ptr readonly %_0.i10, i32 1, <vscale x 4 x i1> %_0.i14, <vscale x 4 x float> zeroinitializer)
  tail call void @llvm.masked.store.nxv4f32.p0(<vscale x 4 x float> %_0.i16, ptr %_0.i10, i32 1, <vscale x 4 x i1> %_0.i14)
  %_0.i8 = add i32 %i.sroa.0.026, %num_vals
  %_10 = icmp ult i32 %_0.i8, %n
  br i1 %_10, label %bb3, label %bb20
}

; bench2_sve_main::main
; Function Attrs: uwtable
define hidden void @_ZN15bench2_sve_main4main17hcba4a0393611d0e2E() unnamed_addr #0 {
start:
; call test::test_main_static
  tail call void @_ZN4test16test_main_static17h0d176bfe98783b19E(ptr noalias noundef nonnull readonly align 8 inttoptr (i64 8 to ptr), i64 noundef 0)
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #4

; std::rt::lang_start_internal
; Function Attrs: uwtable
declare noundef i64 @_ZN3std2rt19lang_start_internal17h00d463d4b0499a77E(ptr noundef nonnull align 1, ptr noalias noundef readonly align 8 dereferenceable(48), i64 noundef, ptr noundef, i8 noundef) unnamed_addr #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(none)
declare <vscale x 4 x i1> @llvm.aarch64.sve.whilelt.nxv4i1.i32(i32, i32) unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(none)
declare <vscale x 4 x float> @llvm.aarch64.sve.fmul.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>) unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(none)
declare <vscale x 4 x float> @llvm.aarch64.sve.fadd.nxv4f32(<vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>) unnamed_addr #6

; test::test_main_static
; Function Attrs: uwtable
declare void @_ZN4test16test_main_static17h0d176bfe98783b19E(ptr noalias noundef nonnull readonly align 8, i64 noundef) unnamed_addr #0

define noundef i32 @main(i32 %0, ptr %1) unnamed_addr #7 {
top:
  %_7.i = alloca [8 x i8], align 8
  %2 = sext i32 %0 to i64
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %_7.i)
  store ptr @_ZN15bench2_sve_main4main17hcba4a0393611d0e2E, ptr %_7.i, align 8
; call std::rt::lang_start_internal
  %_0.i = call noundef i64 @_ZN3std2rt19lang_start_internal17h00d463d4b0499a77E(ptr noundef nonnull align 1 %_7.i, ptr noalias noundef readonly align 8 dereferenceable(48) @vtable.0, i64 noundef %2, ptr noundef %1, i8 noundef 0)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %_7.i)
  %3 = trunc i64 %_0.i to i32
  ret i32 %3
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i64 @llvm.vscale.i64() #8

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0(ptr captures(none), i32 immarg, <vscale x 4 x i1>, <vscale x 4 x float>) #9

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.masked.store.nxv4f32.p0(<vscale x 4 x float>, ptr captures(none), i32 immarg, <vscale x 4 x i1>) #10

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #1 = { inlinehint uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #2 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #3 = { nofree noinline norecurse nosync nounwind memory(argmem: readwrite) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #6 = { mustprogress nocallback nofree nosync nounwind willreturn memory(none) }
attributes #7 = { "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" }
attributes #8 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #9 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
attributes #10 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
attributes #11 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{!"rustc version 1.91.0-dev"}
!3 = !{}
!4 = !{i64 18293034517069128}
!5 = !{!6}
!6 = distinct !{!6, !7, !"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h24849099b29417a4E: %_1"}
!7 = distinct !{!7, !"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h24849099b29417a4E"}
