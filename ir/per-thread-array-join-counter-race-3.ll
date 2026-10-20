; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-join-counter-race-3.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }

@threads_alive = dso_local global i32 0, align 4, !dbg !0
@threads_alive_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !8
@threads_alive_cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !43
@data = dso_local global i32 0, align 4, !dbg !78
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !80
@flags_mutex = dso_local global ptr null, align 8, !dbg !93
@flags = dso_local global ptr null, align 8, !dbg !89
@threads_total = dso_local global i32 0, align 4, !dbg !82
@tids = dso_local global ptr null, align 8, !dbg !84

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !103 {
entry:
    #dbg_value(ptr %arg, !107, !DIExpression(), !109)
  %0 = ptrtoint ptr %arg to i32, !dbg !110
    #dbg_value(i32 %0, !108, !DIExpression(), !109)
  %call = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #6, !dbg !111
  store i32 4, ptr @data, align 4, !dbg !112, !tbaa !113
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #6, !dbg !117
  %1 = load ptr, ptr @flags_mutex, align 8, !dbg !118, !tbaa !119
  %idxprom = sext i32 %0 to i64, !dbg !118
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %1, i64 %idxprom, !dbg !118
  %call2 = call i32 @pthread_mutex_lock(ptr noundef %arrayidx) #6, !dbg !121
  %2 = load ptr, ptr @flags, align 8, !dbg !122, !tbaa !123
  %idxprom3 = sext i32 %0 to i64, !dbg !122
  %arrayidx4 = getelementptr inbounds i8, ptr %2, i64 %idxprom3, !dbg !122
  store i8 1, ptr %arrayidx4, align 1, !dbg !125, !tbaa !126
  %3 = load ptr, ptr @flags_mutex, align 8, !dbg !128, !tbaa !119
  %idxprom5 = sext i32 %0 to i64, !dbg !128
  %arrayidx6 = getelementptr inbounds %union.pthread_mutex_t, ptr %3, i64 %idxprom5, !dbg !128
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef %arrayidx6) #6, !dbg !129
  ret ptr null, !dbg !130
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind
declare !dbg !131 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !135 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @cleaner(ptr noundef %arg) #0 !dbg !136 {
entry:
    #dbg_value(ptr %arg, !138, !DIExpression(), !142)
  br label %while.body, !dbg !143

while.body:                                       ; preds = %entry, %for.end
    #dbg_value(i32 0, !139, !DIExpression(), !144)
  %0 = load i32, ptr @threads_total, align 4, !dbg !145, !tbaa !113
  %cmp7 = icmp slt i32 0, %0, !dbg !147
  br i1 %cmp7, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !148

for.body.lr.ph:                                   ; preds = %while.body
  br label %for.body, !dbg !148

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !148

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %while.body
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !139, !DIExpression(), !144)
  %1 = load ptr, ptr @flags_mutex, align 8, !dbg !149, !tbaa !119
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %1, i64 %indvars.iv, !dbg !149
  %call = call i32 @pthread_mutex_lock(ptr noundef %arrayidx) #6, !dbg !151
  %2 = load ptr, ptr @flags, align 8, !dbg !152, !tbaa !123
  %arrayidx2 = getelementptr inbounds i8, ptr %2, i64 %indvars.iv, !dbg !152
  %3 = load i8, ptr %arrayidx2, align 1, !dbg !152, !tbaa !126, !range !154, !noundef !155
  %loadedv = trunc i8 %3 to i1, !dbg !152
  br i1 %loadedv, label %if.then, label %if.end, !dbg !152

if.then:                                          ; preds = %for.body
  %4 = load ptr, ptr @tids, align 8, !dbg !156, !tbaa !158
  %arrayidx4 = getelementptr inbounds i64, ptr %4, i64 %indvars.iv, !dbg !156
  %5 = load i64, ptr %arrayidx4, align 8, !dbg !156, !tbaa !160
  %call5 = call i32 @pthread_join(i64 noundef %5, ptr noundef null), !dbg !162
  %call6 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #6, !dbg !163
  %6 = load i32, ptr @threads_alive, align 4, !dbg !164, !tbaa !113
  %sub = sub nsw i32 %6, 2, !dbg !164
  store i32 %sub, ptr @threads_alive, align 4, !dbg !164, !tbaa !113
  %call7 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #6, !dbg !165
  %call8 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #6, !dbg !166
  %7 = load ptr, ptr @flags, align 8, !dbg !167, !tbaa !123
  %arrayidx10 = getelementptr inbounds i8, ptr %7, i64 %indvars.iv, !dbg !167
  store i8 0, ptr %arrayidx10, align 1, !dbg !168, !tbaa !126
  br label %if.end, !dbg !169

