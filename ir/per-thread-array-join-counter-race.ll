; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-join-counter-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@threads_alive = dso_local global i32 0, align 4, !dbg !0
@data = dso_local global i32 0, align 4, !dbg !8
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !11
@flags_mutex = dso_local global ptr null, align 8, !dbg !56
@flags = dso_local global ptr null, align 8, !dbg !52
@threads_total = dso_local global i32 0, align 4, !dbg !45
@tids = dso_local global ptr null, align 8, !dbg !47

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !66 {
entry:
    #dbg_value(ptr %arg, !70, !DIExpression(), !72)
  %0 = ptrtoint ptr %arg to i32, !dbg !73
    #dbg_value(i32 %0, !71, !DIExpression(), !72)
  %call = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #6, !dbg !74
  store i32 4, ptr @data, align 4, !dbg !75, !tbaa !76
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #6, !dbg !80
  %1 = load ptr, ptr @flags_mutex, align 8, !dbg !81, !tbaa !82
  %idxprom = sext i32 %0 to i64, !dbg !81
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %1, i64 %idxprom, !dbg !81
  %call2 = call i32 @pthread_mutex_lock(ptr noundef %arrayidx) #6, !dbg !84
  %2 = load ptr, ptr @flags, align 8, !dbg !85, !tbaa !86
  %idxprom3 = sext i32 %0 to i64, !dbg !85
  %arrayidx4 = getelementptr inbounds i8, ptr %2, i64 %idxprom3, !dbg !85
  store i8 1, ptr %arrayidx4, align 1, !dbg !88, !tbaa !89
  %3 = load ptr, ptr @flags_mutex, align 8, !dbg !91, !tbaa !82
  %idxprom5 = sext i32 %0 to i64, !dbg !91
  %arrayidx6 = getelementptr inbounds %union.pthread_mutex_t, ptr %3, i64 %idxprom5, !dbg !91
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef %arrayidx6) #6, !dbg !92
  ret ptr null, !dbg !93
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind
declare !dbg !94 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !98 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @cleaner(ptr noundef %arg) #0 !dbg !99 {
entry:
    #dbg_value(ptr %arg, !101, !DIExpression(), !105)
  br label %while.body, !dbg !106

while.body:                                       ; preds = %entry, %for.end
    #dbg_value(i32 0, !102, !DIExpression(), !107)
  %0 = load i32, ptr @threads_total, align 4, !dbg !108, !tbaa !76
  %cmp7 = icmp slt i32 0, %0, !dbg !110
  br i1 %cmp7, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !111

for.body.lr.ph:                                   ; preds = %while.body
  br label %for.body, !dbg !111

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !111

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %while.body
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !102, !DIExpression(), !107)
  %1 = load ptr, ptr @flags_mutex, align 8, !dbg !112, !tbaa !82
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %1, i64 %indvars.iv, !dbg !112
  %call = call i32 @pthread_mutex_lock(ptr noundef %arrayidx) #6, !dbg !114
  %2 = load ptr, ptr @flags, align 8, !dbg !115, !tbaa !86
  %arrayidx2 = getelementptr inbounds i8, ptr %2, i64 %indvars.iv, !dbg !115
  %3 = load i8, ptr %arrayidx2, align 1, !dbg !115, !tbaa !89, !range !117, !noundef !118
  %loadedv = trunc i8 %3 to i1, !dbg !115
  br i1 %loadedv, label %if.then, label %if.end, !dbg !115

if.then:                                          ; preds = %for.body
  %4 = load ptr, ptr @tids, align 8, !dbg !119, !tbaa !121
  %arrayidx4 = getelementptr inbounds i64, ptr %4, i64 %indvars.iv, !dbg !119
  %5 = load i64, ptr %arrayidx4, align 8, !dbg !119, !tbaa !123
  %call5 = call i32 @pthread_join(i64 noundef %5, ptr noundef null), !dbg !125
  %6 = load i32, ptr @threads_alive, align 4, !dbg !126, !tbaa !76
  %dec = add nsw i32 %6, -1, !dbg !126
  store i32 %dec, ptr @threads_alive, align 4, !dbg !126, !tbaa !76
  %7 = load ptr, ptr @flags, align 8, !dbg !127, !tbaa !86
  %arrayidx7 = getelementptr inbounds i8, ptr %7, i64 %indvars.iv, !dbg !127
  store i8 0, ptr %arrayidx7, align 1, !dbg !128, !tbaa !89
  br label %if.end, !dbg !129

