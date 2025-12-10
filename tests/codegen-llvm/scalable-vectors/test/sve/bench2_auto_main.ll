; ModuleID = 'bench2_auto_main.639616f757e573d8-cgu.0'
source_filename = "bench2_auto_main.639616f757e573d8-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h9c1b57c724dcafadE", ptr @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17ha7165393c6562246E", ptr @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17ha7165393c6562246E" }>, align 8

; std::rt::lang_start
; Function Attrs: uwtable
define hidden noundef i64 @_ZN3std2rt10lang_start17h50ab97e7f4d2f25fE(ptr noundef nonnull %main, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe) unnamed_addr #0 {
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
define internal noundef i32 @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17ha7165393c6562246E"(ptr noalias noundef readonly align 8 captures(none) dereferenceable(8) %_1) unnamed_addr #1 {
start:
  %_4 = load ptr, ptr %_1, align 8, !nonnull !3, !noundef !3
; call std::sys::backtrace::__rust_begin_short_backtrace
  tail call fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hafbcacc6b4256167E(ptr noundef nonnull %_4)
  ret i32 0
}

; std::sys::backtrace::__rust_begin_short_backtrace
; Function Attrs: noinline uwtable
define internal fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hafbcacc6b4256167E(ptr noundef nonnull readonly captures(none) %f) unnamed_addr #2 {
start:
  tail call void %f()
  tail call void asm sideeffect "", "~{memory}"() #7, !srcloc !4
  ret void
}

; core::ops::function::FnOnce::call_once{{vtable.shim}}
; Function Attrs: inlinehint uwtable
define internal noundef i32 @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h9c1b57c724dcafadE"(ptr noundef readonly captures(none) %_1) unnamed_addr #1 personality ptr @rust_eh_personality {
start:
  %0 = load ptr, ptr %_1, align 8, !nonnull !3, !noundef !3
; call std::sys::backtrace::__rust_begin_short_backtrace
  tail call fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hafbcacc6b4256167E(ptr noundef nonnull readonly %0), !noalias !5
  ret i32 0
}

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @saxpy_auto_tuned(ptr noundef readonly captures(none) %x, ptr noundef captures(none) %y, float noundef %a, i32 noundef %n, i32 noundef %complexity) unnamed_addr #3 {
start:
  %_714.not = icmp eq i32 %n, 0
  %_1811.not = icmp eq i32 %complexity, 0
  %or.cond = or i1 %_714.not, %_1811.not
  br i1 %or.cond, label %bb11, label %bb2.us.preheader

bb2.us.preheader:                                 ; preds = %start
  %wide.trip.count = zext i32 %n to i64
  br label %bb2.us

bb2.us:                                           ; preds = %bb2.us.preheader, %bb5.bb8_crit_edge.us
  %indvars.iv = phi i64 [ 0, %bb2.us.preheader ], [ %indvars.iv.next, %bb5.bb8_crit_edge.us ]
  %_0.i9.us = getelementptr inbounds nuw float, ptr %y, i64 %indvars.iv
  %0 = load float, ptr %_0.i9.us, align 4, !noundef !3
  %_0.i10.us = getelementptr inbounds nuw float, ptr %x, i64 %indvars.iv
  %xi.us = load float, ptr %_0.i10.us, align 4, !noundef !3
  %tmp.us = fmul float %a, %xi.us
  br label %bb6.us

bb6.us:                                           ; preds = %bb2.us, %bb6.us
  %yi.sroa.0.013.us = phi float [ %0, %bb2.us ], [ %1, %bb6.us ]
  %k.sroa.0.012.us = phi i32 [ 0, %bb2.us ], [ %_0.i.us, %bb6.us ]
  %_22.us = uitofp i32 %k.sroa.0.012.us to float
  %k_scale.us = fmul float %_22.us, 0x3F50624DE0000000
  %_24.us = fadd float %tmp.us, %yi.sroa.0.013.us
  %1 = fadd float %_24.us, %k_scale.us
  %_0.i.us = add nuw i32 %k.sroa.0.012.us, 1
  %exitcond.not = icmp eq i32 %_0.i.us, %complexity
  br i1 %exitcond.not, label %bb5.bb8_crit_edge.us, label %bb6.us

bb5.bb8_crit_edge.us:                             ; preds = %bb6.us
  store float %1, ptr %_0.i9.us, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond18.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond18.not, label %bb11, label %bb2.us

bb11:                                             ; preds = %bb5.bb8_crit_edge.us, %start
  ret void
}

; bench2_auto_main::main
; Function Attrs: uwtable
define hidden void @_ZN16bench2_auto_main4main17h1b27dbeb7a5c606dE() unnamed_addr #0 {
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

; test::test_main_static
; Function Attrs: uwtable
declare void @_ZN4test16test_main_static17h0d176bfe98783b19E(ptr noalias noundef nonnull readonly align 8, i64 noundef) unnamed_addr #0

define noundef i32 @main(i32 %0, ptr %1) unnamed_addr #6 {
top:
  %_7.i = alloca [8 x i8], align 8
  %2 = sext i32 %0 to i64
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %_7.i)
  store ptr @_ZN16bench2_auto_main4main17h1b27dbeb7a5c606dE, ptr %_7.i, align 8
; call std::rt::lang_start_internal
  %_0.i = call noundef i64 @_ZN3std2rt19lang_start_internal17h00d463d4b0499a77E(ptr noundef nonnull align 1 %_7.i, ptr noalias noundef readonly align 8 dereferenceable(48) @vtable.0, i64 noundef %2, ptr noundef %1, i8 noundef 0)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %_7.i)
  %3 = trunc i64 %_0.i to i32
  ret i32 %3
}

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #1 = { inlinehint uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #2 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #3 = { nofree noinline norecurse nosync nounwind memory(argmem: readwrite) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" "target-features"="+v8a,+outline-atomics,+neon,+fp-armv8,+sve,+neon,+fp-armv8,+sve,+sve2" }
attributes #6 = { "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="generic" }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{!"rustc version 1.91.0-dev"}
!3 = !{}
!4 = !{i64 17899611217696631}
!5 = !{!6}
!6 = distinct !{!6, !7, !"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17ha7165393c6562246E: %_1"}
!7 = distinct !{!7, !"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17ha7165393c6562246E"}