if.end:                                           ; preds = %if.then, %for.body
  %8 = load ptr, ptr @flags_mutex, align 8, !dbg !170, !tbaa !119
  %arrayidx12 = getelementptr inbounds %union.pthread_mutex_t, ptr %8, i64 %indvars.iv, !dbg !170
  %call13 = call i32 @pthread_mutex_unlock(ptr noundef %arrayidx12) #6, !dbg !171
  br label %for.inc, !dbg !172

for.inc:                                          ; preds = %if.end
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !173
    #dbg_value(i64 %indvars.iv.next, !139, !DIExpression(), !144)
  %9 = load i32, ptr @threads_total, align 4, !dbg !145, !tbaa !113
  %10 = sext i32 %9 to i64, !dbg !147
  %cmp = icmp slt i64 %indvars.iv.next, %10, !dbg !147
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !148, !llvm.loop !174

for.end:                                          ; preds = %for.cond.cleanup
  br label %while.body, !dbg !143, !llvm.loop !178
}

declare !dbg !180 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !184 i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !188 {
entry:
  %cleaner_tid = alloca i64, align 8
  store i32 4, ptr @threads_total, align 4, !dbg !197, !tbaa !113
  %0 = load i32, ptr @threads_total, align 4, !dbg !198, !tbaa !113
  %conv = sext i32 %0 to i64, !dbg !198
  %mul = mul i64 %conv, 8, !dbg !199
  %call = call noalias ptr @malloc(i64 noundef %mul) #7, !dbg !200
  store ptr %call, ptr @tids, align 8, !dbg !201, !tbaa !158
  %1 = load i32, ptr @threads_total, align 4, !dbg !202, !tbaa !113
  %conv1 = sext i32 %1 to i64, !dbg !202
  %call2 = call noalias ptr @calloc(i64 noundef %conv1, i64 noundef 1) #8, !dbg !203
  store ptr %call2, ptr @flags, align 8, !dbg !204, !tbaa !123
  %2 = load i32, ptr @threads_total, align 4, !dbg !205, !tbaa !113
  %conv3 = sext i32 %2 to i64, !dbg !205
  %mul4 = mul i64 %conv3, 40, !dbg !206
  %call5 = call noalias ptr @malloc(i64 noundef %mul4) #7, !dbg !207
  store ptr %call5, ptr @flags_mutex, align 8, !dbg !208, !tbaa !119
    #dbg_value(i32 0, !192, !DIExpression(), !209)
  %3 = load i32, ptr @threads_total, align 4, !dbg !210, !tbaa !113
  %cmp6 = icmp slt i32 0, %3, !dbg !212
  br i1 %cmp6, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !213

for.body.lr.ph:                                   ; preds = %entry
  br label %for.body, !dbg !213

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !213

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %entry
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !192, !DIExpression(), !209)
  %4 = load ptr, ptr @flags_mutex, align 8, !dbg !214, !tbaa !119
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %4, i64 %indvars.iv, !dbg !214
  %call7 = call i32 @pthread_mutex_init(ptr noundef %arrayidx, ptr noundef null) #6, !dbg !215
  br label %for.inc, !dbg !215

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !216
    #dbg_value(i64 %indvars.iv.next, !192, !DIExpression(), !209)
  %5 = load i32, ptr @threads_total, align 4, !dbg !210, !tbaa !113
  %6 = sext i32 %5 to i64, !dbg !212
  %cmp = icmp slt i64 %indvars.iv.next, %6, !dbg !212
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !213, !llvm.loop !217