if.end:                                           ; preds = %if.then, %for.body
  %8 = load ptr, ptr @flags_mutex, align 8, !dbg !130, !tbaa !82
  %arrayidx9 = getelementptr inbounds %union.pthread_mutex_t, ptr %8, i64 %indvars.iv, !dbg !130
  %call10 = call i32 @pthread_mutex_unlock(ptr noundef %arrayidx9) #6, !dbg !131
  br label %for.inc, !dbg !132

for.inc:                                          ; preds = %if.end
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !133
    #dbg_value(i64 %indvars.iv.next, !102, !DIExpression(), !107)
  %9 = load i32, ptr @threads_total, align 4, !dbg !108, !tbaa !76
  %10 = sext i32 %9 to i64, !dbg !110
  %cmp = icmp slt i64 %indvars.iv.next, %10, !dbg !110
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !111, !llvm.loop !134

for.end:                                          ; preds = %for.cond.cleanup
  br label %while.body, !dbg !106, !llvm.loop !138
}

declare !dbg !140 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !144 {
entry:
  %cleaner_tid = alloca i64, align 8
  store i32 4, ptr @threads_total, align 4, !dbg !153, !tbaa !76
  %0 = load i32, ptr @threads_total, align 4, !dbg !154, !tbaa !76
  %conv = sext i32 %0 to i64, !dbg !154
  %mul = mul i64 %conv, 8, !dbg !155
  %call = call noalias ptr @malloc(i64 noundef %mul) #7, !dbg !156
  store ptr %call, ptr @tids, align 8, !dbg !157, !tbaa !121
  %1 = load i32, ptr @threads_total, align 4, !dbg !158, !tbaa !76
  %conv1 = sext i32 %1 to i64, !dbg !158
  %call2 = call noalias ptr @calloc(i64 noundef %conv1, i64 noundef 1) #8, !dbg !159
  store ptr %call2, ptr @flags, align 8, !dbg !160, !tbaa !86
  %2 = load i32, ptr @threads_total, align 4, !dbg !161, !tbaa !76
  %conv3 = sext i32 %2 to i64, !dbg !161
  %mul4 = mul i64 %conv3, 40, !dbg !162
  %call5 = call noalias ptr @malloc(i64 noundef %mul4) #7, !dbg !163
  store ptr %call5, ptr @flags_mutex, align 8, !dbg !164, !tbaa !82
    #dbg_value(i32 0, !148, !DIExpression(), !165)
  %3 = load i32, ptr @threads_total, align 4, !dbg !166, !tbaa !76
  %cmp6 = icmp slt i32 0, %3, !dbg !168
  br i1 %cmp6, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !169

for.body.lr.ph:                                   ; preds = %entry
  br label %for.body, !dbg !169

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !169

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %entry
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !148, !DIExpression(), !165)
  %4 = load ptr, ptr @flags_mutex, align 8, !dbg !170, !tbaa !82
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %4, i64 %indvars.iv, !dbg !170
  %call7 = call i32 @pthread_mutex_init(ptr noundef %arrayidx, ptr noundef null) #6, !dbg !171
  br label %for.inc, !dbg !171

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !172
    #dbg_value(i64 %indvars.iv.next, !148, !DIExpression(), !165)
  %5 = load i32, ptr @threads_total, align 4, !dbg !166, !tbaa !76
  %6 = sext i32 %5 to i64, !dbg !168
  %cmp = icmp slt i64 %indvars.iv.next, %6, !dbg !168
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !169, !llvm.loop !173

for.end:                                          ; preds = %for.cond.cleanup
  call void @llvm.lifetime.start.p0(i64 8, ptr %cleaner_tid) #6, !dbg !175
    #dbg_declare(ptr %cleaner_tid, !150, !DIExpression(), !176)
  %call8 = call i32 @pthread_create(ptr noundef %cleaner_tid, ptr noundef null, ptr noundef @cleaner, ptr noundef null) #6, !dbg !177
    #dbg_value(i32 0, !151, !DIExpression(), !178)
  %7 = load i32, ptr @threads_total, align 4, !dbg !179, !tbaa !76
  %cmp119 = icmp slt i32 0, %7, !dbg !181
  br i1 %cmp119, label %for.body14.lr.ph, label %for.cond.cleanup13, !dbg !182

