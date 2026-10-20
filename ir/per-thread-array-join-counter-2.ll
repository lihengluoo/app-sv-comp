; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-join-counter-2.linked.bc'
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
@datas_mutex = dso_local global ptr null, align 8, !dbg !89
@datas = dso_local global ptr null, align 8, !dbg !85
@threads_total = dso_local global i32 0, align 4, !dbg !78
@tids = dso_local global ptr null, align 8, !dbg !80

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !99 {
entry:
    #dbg_value(ptr %arg, !103, !DIExpression(), !105)
  %0 = ptrtoint ptr %arg to i32, !dbg !106
    #dbg_value(i32 %0, !104, !DIExpression(), !105)
  %1 = load ptr, ptr @datas_mutex, align 8, !dbg !107, !tbaa !108
  %idxprom = sext i32 %0 to i64, !dbg !107
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %1, i64 %idxprom, !dbg !107
  %call = call i32 @pthread_mutex_lock(ptr noundef %arrayidx) #6, !dbg !112
  %2 = load ptr, ptr @datas, align 8, !dbg !113, !tbaa !114
  %idxprom1 = sext i32 %0 to i64, !dbg !113
  %arrayidx2 = getelementptr inbounds i8, ptr %2, i64 %idxprom1, !dbg !113
  store i8 1, ptr %arrayidx2, align 1, !dbg !116, !tbaa !117
  %3 = load ptr, ptr @datas_mutex, align 8, !dbg !119, !tbaa !108
  %idxprom3 = sext i32 %0 to i64, !dbg !119
  %arrayidx4 = getelementptr inbounds %union.pthread_mutex_t, ptr %3, i64 %idxprom3, !dbg !119
  %call5 = call i32 @pthread_mutex_unlock(ptr noundef %arrayidx4) #6, !dbg !120
  ret ptr null, !dbg !121
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind
declare !dbg !122 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !126 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @cleaner(ptr noundef %arg) #0 !dbg !127 {
entry:
    #dbg_value(ptr %arg, !129, !DIExpression(), !133)
  br label %while.body, !dbg !134

while.body:                                       ; preds = %entry, %for.end
    #dbg_value(i32 0, !130, !DIExpression(), !135)
  %0 = load i32, ptr @threads_total, align 4, !dbg !136, !tbaa !138
  %cmp7 = icmp slt i32 0, %0, !dbg !140
  br i1 %cmp7, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !141

for.body.lr.ph:                                   ; preds = %while.body
  br label %for.body, !dbg !141

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !141

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %while.body
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !130, !DIExpression(), !135)
  %1 = load ptr, ptr @datas_mutex, align 8, !dbg !142, !tbaa !108
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %1, i64 %indvars.iv, !dbg !142
  %call = call i32 @pthread_mutex_lock(ptr noundef %arrayidx) #6, !dbg !144
  %2 = load ptr, ptr @datas, align 8, !dbg !145, !tbaa !114
  %arrayidx2 = getelementptr inbounds i8, ptr %2, i64 %indvars.iv, !dbg !145
  %3 = load i8, ptr %arrayidx2, align 1, !dbg !145, !tbaa !117, !range !147, !noundef !148
  %loadedv = trunc i8 %3 to i1, !dbg !145
  br i1 %loadedv, label %if.then, label %if.end, !dbg !145

if.then:                                          ; preds = %for.body
  %4 = load ptr, ptr @datas, align 8, !dbg !149, !tbaa !114
  %arrayidx4 = getelementptr inbounds i8, ptr %4, i64 %indvars.iv, !dbg !149
  store i8 0, ptr %arrayidx4, align 1, !dbg !151, !tbaa !117
  %5 = load ptr, ptr @tids, align 8, !dbg !152, !tbaa !153
  %arrayidx6 = getelementptr inbounds i64, ptr %5, i64 %indvars.iv, !dbg !152
  %6 = load i64, ptr %arrayidx6, align 8, !dbg !152, !tbaa !155
  %call7 = call i32 @pthread_join(i64 noundef %6, ptr noundef null), !dbg !157
  %call8 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #6, !dbg !158
  %7 = load i32, ptr @threads_alive, align 4, !dbg !159, !tbaa !138
  %dec = add nsw i32 %7, -1, !dbg !159
  store i32 %dec, ptr @threads_alive, align 4, !dbg !159, !tbaa !138
  %call9 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #6, !dbg !160
  %call10 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #6, !dbg !161
  br label %if.end, !dbg !162