for.end:                                          ; preds = %for.cond.cleanup
  call void @llvm.lifetime.start.p0(i64 8, ptr %cleaner_tid) #6, !dbg !219
    #dbg_declare(ptr %cleaner_tid, !194, !DIExpression(), !220)
  %call8 = call i32 @pthread_create(ptr noundef %cleaner_tid, ptr noundef null, ptr noundef @cleaner, ptr noundef null) #6, !dbg !221
    #dbg_value(i32 0, !195, !DIExpression(), !222)
  %7 = load i32, ptr @threads_total, align 4, !dbg !223, !tbaa !113
  %cmp119 = icmp slt i32 0, %7, !dbg !225
  br i1 %cmp119, label %for.body14.lr.ph, label %for.cond.cleanup13, !dbg !226

for.body14.lr.ph:                                 ; preds = %for.end
  br label %for.body14, !dbg !226

for.cond10.for.cond.cleanup13_crit_edge:          ; preds = %for.inc23
  br label %for.cond.cleanup13, !dbg !226

for.cond.cleanup13:                               ; preds = %for.cond10.for.cond.cleanup13_crit_edge, %for.end
  br label %for.end25

for.body14:                                       ; preds = %for.body14.lr.ph, %for.inc23
  %indvars.iv11 = phi i64 [ 0, %for.body14.lr.ph ], [ %indvars.iv.next12, %for.inc23 ]
    #dbg_value(i64 %indvars.iv11, !195, !DIExpression(), !222)
  %8 = load ptr, ptr @tids, align 8, !dbg !227, !tbaa !158
  %arrayidx16 = getelementptr inbounds i64, ptr %8, i64 %indvars.iv11, !dbg !227
  %9 = inttoptr i64 %indvars.iv11 to ptr, !dbg !229
  %call18 = call i32 @pthread_create(ptr noundef %arrayidx16, ptr noundef null, ptr noundef @thread, ptr noundef %9) #6, !dbg !230
  %call19 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #6, !dbg !231
  %10 = load i32, ptr @threads_alive, align 4, !dbg !232, !tbaa !113
  %inc20 = add nsw i32 %10, 1, !dbg !232
  store i32 %inc20, ptr @threads_alive, align 4, !dbg !232, !tbaa !113
  %call21 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #6, !dbg !233
  %call22 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #6, !dbg !234
  br label %for.inc23, !dbg !235

for.inc23:                                        ; preds = %for.body14
  %indvars.iv.next12 = add nuw nsw i64 %indvars.iv11, 1, !dbg !236
    #dbg_value(i64 %indvars.iv.next12, !195, !DIExpression(), !222)
  %11 = load i32, ptr @threads_total, align 4, !dbg !223, !tbaa !113
  %12 = sext i32 %11 to i64, !dbg !225
  %cmp11 = icmp slt i64 %indvars.iv.next12, %12, !dbg !225
  br i1 %cmp11, label %for.body14, label %for.cond10.for.cond.cleanup13_crit_edge, !dbg !226, !llvm.loop !237

for.end25:                                        ; preds = %for.cond.cleanup13
  %call26 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #6, !dbg !239
  %13 = load i32, ptr @threads_alive, align 4, !dbg !240, !tbaa !113
  %tobool14 = icmp ne i32 %13, 0, !dbg !241
  br i1 %tobool14, label %while.body.lr.ph, label %while.end, !dbg !241

while.body.lr.ph:                                 ; preds = %for.end25
  br label %while.body, !dbg !241

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call27 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !242
  %14 = load i32, ptr @threads_alive, align 4, !dbg !240, !tbaa !113
  %tobool = icmp ne i32 %14, 0, !dbg !241
  br i1 %tobool, label %while.body, label %while.cond.while.end_crit_edge, !dbg !241, !llvm.loop !243

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !241

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %for.end25
  %call28 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #6, !dbg !245
  %15 = load ptr, ptr @tids, align 8, !dbg !246, !tbaa !158
  call void @free(ptr noundef %15) #6, !dbg !247
  %16 = load i32, ptr @data, align 4, !dbg !248, !tbaa !113
  call void @llvm.lifetime.end.p0(i64 8, ptr %cleaner_tid) #6, !dbg !249
  ret i32 %16, !dbg !250
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !251 noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind allocsize(0,1)
declare !dbg !257 noalias ptr @calloc(i64 noundef, i64 noundef) #5