for.body14.lr.ph:                                 ; preds = %for.end
  br label %for.body14, !dbg !182

for.cond10.for.cond.cleanup13_crit_edge:          ; preds = %for.inc20
  br label %for.cond.cleanup13, !dbg !182

for.cond.cleanup13:                               ; preds = %for.cond10.for.cond.cleanup13_crit_edge, %for.end
  br label %for.end22

for.body14:                                       ; preds = %for.body14.lr.ph, %for.inc20
  %indvars.iv11 = phi i64 [ 0, %for.body14.lr.ph ], [ %indvars.iv.next12, %for.inc20 ]
    #dbg_value(i64 %indvars.iv11, !151, !DIExpression(), !178)
  %8 = load ptr, ptr @tids, align 8, !dbg !183, !tbaa !121
  %arrayidx16 = getelementptr inbounds i64, ptr %8, i64 %indvars.iv11, !dbg !183
  %9 = inttoptr i64 %indvars.iv11 to ptr, !dbg !185
  %call18 = call i32 @pthread_create(ptr noundef %arrayidx16, ptr noundef null, ptr noundef @thread, ptr noundef %9) #6, !dbg !186
  %10 = load i32, ptr @threads_alive, align 4, !dbg !187, !tbaa !76
  %inc19 = add nsw i32 %10, 1, !dbg !187
  store i32 %inc19, ptr @threads_alive, align 4, !dbg !187, !tbaa !76
  br label %for.inc20, !dbg !188

for.inc20:                                        ; preds = %for.body14
  %indvars.iv.next12 = add nuw nsw i64 %indvars.iv11, 1, !dbg !189
    #dbg_value(i64 %indvars.iv.next12, !151, !DIExpression(), !178)
  %11 = load i32, ptr @threads_total, align 4, !dbg !179, !tbaa !76
  %12 = sext i32 %11 to i64, !dbg !181
  %cmp11 = icmp slt i64 %indvars.iv.next12, %12, !dbg !181
  br i1 %cmp11, label %for.body14, label %for.cond10.for.cond.cleanup13_crit_edge, !dbg !182, !llvm.loop !190

for.end22:                                        ; preds = %for.cond.cleanup13
  br label %while.cond, !dbg !192

while.cond:                                       ; preds = %while.cond, %for.end22
  %13 = load i32, ptr @threads_alive, align 4, !dbg !193, !tbaa !76
  %tobool = icmp ne i32 %13, 0, !dbg !192
  br i1 %tobool, label %while.cond, label %while.end, !dbg !192, !llvm.loop !194

while.end:                                        ; preds = %while.cond
  %14 = load ptr, ptr @tids, align 8, !dbg !196, !tbaa !121
  call void @free(ptr noundef %14) #6, !dbg !197
  %15 = load i32, ptr @data, align 4, !dbg !198, !tbaa !76
  call void @llvm.lifetime.end.p0(i64 8, ptr %cleaner_tid) #6, !dbg !199
  ret i32 %15, !dbg !200
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !201 noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind allocsize(0,1)
declare !dbg !207 noalias ptr @calloc(i64 noundef, i64 noundef) #5