if.end:                                           ; preds = %if.then, %for.body
  %8 = load ptr, ptr @datas_mutex, align 8, !dbg !163, !tbaa !108
  %arrayidx12 = getelementptr inbounds %union.pthread_mutex_t, ptr %8, i64 %indvars.iv, !dbg !163
  %call13 = call i32 @pthread_mutex_unlock(ptr noundef %arrayidx12) #6, !dbg !164
  br label %for.inc, !dbg !165

for.inc:                                          ; preds = %if.end
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !166
    #dbg_value(i64 %indvars.iv.next, !130, !DIExpression(), !135)
  %9 = load i32, ptr @threads_total, align 4, !dbg !136, !tbaa !138
  %10 = sext i32 %9 to i64, !dbg !140
  %cmp = icmp slt i64 %indvars.iv.next, %10, !dbg !140
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !141, !llvm.loop !167

for.end:                                          ; preds = %for.cond.cleanup
  br label %while.body, !dbg !134, !llvm.loop !171
}

declare !dbg !173 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !177 i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !181 {
entry:
  %cleaner_tid = alloca i64, align 8
  store i32 4, ptr @threads_total, align 4, !dbg !190, !tbaa !138
  %0 = load i32, ptr @threads_total, align 4, !dbg !191, !tbaa !138
  %conv = sext i32 %0 to i64, !dbg !191
  %mul = mul i64 %conv, 8, !dbg !192
  %call = call noalias ptr @malloc(i64 noundef %mul) #7, !dbg !193
  store ptr %call, ptr @tids, align 8, !dbg !194, !tbaa !153
  %1 = load i32, ptr @threads_total, align 4, !dbg !195, !tbaa !138
  %conv1 = sext i32 %1 to i64, !dbg !195
  %call2 = call noalias ptr @calloc(i64 noundef %conv1, i64 noundef 1) #8, !dbg !196
  store ptr %call2, ptr @datas, align 8, !dbg !197, !tbaa !114
  %2 = load i32, ptr @threads_total, align 4, !dbg !198, !tbaa !138
  %conv3 = sext i32 %2 to i64, !dbg !198
  %mul4 = mul i64 %conv3, 40, !dbg !199
  %call5 = call noalias ptr @malloc(i64 noundef %mul4) #7, !dbg !200
  store ptr %call5, ptr @datas_mutex, align 8, !dbg !201, !tbaa !108
    #dbg_value(i32 0, !185, !DIExpression(), !202)
  %3 = load i32, ptr @threads_total, align 4, !dbg !203, !tbaa !138
  %cmp6 = icmp slt i32 0, %3, !dbg !205
  br i1 %cmp6, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !206

for.body.lr.ph:                                   ; preds = %entry
  br label %for.body, !dbg !206

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !206

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %entry
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !185, !DIExpression(), !202)
  %4 = load ptr, ptr @datas_mutex, align 8, !dbg !207, !tbaa !108
  %arrayidx = getelementptr inbounds %union.pthread_mutex_t, ptr %4, i64 %indvars.iv, !dbg !207
  %call7 = call i32 @pthread_mutex_init(ptr noundef %arrayidx, ptr noundef null) #6, !dbg !208
  br label %for.inc, !dbg !208

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !209
    #dbg_value(i64 %indvars.iv.next, !185, !DIExpression(), !202)
  %5 = load i32, ptr @threads_total, align 4, !dbg !203, !tbaa !138
  %6 = sext i32 %5 to i64, !dbg !205
  %cmp = icmp slt i64 %indvars.iv.next, %6, !dbg !205
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !206, !llvm.loop !210

for.end:                                          ; preds = %for.cond.cleanup
  call void @llvm.lifetime.start.p0(i64 8, ptr %cleaner_tid) #6, !dbg !212
    #dbg_declare(ptr %cleaner_tid, !187, !DIExpression(), !213)
  %call8 = call i32 @pthread_create(ptr noundef %cleaner_tid, ptr noundef null, ptr noundef @cleaner, ptr noundef null) #6, !dbg !214
    #dbg_value(i32 0, !188, !DIExpression(), !215)
  %7 = load i32, ptr @threads_total, align 4, !dbg !216, !tbaa !138
  %cmp119 = icmp slt i32 0, %7, !dbg !218
  br i1 %cmp119, label %for.body14.lr.ph, label %for.cond.cleanup13, !dbg !219

