; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-counter-inner.linked.bc'
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
@threads_alive_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@threads_alive_cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !43
@keep_alive = dso_local global i8 1, align 1, !dbg !78
@keep_alive_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !81
@data = dso_local global i32 0, align 4, !dbg !83
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !85

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !94 {
entry:
    #dbg_value(ptr %arg, !98, !DIExpression(), !99)
  %call = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !100
  %0 = load i32, ptr @threads_alive, align 4, !dbg !101, !tbaa !102
  %inc = add nsw i32 %0, 1, !dbg !101
  store i32 %inc, ptr @threads_alive, align 4, !dbg !101, !tbaa !102
  %call1 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #4, !dbg !106
  %call2 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !107
  %call3 = call i32 @pthread_mutex_lock(ptr noundef @keep_alive_mutex) #4, !dbg !108
  %1 = load i8, ptr @keep_alive, align 1, !dbg !109, !tbaa !110, !range !112, !noundef !113
  %loadedv1 = trunc i8 %1 to i1, !dbg !109
  br i1 %loadedv1, label %while.body.lr.ph, label %while.end, !dbg !114

while.body.lr.ph:                                 ; preds = %entry
  br label %while.body, !dbg !114

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call4 = call i32 @pthread_mutex_unlock(ptr noundef @keep_alive_mutex) #4, !dbg !115
  %call5 = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #4, !dbg !117
  store i32 4, ptr @data, align 4, !dbg !118, !tbaa !102
  %call6 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #4, !dbg !119
  %call7 = call i32 @pthread_mutex_lock(ptr noundef @keep_alive_mutex) #4, !dbg !120
  %2 = load i8, ptr @keep_alive, align 1, !dbg !109, !tbaa !110, !range !112, !noundef !113
  %loadedv = trunc i8 %2 to i1, !dbg !109
  br i1 %loadedv, label %while.body, label %while.cond.while.end_crit_edge, !dbg !114, !llvm.loop !121

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !114

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %entry
  %call8 = call i32 @pthread_mutex_unlock(ptr noundef @keep_alive_mutex) #4, !dbg !125
  %call9 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !126
  %3 = load i32, ptr @threads_alive, align 4, !dbg !127, !tbaa !102
  %dec = add nsw i32 %3, -1, !dbg !127
  store i32 %dec, ptr @threads_alive, align 4, !dbg !127, !tbaa !102
  %call10 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #4, !dbg !128
  %call11 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !129
  ret ptr null, !dbg !130
}

; Function Attrs: nounwind
declare !dbg !131 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !136 i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !140 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !141 {
entry:
  %tid = alloca i64, align 8
    #dbg_value(i32 4, !145, !DIExpression(), !153)
    #dbg_value(i32 0, !146, !DIExpression(), !154)
  br label %for.body, !dbg !155

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %i.03 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
    #dbg_value(i32 %i.03, !146, !DIExpression(), !154)
  call void @llvm.lifetime.start.p0(i64 8, ptr %tid) #4, !dbg !156
    #dbg_declare(ptr %tid, !148, !DIExpression(), !157)
  %call = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !158
  %0 = load i64, ptr %tid, align 8, !dbg !159, !tbaa !160
  %call1 = call i32 @pthread_detach(i64 noundef %0) #4, !dbg !162
  call void @llvm.lifetime.end.p0(i64 8, ptr %tid) #4, !dbg !163
  br label %for.inc, !dbg !164

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i32 %i.03, 1, !dbg !165
    #dbg_value(i32 %inc, !146, !DIExpression(), !154)
  %exitcond = icmp ne i32 %inc, 4, !dbg !166
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !155, !llvm.loop !167

for.end:                                          ; preds = %for.cond.cleanup
  %call2 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !169
  %1 = load i32, ptr @threads_alive, align 4, !dbg !170, !tbaa !102
  %cmp34 = icmp ne i32 %1, 4, !dbg !171
  br i1 %cmp34, label %while.body.lr.ph, label %while.end, !dbg !172

while.body.lr.ph:                                 ; preds = %for.end
  br label %while.body, !dbg !172

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call4 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !173
  %2 = load i32, ptr @threads_alive, align 4, !dbg !170, !tbaa !102
  %cmp3 = icmp ne i32 %2, 4, !dbg !171
  br i1 %cmp3, label %while.body, label %while.cond.while.end_crit_edge, !dbg !172, !llvm.loop !174

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !172

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %for.end
  %call5 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !176
  %call6 = call i32 @pthread_mutex_lock(ptr noundef @keep_alive_mutex) #4, !dbg !177
  store i8 0, ptr @keep_alive, align 1, !dbg !178, !tbaa !110
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef @keep_alive_mutex) #4, !dbg !179
  %call8 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !180
  %3 = load i32, ptr @threads_alive, align 4, !dbg !181, !tbaa !102
  %tobool5 = icmp ne i32 %3, 0, !dbg !182
  br i1 %tobool5, label %while.body10.lr.ph, label %while.end12, !dbg !182