; Function Attrs: nounwind
declare !dbg !260 i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !273 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !290 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !295 void @free(ptr noundef) #2

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
!llvm.ident = !{!96}
!llvm.module.flags = !{!97, !98, !99, !100, !101, !102}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !10, line: 17, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-join-counter-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "d1b1484810ad52e1073bda799f245784")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8, !43, !78, !80, !82, !84, !89, !93}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "threads_alive_mutex", scope: !2, file: !10, line: 18, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "per-thread-array-join-counter-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "d1b1484810ad52e1073bda799f245784")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !12, line: 72, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!13 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 67, size: 320, elements: !14)
!14 = !{!15, !36, !41}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !13, file: !12, line: 69, baseType: !16, size: 320)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !17, line: 22, size: 320, elements: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!18 = !{!19, !20, !22, !23, !24, !25, !27, !28}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !16, file: !17, line: 24, baseType: !5, size: 32)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !16, file: !17, line: 25, baseType: !21, size: 32, offset: 32)
!21 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !16, file: !17, line: 26, baseType: !5, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !16, file: !17, line: 28, baseType: !21, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !16, file: !17, line: 32, baseType: !5, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !16, file: !17, line: 34, baseType: !26, size: 16, offset: 160)
!26 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !16, file: !17, line: 35, baseType: !26, size: 16, offset: 176)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !16, file: !17, line: 36, baseType: !29, size: 128, offset: 192)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !30, line: 55, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !30, line: 51, size: 128, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !31, file: !30, line: 53, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !31, file: !30, line: 54, baseType: !34, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !13, file: !12, line: 70, baseType: !37, size: 320)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 320, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 40)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !13, file: !12, line: 71, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "threads_alive_cond", scope: !2, file: !10, line: 19, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !12, line: 80, baseType: !46)
!46 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 75, size: 384, elements: !47)
!47 = !{!48, !72, !76}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !46, file: !12, line: 77, baseType: !49, size: 384)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !30, line: 94, size: 384, elements: !50)
!50 = !{!51, !63, !64, !68, !69, !70, !71}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !49, file: !30, line: 96, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !53, line: 33, baseType: !54)
!53 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ec99b0f6e36c0a42ac284d459cbd38")
!54 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !53, line: 25, size: 64, elements: !55)
!55 = !{!56, !58}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !54, file: !53, line: 27, baseType: !57, size: 64)
!57 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !54, file: !53, line: 32, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !54, file: !53, line: 28, size: 64, elements: !60)
!60 = !{!61, !62}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !59, file: !53, line: 30, baseType: !21, size: 32)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !59, file: !53, line: 31, baseType: !21, size: 32, offset: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !49, file: !30, line: 97, baseType: !52, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__g_refs", scope: !49, file: !30, line: 98, baseType: !65, size: 64, offset: 128)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 64, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 2)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !49, file: !30, line: 99, baseType: !65, size: 64, offset: 192)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !49, file: !30, line: 100, baseType: !21, size: 32, offset: 256)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !49, file: !30, line: 101, baseType: !21, size: 32, offset: 288)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !49, file: !30, line: 102, baseType: !65, size: 64, offset: 320)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !46, file: !12, line: 78, baseType: !73, size: 384)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 384, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 48)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !46, file: !12, line: 79, baseType: !77, size: 64)
!77 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !10, line: 25, type: !5, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !10, line: 26, type: !11, isLocal: false, isDefinition: true)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(name: "threads_total", scope: !2, file: !10, line: 16, type: !5, isLocal: false, isDefinition: true)
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(name: "tids", scope: !2, file: !10, line: 21, type: !86, isLocal: false, isDefinition: true)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !12, line: 27, baseType: !88)
!88 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!89 = !DIGlobalVariableExpression(var: !90, expr: !DIExpression())
!90 = distinct !DIGlobalVariable(name: "flags", scope: !2, file: !10, line: 22, type: !91, isLocal: false, isDefinition: true)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!93 = !DIGlobalVariableExpression(var: !94, expr: !DIExpression())
!94 = distinct !DIGlobalVariable(name: "flags_mutex", scope: !2, file: !10, line: 23, type: !95, isLocal: false, isDefinition: true)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!96 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!97 = !{i32 7, !"Dwarf Version", i32 5}
!98 = !{i32 2, !"Debug Info Version", i32 3}
!99 = !{i32 1, !"wchar_size", i32 4}
!100 = !{i32 8, !"PIC Level", i32 2}
!101 = !{i32 7, !"PIE Level", i32 2}
!102 = !{i32 7, !"uwtable", i32 2}
!103 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 28, type: !104, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !106)
!104 = !DISubroutineType(types: !105)
!105 = !{!6, !6}
!106 = !{!107, !108}
!107 = !DILocalVariable(name: "arg", arg: 1, scope: !103, file: !10, line: 28, type: !6)
!108 = !DILocalVariable(name: "i", scope: !103, file: !10, line: 29, type: !5)
!109 = !DILocation(line: 0, scope: !103)
!110 = !DILocation(line: 29, column: 11, scope: !103)
!111 = !DILocation(line: 31, column: 3, scope: !103)
!112 = !DILocation(line: 32, column: 8, scope: !103)
!113 = !{!114, !114, i64 0}
!114 = !{!"int", !115, i64 0}
!115 = !{!"omnipotent char", !116, i64 0}
!116 = !{!"Simple C/C++ TBAA"}
!117 = !DILocation(line: 33, column: 3, scope: !103)
!118 = !DILocation(line: 35, column: 23, scope: !103)
!119 = !{!120, !120, i64 0}
!120 = !{!"any pointer", !115, i64 0}
!121 = !DILocation(line: 35, column: 3, scope: !103)
!122 = !DILocation(line: 36, column: 3, scope: !103)
!123 = !{!124, !124, i64 0}
!124 = !{!"p1 _Bool", !120, i64 0}
!125 = !DILocation(line: 36, column: 12, scope: !103)
!126 = !{!127, !127, i64 0}
!127 = !{!"_Bool", !115, i64 0}
!128 = !DILocation(line: 37, column: 25, scope: !103)
!129 = !DILocation(line: 37, column: 3, scope: !103)
!130 = !DILocation(line: 38, column: 3, scope: !103)
!131 = !DISubprogram(name: "pthread_mutex_lock", scope: !132, file: !132, line: 794, type: !133, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!132 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!133 = !DISubroutineType(types: !134)
!134 = !{!5, !95}
!135 = !DISubprogram(name: "pthread_mutex_unlock", scope: !132, file: !132, line: 835, type: !133, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!136 = distinct !DISubprogram(name: "cleaner", scope: !10, file: !10, line: 41, type: !104, scopeLine: 41, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !137)
!137 = !{!138, !139}
!138 = !DILocalVariable(name: "arg", arg: 1, scope: !136, file: !10, line: 41, type: !6)
!139 = !DILocalVariable(name: "i", scope: !140, file: !10, line: 43, type: !5)
!140 = distinct !DILexicalBlock(scope: !141, file: !10, line: 43, column: 5)
!141 = distinct !DILexicalBlock(scope: !136, file: !10, line: 42, column: 13)
!142 = !DILocation(line: 0, scope: !136)
!143 = !DILocation(line: 42, column: 3, scope: !136)
!144 = !DILocation(line: 0, scope: !140)
!145 = !DILocation(line: 43, column: 25, scope: !146)
!146 = distinct !DILexicalBlock(scope: !140, file: !10, line: 43, column: 5)
!147 = !DILocation(line: 43, column: 23, scope: !146)
!148 = !DILocation(line: 43, column: 5, scope: !140)
!149 = !DILocation(line: 44, column: 27, scope: !150)
!150 = distinct !DILexicalBlock(scope: !146, file: !10, line: 43, column: 45)
!151 = !DILocation(line: 44, column: 7, scope: !150)
!152 = !DILocation(line: 45, column: 11, scope: !153)
!153 = distinct !DILexicalBlock(scope: !150, file: !10, line: 45, column: 11)
!154 = !{i8 0, i8 2}
!155 = !{}
!156 = !DILocation(line: 46, column: 22, scope: !157)
!157 = distinct !DILexicalBlock(scope: !153, file: !10, line: 45, column: 21)
!158 = !{!159, !159, i64 0}
!159 = !{!"p1 long", !120, i64 0}
!160 = !{!161, !161, i64 0}
!161 = !{!"long", !115, i64 0}
!162 = !DILocation(line: 46, column: 9, scope: !157)
!163 = !DILocation(line: 47, column: 9, scope: !157)
!164 = !DILocation(line: 48, column: 23, scope: !157)
!165 = !DILocation(line: 49, column: 9, scope: !157)
!166 = !DILocation(line: 50, column: 9, scope: !157)
!167 = !DILocation(line: 51, column: 9, scope: !157)
!168 = !DILocation(line: 51, column: 18, scope: !157)
!169 = !DILocation(line: 52, column: 7, scope: !157)
!170 = !DILocation(line: 53, column: 29, scope: !150)
!171 = !DILocation(line: 53, column: 7, scope: !150)
!172 = !DILocation(line: 54, column: 5, scope: !150)
!173 = !DILocation(line: 43, column: 41, scope: !146)
!174 = distinct !{!174, !148, !175, !176, !177}
!175 = !DILocation(line: 54, column: 5, scope: !140)
!176 = !{!"llvm.loop.mustprogress"}
!177 = !{!"llvm.loop.unroll.disable"}
!178 = distinct !{!178, !143, !179, !177}
!179 = !DILocation(line: 55, column: 3, scope: !136)
!180 = !DISubprogram(name: "pthread_join", scope: !132, file: !132, line: 219, type: !181, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!181 = !DISubroutineType(types: !182)
!182 = !{!5, !87, !183}
!183 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!184 = !DISubprogram(name: "pthread_cond_signal", scope: !132, file: !132, line: 1121, type: !185, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!185 = !DISubroutineType(types: !186)
!186 = !{!5, !187}
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!188 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 59, type: !189, scopeLine: 59, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !191)
!189 = !DISubroutineType(types: !190)
!190 = !{!5}
!191 = !{!192, !194, !195}
!192 = !DILocalVariable(name: "i", scope: !193, file: !10, line: 66, type: !5)
!193 = distinct !DILexicalBlock(scope: !188, file: !10, line: 66, column: 3)
!194 = !DILocalVariable(name: "cleaner_tid", scope: !188, file: !10, line: 70, type: !87)
!195 = !DILocalVariable(name: "i", scope: !196, file: !10, line: 73, type: !5)
!196 = distinct !DILexicalBlock(scope: !188, file: !10, line: 73, column: 3)
!197 = !DILocation(line: 60, column: 17, scope: !188)
!198 = !DILocation(line: 62, column: 17, scope: !188)
!199 = !DILocation(line: 62, column: 31, scope: !188)
!200 = !DILocation(line: 62, column: 10, scope: !188)
!201 = !DILocation(line: 62, column: 8, scope: !188)
!202 = !DILocation(line: 63, column: 18, scope: !188)
!203 = !DILocation(line: 63, column: 11, scope: !188)
!204 = !DILocation(line: 63, column: 9, scope: !188)
!205 = !DILocation(line: 64, column: 24, scope: !188)
!206 = !DILocation(line: 64, column: 38, scope: !188)
!207 = !DILocation(line: 64, column: 17, scope: !188)
!208 = !DILocation(line: 64, column: 15, scope: !188)
!209 = !DILocation(line: 0, scope: !193)
!210 = !DILocation(line: 66, column: 23, scope: !211)
!211 = distinct !DILexicalBlock(scope: !193, file: !10, line: 66, column: 3)
!212 = !DILocation(line: 66, column: 21, scope: !211)
!213 = !DILocation(line: 66, column: 3, scope: !193)
!214 = !DILocation(line: 67, column: 25, scope: !211)
!215 = !DILocation(line: 67, column: 5, scope: !211)
!216 = !DILocation(line: 66, column: 39, scope: !211)
!217 = distinct !{!217, !213, !218, !176, !177}
!218 = !DILocation(line: 67, column: 45, scope: !193)
!219 = !DILocation(line: 70, column: 3, scope: !188)
!220 = !DILocation(line: 70, column: 13, scope: !188)
!221 = !DILocation(line: 71, column: 3, scope: !188)
!222 = !DILocation(line: 0, scope: !196)
!223 = !DILocation(line: 73, column: 23, scope: !224)
!224 = distinct !DILexicalBlock(scope: !196, file: !10, line: 73, column: 3)
!225 = !DILocation(line: 73, column: 21, scope: !224)
!226 = !DILocation(line: 73, column: 3, scope: !196)
!227 = !DILocation(line: 74, column: 21, scope: !228)
!228 = distinct !DILexicalBlock(scope: !224, file: !10, line: 73, column: 43)
!229 = !DILocation(line: 74, column: 45, scope: !228)
!230 = !DILocation(line: 74, column: 5, scope: !228)
!231 = !DILocation(line: 76, column: 5, scope: !228)
!232 = !DILocation(line: 77, column: 18, scope: !228)
!233 = !DILocation(line: 78, column: 5, scope: !228)
!234 = !DILocation(line: 79, column: 5, scope: !228)
!235 = !DILocation(line: 80, column: 3, scope: !228)
!236 = !DILocation(line: 73, column: 39, scope: !224)
!237 = distinct !{!237, !226, !238, !176, !177}
!238 = !DILocation(line: 80, column: 3, scope: !196)
!239 = !DILocation(line: 83, column: 3, scope: !188)
!240 = !DILocation(line: 84, column: 10, scope: !188)
!241 = !DILocation(line: 84, column: 3, scope: !188)
!242 = !DILocation(line: 85, column: 5, scope: !188)
!243 = distinct !{!243, !241, !244, !176, !177}
!244 = !DILocation(line: 85, column: 64, scope: !188)
!245 = !DILocation(line: 86, column: 3, scope: !188)
!246 = !DILocation(line: 88, column: 8, scope: !188)
!247 = !DILocation(line: 88, column: 3, scope: !188)
!248 = !DILocation(line: 90, column: 10, scope: !188)
!249 = !DILocation(line: 91, column: 1, scope: !188)
!250 = !DILocation(line: 90, column: 3, scope: !188)
!251 = !DISubprogram(name: "malloc", scope: !252, file: !252, line: 672, type: !253, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!252 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!253 = !DISubroutineType(types: !254)
!254 = !{!6, !255}
!255 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !256, line: 18, baseType: !88)
!256 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!257 = !DISubprogram(name: "calloc", scope: !252, file: !252, line: 675, type: !258, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!258 = !DISubroutineType(types: !259)
!259 = !{!6, !255, !255}
!260 = !DISubprogram(name: "pthread_mutex_init", scope: !132, file: !132, line: 781, type: !261, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!261 = !DISubroutineType(types: !262)
!262 = !{!5, !95, !263}
!263 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !264, size: 64)
!264 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !265)
!265 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !12, line: 36, baseType: !266)
!266 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 32, size: 32, elements: !267)
!267 = !{!268, !272}
!268 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !266, file: !12, line: 34, baseType: !269, size: 32)
!269 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 32, elements: !270)
!270 = !{!271}
!271 = !DISubrange(count: 4)
!272 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !266, file: !12, line: 35, baseType: !5, size: 32)
!273 = !DISubprogram(name: "pthread_create", scope: !132, file: !132, line: 202, type: !274, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!274 = !DISubroutineType(types: !275)
!275 = !{!5, !276, !277, !288, !289}
!276 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !86)
!277 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !278)
!278 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !279, size: 64)
!279 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !280)
!280 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !12, line: 62, baseType: !281)
!281 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !12, line: 56, size: 448, elements: !282)
!282 = !{!283, !287}
!283 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !281, file: !12, line: 58, baseType: !284, size: 448)
!284 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !285)
!285 = !{!286}
!286 = !DISubrange(count: 56)
!287 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !281, file: !12, line: 59, baseType: !42, size: 64)
!288 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!289 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!290 = !DISubprogram(name: "pthread_cond_wait", scope: !132, file: !132, line: 1133, type: !291, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!291 = !DISubroutineType(types: !292)
!292 = !{!5, !293, !294}
!293 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !187)
!294 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !95)
!295 = !DISubprogram(name: "free", scope: !252, file: !252, line: 687, type: !296, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!296 = !DISubroutineType(types: !297)
!297 = !{null, !6}
