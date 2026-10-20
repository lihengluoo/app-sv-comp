; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-counter-outer-race-3.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }

@threads_alive = dso_local global i32 -1, align 4, !dbg !0
@threads_alive_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@threads_alive_cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !43
@data = dso_local global i32 0, align 4, !dbg !78
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !80

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !89 {
entry:
    #dbg_value(ptr %arg, !93, !DIExpression(), !94)
  %call = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #4, !dbg !95
  store i32 4, ptr @data, align 4, !dbg !96, !tbaa !97
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #4, !dbg !101
  %call2 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !102
  %0 = load i32, ptr @threads_alive, align 4, !dbg !103, !tbaa !97
  %dec = add nsw i32 %0, -1, !dbg !103
  store i32 %dec, ptr @threads_alive, align 4, !dbg !103, !tbaa !97
  %call3 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #4, !dbg !104
  %call4 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !105
  ret ptr null, !dbg !106
}

; Function Attrs: nounwind
declare !dbg !107 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !112 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !113 i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !117 {
entry:
  %tid = alloca i64, align 8
    #dbg_value(i32 4, !121, !DIExpression(), !129)
    #dbg_value(i32 0, !122, !DIExpression(), !130)
  br label %for.body, !dbg !131

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %i.02 = phi i32 [ 0, %entry ], [ %inc4, %for.inc ]
    #dbg_value(i32 %i.02, !122, !DIExpression(), !130)
  %call = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !132
  %0 = load i32, ptr @threads_alive, align 4, !dbg !133, !tbaa !97
  %inc = add nsw i32 %0, 1, !dbg !133
  store i32 %inc, ptr @threads_alive, align 4, !dbg !133, !tbaa !97
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !134
  call void @llvm.lifetime.start.p0(i64 8, ptr %tid) #4, !dbg !135
    #dbg_declare(ptr %tid, !124, !DIExpression(), !136)
  %call2 = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !137
  %1 = load i64, ptr %tid, align 8, !dbg !138, !tbaa !139
  %call3 = call i32 @pthread_detach(i64 noundef %1) #4, !dbg !141
  call void @llvm.lifetime.end.p0(i64 8, ptr %tid) #4, !dbg !142
  br label %for.inc, !dbg !143

for.inc:                                          ; preds = %for.body
  %inc4 = add nuw nsw i32 %i.02, 1, !dbg !144
    #dbg_value(i32 %inc4, !122, !DIExpression(), !130)
  %exitcond = icmp ne i32 %inc4, 4, !dbg !145
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !131, !llvm.loop !146

for.end:                                          ; preds = %for.cond.cleanup
  %call5 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !150
  %2 = load i32, ptr @threads_alive, align 4, !dbg !151, !tbaa !97
  %tobool3 = icmp ne i32 %2, 0, !dbg !152
  br i1 %tobool3, label %while.body.lr.ph, label %while.end, !dbg !152

while.body.lr.ph:                                 ; preds = %for.end
  br label %while.body, !dbg !152

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call6 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !153
  %3 = load i32, ptr @threads_alive, align 4, !dbg !151, !tbaa !97
  %tobool = icmp ne i32 %3, 0, !dbg !152
  br i1 %tobool, label %while.body, label %while.cond.while.end_crit_edge, !dbg !152, !llvm.loop !154

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !152

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %for.end
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !156
  %4 = load i32, ptr @data, align 4, !dbg !157, !tbaa !97
  ret i32 %4, !dbg !158
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !159 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !177 i32 @pthread_detach(i64 noundef) #1

declare !dbg !180 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!82}
!llvm.module.flags = !{!83, !84, !85, !86, !87, !88}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !9, line: 13, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-counter-outer-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "700636a46aab6b27a83c80a0d13e4c65")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43, !78, !80}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "threads_alive_mutex", scope: !2, file: !9, line: 14, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-join-counter-outer-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "700636a46aab6b27a83c80a0d13e4c65")
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
!44 = distinct !DIGlobalVariable(name: "threads_alive_cond", scope: !2, file: !9, line: 15, type: !45, isLocal: false, isDefinition: true)
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
!79 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 17, type: !19, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 18, type: !10, isLocal: false, isDefinition: true)
!82 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!83 = !{i32 7, !"Dwarf Version", i32 5}
!84 = !{i32 2, !"Debug Info Version", i32 3}
!85 = !{i32 1, !"wchar_size", i32 4}
!86 = !{i32 8, !"PIC Level", i32 2}
!87 = !{i32 7, !"PIE Level", i32 2}
!88 = !{i32 7, !"uwtable", i32 2}
!89 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 20, type: !90, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !92)
!90 = !DISubroutineType(types: !91)
!91 = !{!5, !5}
!92 = !{!93}
!93 = !DILocalVariable(name: "arg", arg: 1, scope: !89, file: !9, line: 20, type: !5)
!94 = !DILocation(line: 0, scope: !89)
!95 = !DILocation(line: 21, column: 3, scope: !89)
!96 = !DILocation(line: 22, column: 8, scope: !89)
!97 = !{!98, !98, i64 0}
!98 = !{!"int", !99, i64 0}
!99 = !{!"omnipotent char", !100, i64 0}
!100 = !{!"Simple C/C++ TBAA"}
!101 = !DILocation(line: 23, column: 3, scope: !89)
!102 = !DILocation(line: 25, column: 3, scope: !89)
!103 = !DILocation(line: 26, column: 16, scope: !89)
!104 = !DILocation(line: 27, column: 3, scope: !89)
!105 = !DILocation(line: 28, column: 3, scope: !89)
!106 = !DILocation(line: 29, column: 3, scope: !89)
!107 = !DISubprogram(name: "pthread_mutex_lock", scope: !108, file: !108, line: 794, type: !109, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!109 = !DISubroutineType(types: !110)
!110 = !{!19, !111}
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!112 = !DISubprogram(name: "pthread_mutex_unlock", scope: !108, file: !108, line: 835, type: !109, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DISubprogram(name: "pthread_cond_signal", scope: !108, file: !108, line: 1121, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!114 = !DISubroutineType(types: !115)
!115 = !{!19, !116}
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!117 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 32, type: !118, scopeLine: 32, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !120)
!118 = !DISubroutineType(types: !119)
!119 = !{!19}
!120 = !{!121, !122, !124}
!121 = !DILocalVariable(name: "threads_total", scope: !117, file: !9, line: 33, type: !19)
!122 = !DILocalVariable(name: "i", scope: !123, file: !9, line: 36, type: !19)
!123 = distinct !DILexicalBlock(scope: !117, file: !9, line: 36, column: 3)
!124 = !DILocalVariable(name: "tid", scope: !125, file: !9, line: 42, type: !127)
!125 = distinct !DILexicalBlock(scope: !126, file: !9, line: 36, column: 43)
!126 = distinct !DILexicalBlock(scope: !123, file: !9, line: 36, column: 3)
!127 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !128)
!128 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!129 = !DILocation(line: 0, scope: !117)
!130 = !DILocation(line: 0, scope: !123)
!131 = !DILocation(line: 36, column: 3, scope: !123)
!132 = !DILocation(line: 37, column: 5, scope: !125)
!133 = !DILocation(line: 38, column: 18, scope: !125)
!134 = !DILocation(line: 40, column: 5, scope: !125)
!135 = !DILocation(line: 42, column: 5, scope: !125)
!136 = !DILocation(line: 42, column: 15, scope: !125)
!137 = !DILocation(line: 43, column: 5, scope: !125)
!138 = !DILocation(line: 44, column: 20, scope: !125)
!139 = !{!140, !140, i64 0}
!140 = !{!"long", !99, i64 0}
!141 = !DILocation(line: 44, column: 5, scope: !125)
!142 = !DILocation(line: 45, column: 3, scope: !126)
!143 = !DILocation(line: 45, column: 3, scope: !125)
!144 = !DILocation(line: 36, column: 39, scope: !126)
!145 = !DILocation(line: 36, column: 21, scope: !126)
!146 = distinct !{!146, !131, !147, !148, !149}
!147 = !DILocation(line: 45, column: 3, scope: !123)
!148 = !{!"llvm.loop.mustprogress"}
!149 = !{!"llvm.loop.unroll.disable"}
!150 = !DILocation(line: 48, column: 3, scope: !117)
!151 = !DILocation(line: 49, column: 10, scope: !117)
!152 = !DILocation(line: 49, column: 3, scope: !117)
!153 = !DILocation(line: 50, column: 5, scope: !117)
!154 = distinct !{!154, !152, !155, !148, !149}
!155 = !DILocation(line: 50, column: 64, scope: !117)
!156 = !DILocation(line: 51, column: 3, scope: !117)
!157 = !DILocation(line: 53, column: 10, scope: !117)
!158 = !DILocation(line: 53, column: 3, scope: !117)
!159 = !DISubprogram(name: "pthread_create", scope: !108, file: !108, line: 202, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!160 = !DISubroutineType(types: !161)
!161 = !{!19, !162, !164, !175, !176}
!162 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !163)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!164 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !165)
!165 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !166, size: 64)
!166 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !167)
!167 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !168)
!168 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !169)
!169 = !{!170, !174}
!170 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !168, file: !11, line: 58, baseType: !171, size: 448)
!171 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !172)
!172 = !{!173}
!173 = !DISubrange(count: 56)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !168, file: !11, line: 59, baseType: !42, size: 64)
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!176 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!177 = !DISubprogram(name: "pthread_detach", scope: !108, file: !108, line: 269, type: !178, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!178 = !DISubroutineType(types: !179)
!179 = !{!19, !127}
!180 = !DISubprogram(name: "pthread_cond_wait", scope: !108, file: !108, line: 1133, type: !181, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!181 = !DISubroutineType(types: !182)
!182 = !{!19, !183, !184}
!183 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !116)
!184 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !111)