while.body10.lr.ph:                               ; preds = %while.end
  br label %while.body10, !dbg !182

while.body10:                                     ; preds = %while.body10.lr.ph, %while.body10
  %call11 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !183
  %4 = load i32, ptr @threads_alive, align 4, !dbg !181, !tbaa !102
  %tobool = icmp ne i32 %4, 0, !dbg !182
  br i1 %tobool, label %while.body10, label %while.cond9.while.end12_crit_edge, !dbg !182, !llvm.loop !184

while.cond9.while.end12_crit_edge:                ; preds = %while.body10
  br label %while.end12, !dbg !182

while.end12:                                      ; preds = %while.cond9.while.end12_crit_edge, %while.end
  %call13 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !186
  %5 = load i32, ptr @data, align 4, !dbg !187, !tbaa !102
  ret i32 %5, !dbg !188
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !189 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !207 i32 @pthread_detach(i64 noundef) #1

declare !dbg !210 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!87}
!llvm.module.flags = !{!88, !89, !90, !91, !92, !93}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !9, line: 14, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-counter-inner.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "bd7b55a57d0bc6fddc70eed0116fe1f0")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43, !78, !81, !83, !85}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "threads_alive_mutex", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-join-counter-inner.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "bd7b55a57d0bc6fddc70eed0116fe1f0")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !11, line: 72, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!12 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 67, size: 320, elements: !13)
!13 = !{!14, !36, !41}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !12, file: !11, line: 69, baseType: !15, size: 320)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !16, line: 22, size: 320, elements: !17)
!16 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!17 = !{!18, !20, !22, !23, !24, !25, !27, !28}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !15, file: !16, line: 24, baseType: !19, size: 32)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !15, file: !16, line: 25, baseType: !21, size: 32, offset: 32)
!21 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !15, file: !16, line: 26, baseType: !19, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !15, file: !16, line: 28, baseType: !21, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !15, file: !16, line: 32, baseType: !19, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !15, file: !16, line: 34, baseType: !26, size: 16, offset: 160)
!26 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !15, file: !16, line: 35, baseType: !26, size: 16, offset: 176)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !15, file: !16, line: 36, baseType: !29, size: 128, offset: 192)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !30, line: 55, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !30, line: 51, size: 128, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !31, file: !30, line: 53, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !31, file: !30, line: 54, baseType: !34, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !12, file: !11, line: 70, baseType: !37, size: 320)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 320, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 40)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !12, file: !11, line: 71, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "threads_alive_cond", scope: !2, file: !9, line: 16, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !11, line: 80, baseType: !46)
!46 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 75, size: 384, elements: !47)
!47 = !{!48, !72, !76}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !46, file: !11, line: 77, baseType: !49, size: 384)
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
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !46, file: !11, line: 78, baseType: !73, size: 384)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 384, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 48)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !46, file: !11, line: 79, baseType: !77, size: 64)
!77 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "keep_alive", scope: !2, file: !9, line: 18, type: !80, isLocal: false, isDefinition: true)
!80 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "keep_alive_mutex", scope: !2, file: !9, line: 19, type: !10, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 21, type: !19, isLocal: false, isDefinition: true)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 22, type: !10, isLocal: false, isDefinition: true)
!87 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!88 = !{i32 7, !"Dwarf Version", i32 5}
!89 = !{i32 2, !"Debug Info Version", i32 3}
!90 = !{i32 1, !"wchar_size", i32 4}
!91 = !{i32 8, !"PIC Level", i32 2}
!92 = !{i32 7, !"PIE Level", i32 2}
!93 = !{i32 7, !"uwtable", i32 2}
!94 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 24, type: !95, scopeLine: 24, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !97)
!95 = !DISubroutineType(types: !96)
!96 = !{!5, !5}
!97 = !{!98}
!98 = !DILocalVariable(name: "arg", arg: 1, scope: !94, file: !9, line: 24, type: !5)
!99 = !DILocation(line: 0, scope: !94)
!100 = !DILocation(line: 25, column: 3, scope: !94)
!101 = !DILocation(line: 26, column: 16, scope: !94)
!102 = !{!103, !103, i64 0}
!103 = !{!"int", !104, i64 0}
!104 = !{!"omnipotent char", !105, i64 0}
!105 = !{!"Simple C/C++ TBAA"}
!106 = !DILocation(line: 27, column: 3, scope: !94)
!107 = !DILocation(line: 28, column: 3, scope: !94)
!108 = !DILocation(line: 30, column: 3, scope: !94)
!109 = !DILocation(line: 31, column: 10, scope: !94)
!110 = !{!111, !111, i64 0}
!111 = !{!"_Bool", !104, i64 0}
!112 = !{i8 0, i8 2}
!113 = !{}
!114 = !DILocation(line: 31, column: 3, scope: !94)
!115 = !DILocation(line: 32, column: 5, scope: !116)
!116 = distinct !DILexicalBlock(scope: !94, file: !9, line: 31, column: 22)
!117 = !DILocation(line: 34, column: 5, scope: !116)
!118 = !DILocation(line: 35, column: 10, scope: !116)
!119 = !DILocation(line: 36, column: 5, scope: !116)
!120 = !DILocation(line: 38, column: 5, scope: !116)
!121 = distinct !{!121, !114, !122, !123, !124}
!122 = !DILocation(line: 39, column: 3, scope: !94)
!123 = !{!"llvm.loop.mustprogress"}
!124 = !{!"llvm.loop.unroll.disable"}
!125 = !DILocation(line: 40, column: 3, scope: !94)
!126 = !DILocation(line: 42, column: 3, scope: !94)
!127 = !DILocation(line: 43, column: 16, scope: !94)
!128 = !DILocation(line: 44, column: 3, scope: !94)
!129 = !DILocation(line: 45, column: 3, scope: !94)
!130 = !DILocation(line: 46, column: 3, scope: !94)
!131 = !DISubprogram(name: "pthread_mutex_lock", scope: !132, file: !132, line: 794, type: !133, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!132 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!133 = !DISubroutineType(types: !134)
!134 = !{!19, !135}
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!136 = !DISubprogram(name: "pthread_cond_signal", scope: !132, file: !132, line: 1121, type: !137, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!137 = !DISubroutineType(types: !138)
!138 = !{!19, !139}
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!140 = !DISubprogram(name: "pthread_mutex_unlock", scope: !132, file: !132, line: 835, type: !133, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!141 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 49, type: !142, scopeLine: 49, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !144)
!142 = !DISubroutineType(types: !143)
!143 = !{!19}
!144 = !{!145, !146, !148}
!145 = !DILocalVariable(name: "threads_total", scope: !141, file: !9, line: 50, type: !19)
!146 = !DILocalVariable(name: "i", scope: !147, file: !9, line: 53, type: !19)
!147 = distinct !DILexicalBlock(scope: !141, file: !9, line: 53, column: 3)
!148 = !DILocalVariable(name: "tid", scope: !149, file: !9, line: 54, type: !151)
!149 = distinct !DILexicalBlock(scope: !150, file: !9, line: 53, column: 43)
!150 = distinct !DILexicalBlock(scope: !147, file: !9, line: 53, column: 3)
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !152)
!152 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!153 = !DILocation(line: 0, scope: !141)
!154 = !DILocation(line: 0, scope: !147)
!155 = !DILocation(line: 53, column: 3, scope: !147)
!156 = !DILocation(line: 54, column: 5, scope: !149)
!157 = !DILocation(line: 54, column: 15, scope: !149)
!158 = !DILocation(line: 55, column: 5, scope: !149)
!159 = !DILocation(line: 56, column: 20, scope: !149)
!160 = !{!161, !161, i64 0}
!161 = !{!"long", !104, i64 0}
!162 = !DILocation(line: 56, column: 5, scope: !149)
!163 = !DILocation(line: 57, column: 3, scope: !150)
!164 = !DILocation(line: 57, column: 3, scope: !149)
!165 = !DILocation(line: 53, column: 39, scope: !150)
!166 = !DILocation(line: 53, column: 21, scope: !150)
!167 = distinct !{!167, !155, !168, !123, !124}
!168 = !DILocation(line: 57, column: 3, scope: !147)
!169 = !DILocation(line: 60, column: 3, scope: !141)
!170 = !DILocation(line: 61, column: 10, scope: !141)
!171 = !DILocation(line: 61, column: 24, scope: !141)
!172 = !DILocation(line: 61, column: 3, scope: !141)
!173 = !DILocation(line: 62, column: 5, scope: !141)
!174 = distinct !{!174, !172, !175, !123, !124}
!175 = !DILocation(line: 62, column: 64, scope: !141)
!176 = !DILocation(line: 63, column: 3, scope: !141)
!177 = !DILocation(line: 66, column: 3, scope: !141)
!178 = !DILocation(line: 67, column: 14, scope: !141)
!179 = !DILocation(line: 68, column: 3, scope: !141)
!180 = !DILocation(line: 71, column: 3, scope: !141)
!181 = !DILocation(line: 72, column: 10, scope: !141)
!182 = !DILocation(line: 72, column: 3, scope: !141)
!183 = !DILocation(line: 73, column: 5, scope: !141)
!184 = distinct !{!184, !182, !185, !123, !124}
!185 = !DILocation(line: 73, column: 64, scope: !141)
!186 = !DILocation(line: 74, column: 3, scope: !141)
!187 = !DILocation(line: 76, column: 10, scope: !141)
!188 = !DILocation(line: 76, column: 3, scope: !141)
!189 = !DISubprogram(name: "pthread_create", scope: !132, file: !132, line: 202, type: !190, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!190 = !DISubroutineType(types: !191)
!191 = !{!19, !192, !194, !205, !206}
!192 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !193)
!193 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!194 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !195)
!195 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !196, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !197)
!197 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !198)
!198 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !199)
!199 = !{!200, !204}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !198, file: !11, line: 58, baseType: !201, size: 448)
!201 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !202)
!202 = !{!203}
!203 = !DISubrange(count: 56)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !198, file: !11, line: 59, baseType: !42, size: 64)
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!206 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!207 = !DISubprogram(name: "pthread_detach", scope: !132, file: !132, line: 269, type: !208, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!208 = !DISubroutineType(types: !209)
!209 = !{!19, !151}
!210 = !DISubprogram(name: "pthread_cond_wait", scope: !132, file: !132, line: 1133, type: !211, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!211 = !DISubroutineType(types: !212)
!212 = !{!19, !213, !214}
!213 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !139)
!214 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !135)