for.body14.lr.ph:                                 ; preds = %for.end
  br label %for.body14, !dbg !219

for.cond10.for.cond.cleanup13_crit_edge:          ; preds = %for.inc23
  br label %for.cond.cleanup13, !dbg !219

for.cond.cleanup13:                               ; preds = %for.cond10.for.cond.cleanup13_crit_edge, %for.end
  br label %for.end25

for.body14:                                       ; preds = %for.body14.lr.ph, %for.inc23
  %indvars.iv11 = phi i64 [ 0, %for.body14.lr.ph ], [ %indvars.iv.next12, %for.inc23 ]
    #dbg_value(i64 %indvars.iv11, !188, !DIExpression(), !215)
  %8 = load ptr, ptr @tids, align 8, !dbg !220, !tbaa !153
  %arrayidx16 = getelementptr inbounds i64, ptr %8, i64 %indvars.iv11, !dbg !220
  %9 = inttoptr i64 %indvars.iv11 to ptr, !dbg !222
  %call18 = call i32 @pthread_create(ptr noundef %arrayidx16, ptr noundef null, ptr noundef @thread, ptr noundef %9) #6, !dbg !223
  %call19 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #6, !dbg !224
  %10 = load i32, ptr @threads_alive, align 4, !dbg !225, !tbaa !138
  %inc20 = add nsw i32 %10, 1, !dbg !225
  store i32 %inc20, ptr @threads_alive, align 4, !dbg !225, !tbaa !138
  %call21 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #6, !dbg !226
  %call22 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #6, !dbg !227
  br label %for.inc23, !dbg !228

for.inc23:                                        ; preds = %for.body14
  %indvars.iv.next12 = add nuw nsw i64 %indvars.iv11, 1, !dbg !229
    #dbg_value(i64 %indvars.iv.next12, !188, !DIExpression(), !215)
  %11 = load i32, ptr @threads_total, align 4, !dbg !216, !tbaa !138
  %12 = sext i32 %11 to i64, !dbg !218
  %cmp11 = icmp slt i64 %indvars.iv.next12, %12, !dbg !218
  br i1 %cmp11, label %for.body14, label %for.cond10.for.cond.cleanup13_crit_edge, !dbg !219, !llvm.loop !230

for.end25:                                        ; preds = %for.cond.cleanup13
  %call26 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #6, !dbg !232
  %13 = load i32, ptr @threads_alive, align 4, !dbg !233, !tbaa !138
  %tobool14 = icmp ne i32 %13, 0, !dbg !234
  br i1 %tobool14, label %while.body.lr.ph, label %while.end, !dbg !234

while.body.lr.ph:                                 ; preds = %for.end25
  br label %while.body, !dbg !234

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call27 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !235
  %14 = load i32, ptr @threads_alive, align 4, !dbg !233, !tbaa !138
  %tobool = icmp ne i32 %14, 0, !dbg !234
  br i1 %tobool, label %while.body, label %while.cond.while.end_crit_edge, !dbg !234, !llvm.loop !236

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !234

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %for.end25
  %call28 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #6, !dbg !238
  %15 = load ptr, ptr @tids, align 8, !dbg !239, !tbaa !153
  call void @free(ptr noundef %15) #6, !dbg !240
  %16 = load ptr, ptr @datas, align 8, !dbg !241, !tbaa !114
  %arrayidx29 = getelementptr inbounds i8, ptr %16, i64 0, !dbg !241
  %17 = load i8, ptr %arrayidx29, align 1, !dbg !241, !tbaa !117, !range !147, !noundef !148
  %loadedv = trunc i8 %17 to i1, !dbg !241
  %conv30 = zext i1 %loadedv to i32, !dbg !241
  call void @llvm.lifetime.end.p0(i64 8, ptr %cleaner_tid) #6, !dbg !242
  ret i32 %conv30, !dbg !243
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !244 noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind allocsize(0,1)
declare !dbg !250 noalias ptr @calloc(i64 noundef, i64 noundef) #5