; Function Attrs: nounwind
declare !dbg !210 i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !223 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !240 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind allocsize(0,1) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }
attributes #7 = { nounwind allocsize(0) }
attributes #8 = { nounwind allocsize(0,1) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!59}
!llvm.module.flags = !{!60, !61, !62, !63, !64, !65}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !10, line: 17, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-join-counter-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "62d28d87b01a3934c85addec447ecd1d")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8, !11, !45, !47, !52, !56}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !10, line: 23, type: !5, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "per-thread-array-join-counter-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "62d28d87b01a3934c85addec447ecd1d")
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !10, line: 24, type: !13, isLocal: false, isDefinition: true)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !14, line: 72, baseType: !15)
!14 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!15 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !14, line: 67, size: 320, elements: !16)
!16 = !{!17, !38, !43}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !15, file: !14, line: 69, baseType: !18, size: 320)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !19, line: 22, size: 320, elements: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!20 = !{!21, !22, !24, !25, !26, !27, !29, !30}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !18, file: !19, line: 24, baseType: !5, size: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !18, file: !19, line: 25, baseType: !23, size: 32, offset: 32)
!23 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !18, file: !19, line: 26, baseType: !5, size: 32, offset: 64)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !18, file: !19, line: 28, baseType: !23, size: 32, offset: 96)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !18, file: !19, line: 32, baseType: !5, size: 32, offset: 128)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !18, file: !19, line: 34, baseType: !28, size: 16, offset: 160)
!28 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !18, file: !19, line: 35, baseType: !28, size: 16, offset: 176)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !18, file: !19, line: 36, baseType: !31, size: 128, offset: 192)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !32, line: 55, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !32, line: 51, size: 128, elements: !34)
!34 = !{!35, !37}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !33, file: !32, line: 53, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !33, file: !32, line: 54, baseType: !36, size: 64, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !15, file: !14, line: 70, baseType: !39, size: 320)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 320, elements: !41)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 40)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !15, file: !14, line: 71, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "threads_total", scope: !2, file: !10, line: 16, type: !5, isLocal: false, isDefinition: true)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "tids", scope: !2, file: !10, line: 19, type: !49, isLocal: false, isDefinition: true)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !14, line: 27, baseType: !51)
!51 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "flags", scope: !2, file: !10, line: 20, type: !54, isLocal: false, isDefinition: true)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "flags_mutex", scope: !2, file: !10, line: 21, type: !58, isLocal: false, isDefinition: true)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!59 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!60 = !{i32 7, !"Dwarf Version", i32 5}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 8, !"PIC Level", i32 2}
!64 = !{i32 7, !"PIE Level", i32 2}
!65 = !{i32 7, !"uwtable", i32 2}
!66 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 26, type: !67, scopeLine: 26, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !69)
!67 = !DISubroutineType(types: !68)
!68 = !{!6, !6}
!69 = !{!70, !71}
!70 = !DILocalVariable(name: "arg", arg: 1, scope: !66, file: !10, line: 26, type: !6)
!71 = !DILocalVariable(name: "i", scope: !66, file: !10, line: 27, type: !5)
!72 = !DILocation(line: 0, scope: !66)
!73 = !DILocation(line: 27, column: 11, scope: !66)
!74 = !DILocation(line: 29, column: 3, scope: !66)
!75 = !DILocation(line: 30, column: 8, scope: !66)
!76 = !{!77, !77, i64 0}
!77 = !{!"int", !78, i64 0}
!78 = !{!"omnipotent char", !79, i64 0}
!79 = !{!"Simple C/C++ TBAA"}
!80 = !DILocation(line: 31, column: 3, scope: !66)
!81 = !DILocation(line: 33, column: 23, scope: !66)
!82 = !{!83, !83, i64 0}
!83 = !{!"any pointer", !78, i64 0}
!84 = !DILocation(line: 33, column: 3, scope: !66)
!85 = !DILocation(line: 34, column: 3, scope: !66)
!86 = !{!87, !87, i64 0}
!87 = !{!"p1 _Bool", !83, i64 0}
!88 = !DILocation(line: 34, column: 12, scope: !66)
!89 = !{!90, !90, i64 0}
!90 = !{!"_Bool", !78, i64 0}
!91 = !DILocation(line: 35, column: 25, scope: !66)
!92 = !DILocation(line: 35, column: 3, scope: !66)
!93 = !DILocation(line: 36, column: 3, scope: !66)
!94 = !DISubprogram(name: "pthread_mutex_lock", scope: !95, file: !95, line: 794, type: !96, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!95 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!96 = !DISubroutineType(types: !97)
!97 = !{!5, !58}
!98 = !DISubprogram(name: "pthread_mutex_unlock", scope: !95, file: !95, line: 835, type: !96, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!99 = distinct !DISubprogram(name: "cleaner", scope: !10, file: !10, line: 39, type: !67, scopeLine: 39, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !100)
!100 = !{!101, !102}
!101 = !DILocalVariable(name: "arg", arg: 1, scope: !99, file: !10, line: 39, type: !6)
!102 = !DILocalVariable(name: "i", scope: !103, file: !10, line: 41, type: !5)
!103 = distinct !DILexicalBlock(scope: !104, file: !10, line: 41, column: 5)
!104 = distinct !DILexicalBlock(scope: !99, file: !10, line: 40, column: 13)
!105 = !DILocation(line: 0, scope: !99)
!106 = !DILocation(line: 40, column: 3, scope: !99)
!107 = !DILocation(line: 0, scope: !103)
!108 = !DILocation(line: 41, column: 25, scope: !109)
!109 = distinct !DILexicalBlock(scope: !103, file: !10, line: 41, column: 5)
!110 = !DILocation(line: 41, column: 23, scope: !109)
!111 = !DILocation(line: 41, column: 5, scope: !103)
!112 = !DILocation(line: 42, column: 27, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !10, line: 41, column: 45)
!114 = !DILocation(line: 42, column: 7, scope: !113)
!115 = !DILocation(line: 43, column: 11, scope: !116)
!116 = distinct !DILexicalBlock(scope: !113, file: !10, line: 43, column: 11)
!117 = !{i8 0, i8 2}
!118 = !{}
!119 = !DILocation(line: 44, column: 22, scope: !120)
!120 = distinct !DILexicalBlock(scope: !116, file: !10, line: 43, column: 21)
!121 = !{!122, !122, i64 0}
!122 = !{!"p1 long", !83, i64 0}
!123 = !{!124, !124, i64 0}
!124 = !{!"long", !78, i64 0}
!125 = !DILocation(line: 44, column: 9, scope: !120)
!126 = !DILocation(line: 45, column: 22, scope: !120)
!127 = !DILocation(line: 46, column: 9, scope: !120)
!128 = !DILocation(line: 46, column: 18, scope: !120)
!129 = !DILocation(line: 47, column: 7, scope: !120)
!130 = !DILocation(line: 48, column: 29, scope: !113)
!131 = !DILocation(line: 48, column: 7, scope: !113)
!132 = !DILocation(line: 49, column: 5, scope: !113)
!133 = !DILocation(line: 41, column: 41, scope: !109)
!134 = distinct !{!134, !111, !135, !136, !137}
!135 = !DILocation(line: 49, column: 5, scope: !103)
!136 = !{!"llvm.loop.mustprogress"}
!137 = !{!"llvm.loop.unroll.disable"}
!138 = distinct !{!138, !106, !139, !137}
!139 = !DILocation(line: 50, column: 3, scope: !99)
!140 = !DISubprogram(name: "pthread_join", scope: !95, file: !95, line: 219, type: !141, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!141 = !DISubroutineType(types: !142)
!142 = !{!5, !50, !143}
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!144 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 54, type: !145, scopeLine: 54, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !147)
!145 = !DISubroutineType(types: !146)
!146 = !{!5}
!147 = !{!148, !150, !151}
!148 = !DILocalVariable(name: "i", scope: !149, file: !10, line: 61, type: !5)
!149 = distinct !DILexicalBlock(scope: !144, file: !10, line: 61, column: 3)
!150 = !DILocalVariable(name: "cleaner_tid", scope: !144, file: !10, line: 65, type: !50)
!151 = !DILocalVariable(name: "i", scope: !152, file: !10, line: 68, type: !5)
!152 = distinct !DILexicalBlock(scope: !144, file: !10, line: 68, column: 3)
!153 = !DILocation(line: 55, column: 17, scope: !144)
!154 = !DILocation(line: 57, column: 17, scope: !144)
!155 = !DILocation(line: 57, column: 31, scope: !144)
!156 = !DILocation(line: 57, column: 10, scope: !144)
!157 = !DILocation(line: 57, column: 8, scope: !144)
!158 = !DILocation(line: 58, column: 18, scope: !144)
!159 = !DILocation(line: 58, column: 11, scope: !144)
!160 = !DILocation(line: 58, column: 9, scope: !144)
!161 = !DILocation(line: 59, column: 24, scope: !144)
!162 = !DILocation(line: 59, column: 38, scope: !144)
!163 = !DILocation(line: 59, column: 17, scope: !144)
!164 = !DILocation(line: 59, column: 15, scope: !144)
!165 = !DILocation(line: 0, scope: !149)
!166 = !DILocation(line: 61, column: 23, scope: !167)
!167 = distinct !DILexicalBlock(scope: !149, file: !10, line: 61, column: 3)
!168 = !DILocation(line: 61, column: 21, scope: !167)
!169 = !DILocation(line: 61, column: 3, scope: !149)
!170 = !DILocation(line: 62, column: 25, scope: !167)
!171 = !DILocation(line: 62, column: 5, scope: !167)
!172 = !DILocation(line: 61, column: 39, scope: !167)
!173 = distinct !{!173, !169, !174, !136, !137}
!174 = !DILocation(line: 62, column: 45, scope: !149)
!175 = !DILocation(line: 65, column: 3, scope: !144)
!176 = !DILocation(line: 65, column: 13, scope: !144)
!177 = !DILocation(line: 66, column: 3, scope: !144)
!178 = !DILocation(line: 0, scope: !152)
!179 = !DILocation(line: 68, column: 23, scope: !180)
!180 = distinct !DILexicalBlock(scope: !152, file: !10, line: 68, column: 3)
!181 = !DILocation(line: 68, column: 21, scope: !180)
!182 = !DILocation(line: 68, column: 3, scope: !152)
!183 = !DILocation(line: 69, column: 21, scope: !184)
!184 = distinct !DILexicalBlock(scope: !180, file: !10, line: 68, column: 43)
!185 = !DILocation(line: 69, column: 45, scope: !184)
!186 = !DILocation(line: 69, column: 5, scope: !184)
!187 = !DILocation(line: 71, column: 18, scope: !184)
!188 = !DILocation(line: 72, column: 3, scope: !184)
!189 = !DILocation(line: 68, column: 39, scope: !180)
!190 = distinct !{!190, !182, !191, !136, !137}
!191 = !DILocation(line: 72, column: 3, scope: !152)
!192 = !DILocation(line: 75, column: 3, scope: !144)
!193 = !DILocation(line: 75, column: 10, scope: !144)
!194 = distinct !{!194, !192, !195, !136, !137}
!195 = !DILocation(line: 75, column: 24, scope: !144)
!196 = !DILocation(line: 77, column: 8, scope: !144)
!197 = !DILocation(line: 77, column: 3, scope: !144)
!198 = !DILocation(line: 79, column: 10, scope: !144)
!199 = !DILocation(line: 80, column: 1, scope: !144)
!200 = !DILocation(line: 79, column: 3, scope: !144)
!201 = !DISubprogram(name: "malloc", scope: !202, file: !202, line: 672, type: !203, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!202 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!203 = !DISubroutineType(types: !204)
!204 = !{!6, !205}
!205 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !206, line: 18, baseType: !51)
!206 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!207 = !DISubprogram(name: "calloc", scope: !202, file: !202, line: 675, type: !208, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!208 = !DISubroutineType(types: !209)
!209 = !{!6, !205, !205}
!210 = !DISubprogram(name: "pthread_mutex_init", scope: !95, file: !95, line: 781, type: !211, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!211 = !DISubroutineType(types: !212)
!212 = !{!5, !58, !213}
!213 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !214, size: 64)
!214 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !215)
!215 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !14, line: 36, baseType: !216)
!216 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !14, line: 32, size: 32, elements: !217)
!217 = !{!218, !222}
!218 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !216, file: !14, line: 34, baseType: !219, size: 32)
!219 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 32, elements: !220)
!220 = !{!221}
!221 = !DISubrange(count: 4)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !216, file: !14, line: 35, baseType: !5, size: 32)
!223 = !DISubprogram(name: "pthread_create", scope: !95, file: !95, line: 202, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!224 = !DISubroutineType(types: !225)
!225 = !{!5, !226, !227, !238, !239}
!226 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !49)
!227 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !228)
!228 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !229, size: 64)
!229 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !230)
!230 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !14, line: 62, baseType: !231)
!231 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !14, line: 56, size: 448, elements: !232)
!232 = !{!233, !237}
!233 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !231, file: !14, line: 58, baseType: !234, size: 448)
!234 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 448, elements: !235)
!235 = !{!236}
!236 = !DISubrange(count: 56)
!237 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !231, file: !14, line: 59, baseType: !44, size: 64)
!238 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!239 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!240 = !DISubprogram(name: "free", scope: !202, file: !202, line: 687, type: !241, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!241 = !DISubroutineType(types: !242)
!242 = !{null, !6}