; Function Attrs: nounwind
declare !dbg !253 i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !266 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !283 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !288 void @free(ptr noundef) #2

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
!llvm.ident = !{!92}
!llvm.module.flags = !{!93, !94, !95, !96, !97, !98}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !10, line: 17, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-join-counter-2.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "9590a4ac915ef2e617d6c4e871ab412e")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8, !43, !78, !80, !85, !89}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "threads_alive_mutex", scope: !2, file: !10, line: 18, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "per-thread-array-join-counter-2.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "9590a4ac915ef2e617d6c4e871ab412e")
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
!79 = distinct !DIGlobalVariable(name: "threads_total", scope: !2, file: !10, line: 16, type: !5, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "tids", scope: !2, file: !10, line: 21, type: !82, isLocal: false, isDefinition: true)
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !12, line: 27, baseType: !84)
!84 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !10, line: 22, type: !87, isLocal: false, isDefinition: true)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!89 = !DIGlobalVariableExpression(var: !90, expr: !DIExpression())
!90 = distinct !DIGlobalVariable(name: "datas_mutex", scope: !2, file: !10, line: 23, type: !91, isLocal: false, isDefinition: true)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!92 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!93 = !{i32 7, !"Dwarf Version", i32 5}
!94 = !{i32 2, !"Debug Info Version", i32 3}
!95 = !{i32 1, !"wchar_size", i32 4}
!96 = !{i32 8, !"PIC Level", i32 2}
!97 = !{i32 7, !"PIE Level", i32 2}
!98 = !{i32 7, !"uwtable", i32 2}
!99 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 25, type: !100, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !102)
!100 = !DISubroutineType(types: !101)
!101 = !{!6, !6}
!102 = !{!103, !104}
!103 = !DILocalVariable(name: "arg", arg: 1, scope: !99, file: !10, line: 25, type: !6)
!104 = !DILocalVariable(name: "i", scope: !99, file: !10, line: 26, type: !5)
!105 = !DILocation(line: 0, scope: !99)
!106 = !DILocation(line: 26, column: 11, scope: !99)
!107 = !DILocation(line: 27, column: 23, scope: !99)
!108 = !{!109, !109, i64 0}
!109 = !{!"any pointer", !110, i64 0}
!110 = !{!"omnipotent char", !111, i64 0}
!111 = !{!"Simple C/C++ TBAA"}
!112 = !DILocation(line: 27, column: 3, scope: !99)
!113 = !DILocation(line: 28, column: 3, scope: !99)
!114 = !{!115, !115, i64 0}
!115 = !{!"p1 _Bool", !109, i64 0}
!116 = !DILocation(line: 28, column: 12, scope: !99)
!117 = !{!118, !118, i64 0}
!118 = !{!"_Bool", !110, i64 0}
!119 = !DILocation(line: 29, column: 25, scope: !99)
!120 = !DILocation(line: 29, column: 3, scope: !99)
!121 = !DILocation(line: 30, column: 3, scope: !99)
!122 = !DISubprogram(name: "pthread_mutex_lock", scope: !123, file: !123, line: 794, type: !124, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!123 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!124 = !DISubroutineType(types: !125)
!125 = !{!5, !91}
!126 = !DISubprogram(name: "pthread_mutex_unlock", scope: !123, file: !123, line: 835, type: !124, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!127 = distinct !DISubprogram(name: "cleaner", scope: !10, file: !10, line: 33, type: !100, scopeLine: 33, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !128)
!128 = !{!129, !130}
!129 = !DILocalVariable(name: "arg", arg: 1, scope: !127, file: !10, line: 33, type: !6)
!130 = !DILocalVariable(name: "i", scope: !131, file: !10, line: 35, type: !5)
!131 = distinct !DILexicalBlock(scope: !132, file: !10, line: 35, column: 5)
!132 = distinct !DILexicalBlock(scope: !127, file: !10, line: 34, column: 13)
!133 = !DILocation(line: 0, scope: !127)
!134 = !DILocation(line: 34, column: 3, scope: !127)
!135 = !DILocation(line: 0, scope: !131)
!136 = !DILocation(line: 35, column: 25, scope: !137)
!137 = distinct !DILexicalBlock(scope: !131, file: !10, line: 35, column: 5)
!138 = !{!139, !139, i64 0}
!139 = !{!"int", !110, i64 0}
!140 = !DILocation(line: 35, column: 23, scope: !137)
!141 = !DILocation(line: 35, column: 5, scope: !131)
!142 = !DILocation(line: 36, column: 27, scope: !143)
!143 = distinct !DILexicalBlock(scope: !137, file: !10, line: 35, column: 45)
!144 = !DILocation(line: 36, column: 7, scope: !143)
!145 = !DILocation(line: 37, column: 11, scope: !146)
!146 = distinct !DILexicalBlock(scope: !143, file: !10, line: 37, column: 11)
!147 = !{i8 0, i8 2}
!148 = !{}
!149 = !DILocation(line: 38, column: 9, scope: !150)
!150 = distinct !DILexicalBlock(scope: !146, file: !10, line: 37, column: 21)
!151 = !DILocation(line: 38, column: 18, scope: !150)
!152 = !DILocation(line: 39, column: 22, scope: !150)
!153 = !{!154, !154, i64 0}
!154 = !{!"p1 long", !109, i64 0}
!155 = !{!156, !156, i64 0}
!156 = !{!"long", !110, i64 0}
!157 = !DILocation(line: 39, column: 9, scope: !150)
!158 = !DILocation(line: 40, column: 9, scope: !150)
!159 = !DILocation(line: 41, column: 22, scope: !150)
!160 = !DILocation(line: 42, column: 9, scope: !150)
!161 = !DILocation(line: 43, column: 9, scope: !150)
!162 = !DILocation(line: 44, column: 7, scope: !150)
!163 = !DILocation(line: 45, column: 29, scope: !143)
!164 = !DILocation(line: 45, column: 7, scope: !143)
!165 = !DILocation(line: 46, column: 5, scope: !143)
!166 = !DILocation(line: 35, column: 41, scope: !137)
!167 = distinct !{!167, !141, !168, !169, !170}
!168 = !DILocation(line: 46, column: 5, scope: !131)
!169 = !{!"llvm.loop.mustprogress"}
!170 = !{!"llvm.loop.unroll.disable"}
!171 = distinct !{!171, !134, !172, !170}
!172 = !DILocation(line: 47, column: 3, scope: !127)
!173 = !DISubprogram(name: "pthread_join", scope: !123, file: !123, line: 219, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!174 = !DISubroutineType(types: !175)
!175 = !{!5, !83, !176}
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!177 = !DISubprogram(name: "pthread_cond_signal", scope: !123, file: !123, line: 1121, type: !178, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!178 = !DISubroutineType(types: !179)
!179 = !{!5, !180}
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!181 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 51, type: !182, scopeLine: 51, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !184)
!182 = !DISubroutineType(types: !183)
!183 = !{!5}
!184 = !{!185, !187, !188}
!185 = !DILocalVariable(name: "i", scope: !186, file: !10, line: 58, type: !5)
!186 = distinct !DILexicalBlock(scope: !181, file: !10, line: 58, column: 3)
!187 = !DILocalVariable(name: "cleaner_tid", scope: !181, file: !10, line: 62, type: !83)
!188 = !DILocalVariable(name: "i", scope: !189, file: !10, line: 65, type: !5)
!189 = distinct !DILexicalBlock(scope: !181, file: !10, line: 65, column: 3)
!190 = !DILocation(line: 52, column: 17, scope: !181)
!191 = !DILocation(line: 54, column: 17, scope: !181)
!192 = !DILocation(line: 54, column: 31, scope: !181)
!193 = !DILocation(line: 54, column: 10, scope: !181)
!194 = !DILocation(line: 54, column: 8, scope: !181)
!195 = !DILocation(line: 55, column: 18, scope: !181)
!196 = !DILocation(line: 55, column: 11, scope: !181)
!197 = !DILocation(line: 55, column: 9, scope: !181)
!198 = !DILocation(line: 56, column: 24, scope: !181)
!199 = !DILocation(line: 56, column: 38, scope: !181)
!200 = !DILocation(line: 56, column: 17, scope: !181)
!201 = !DILocation(line: 56, column: 15, scope: !181)
!202 = !DILocation(line: 0, scope: !186)
!203 = !DILocation(line: 58, column: 23, scope: !204)
!204 = distinct !DILexicalBlock(scope: !186, file: !10, line: 58, column: 3)
!205 = !DILocation(line: 58, column: 21, scope: !204)
!206 = !DILocation(line: 58, column: 3, scope: !186)
!207 = !DILocation(line: 59, column: 25, scope: !204)
!208 = !DILocation(line: 59, column: 5, scope: !204)
!209 = !DILocation(line: 58, column: 39, scope: !204)
!210 = distinct !{!210, !206, !211, !169, !170}
!211 = !DILocation(line: 59, column: 45, scope: !186)
!212 = !DILocation(line: 62, column: 3, scope: !181)
!213 = !DILocation(line: 62, column: 13, scope: !181)
!214 = !DILocation(line: 63, column: 3, scope: !181)
!215 = !DILocation(line: 0, scope: !189)
!216 = !DILocation(line: 65, column: 23, scope: !217)
!217 = distinct !DILexicalBlock(scope: !189, file: !10, line: 65, column: 3)
!218 = !DILocation(line: 65, column: 21, scope: !217)
!219 = !DILocation(line: 65, column: 3, scope: !189)
!220 = !DILocation(line: 66, column: 21, scope: !221)
!221 = distinct !DILexicalBlock(scope: !217, file: !10, line: 65, column: 43)
!222 = !DILocation(line: 66, column: 45, scope: !221)
!223 = !DILocation(line: 66, column: 5, scope: !221)
!224 = !DILocation(line: 68, column: 5, scope: !221)
!225 = !DILocation(line: 69, column: 18, scope: !221)
!226 = !DILocation(line: 70, column: 5, scope: !221)
!227 = !DILocation(line: 71, column: 5, scope: !221)
!228 = !DILocation(line: 72, column: 3, scope: !221)
!229 = !DILocation(line: 65, column: 39, scope: !217)
!230 = distinct !{!230, !219, !231, !169, !170}
!231 = !DILocation(line: 72, column: 3, scope: !189)
!232 = !DILocation(line: 75, column: 3, scope: !181)
!233 = !DILocation(line: 76, column: 10, scope: !181)
!234 = !DILocation(line: 76, column: 3, scope: !181)
!235 = !DILocation(line: 77, column: 5, scope: !181)
!236 = distinct !{!236, !234, !237, !169, !170}
!237 = !DILocation(line: 77, column: 64, scope: !181)
!238 = !DILocation(line: 78, column: 3, scope: !181)
!239 = !DILocation(line: 80, column: 8, scope: !181)
!240 = !DILocation(line: 80, column: 3, scope: !181)
!241 = !DILocation(line: 82, column: 10, scope: !181)
!242 = !DILocation(line: 83, column: 1, scope: !181)
!243 = !DILocation(line: 82, column: 3, scope: !181)
!244 = !DISubprogram(name: "malloc", scope: !245, file: !245, line: 672, type: !246, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!245 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!246 = !DISubroutineType(types: !247)
!247 = !{!6, !248}
!248 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !249, line: 18, baseType: !84)
!249 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!250 = !DISubprogram(name: "calloc", scope: !245, file: !245, line: 675, type: !251, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!251 = !DISubroutineType(types: !252)
!252 = !{!6, !248, !248}
!253 = !DISubprogram(name: "pthread_mutex_init", scope: !123, file: !123, line: 781, type: !254, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!254 = !DISubroutineType(types: !255)
!255 = !{!5, !91, !256}
!256 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !257, size: 64)
!257 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !258)
!258 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !12, line: 36, baseType: !259)
!259 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 32, size: 32, elements: !260)
!260 = !{!261, !265}
!261 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !259, file: !12, line: 34, baseType: !262, size: 32)
!262 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 32, elements: !263)
!263 = !{!264}
!264 = !DISubrange(count: 4)
!265 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !259, file: !12, line: 35, baseType: !5, size: 32)
!266 = !DISubprogram(name: "pthread_create", scope: !123, file: !123, line: 202, type: !267, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!267 = !DISubroutineType(types: !268)
!268 = !{!5, !269, !270, !281, !282}
!269 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !82)
!270 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !271)
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !272, size: 64)
!272 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !273)
!273 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !12, line: 62, baseType: !274)
!274 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !12, line: 56, size: 448, elements: !275)
!275 = !{!276, !280}
!276 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !274, file: !12, line: 58, baseType: !277, size: 448)
!277 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !278)
!278 = !{!279}
!279 = !DISubrange(count: 56)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !274, file: !12, line: 59, baseType: !42, size: 64)
!281 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!282 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!283 = !DISubprogram(name: "pthread_cond_wait", scope: !123, file: !123, line: 1133, type: !284, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!284 = !DISubroutineType(types: !285)
!285 = !{!5, !286, !287}
!286 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !180)
!287 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !91)
!288 = !DISubprogram(name: "free", scope: !245, file: !245, line: 687, type: !289, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!289 = !DISubroutineType(types: !290)
!290 = !{null, !6}
