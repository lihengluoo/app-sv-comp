; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/value-barrier.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }

@ready = dso_local global i8 0, align 1, !dbg !0
@ready_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@ready_cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !43
@data = dso_local global i32 0, align 4, !dbg !78

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !88 {
entry:
    #dbg_value(ptr %arg, !92, !DIExpression(), !94)
  %call = call i32 @pthread_mutex_lock(ptr noundef @ready_mutex) #4, !dbg !95
  %0 = load i8, ptr @ready, align 1, !dbg !96, !tbaa !97, !range !101, !noundef !102
  %loadedv1 = trunc i8 %0 to i1, !dbg !96
  %lnot2 = xor i1 %loadedv1, true, !dbg !103
  br i1 %lnot2, label %while.body.lr.ph, label %while.end, !dbg !104

while.body.lr.ph:                                 ; preds = %entry
  br label %while.body, !dbg !104

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call1 = call i32 @pthread_cond_wait(ptr noundef @ready_cond, ptr noundef @ready_mutex), !dbg !105
  %1 = load i8, ptr @ready, align 1, !dbg !96, !tbaa !97, !range !101, !noundef !102
  %loadedv = trunc i8 %1 to i1, !dbg !96
  %lnot = xor i1 %loadedv, true, !dbg !103
  br i1 %lnot, label %while.body, label %while.cond.while.end_crit_edge, !dbg !104, !llvm.loop !106

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !104

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %entry
  %call2 = call i32 @pthread_mutex_unlock(ptr noundef @ready_mutex) #4, !dbg !110
  %2 = load i32, ptr @data, align 4, !dbg !111, !tbaa !112
    #dbg_value(i32 %2, !93, !DIExpression(), !94)
  ret ptr null, !dbg !114
}

; Function Attrs: nounwind
declare !dbg !115 i32 @pthread_mutex_lock(ptr noundef) #1

declare !dbg !120 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !126 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !127 {
entry:
    #dbg_value(i32 4, !131, !DIExpression(), !140)
  %conv = sext i32 4 to i64, !dbg !141
  %mul = mul i64 %conv, 8, !dbg !142
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !143
    #dbg_value(ptr %call, !132, !DIExpression(), !140)
    #dbg_value(i32 0, !136, !DIExpression(), !144)
  br label %for.body, !dbg !145

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !136, !DIExpression(), !144)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !146
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !149
  br label %for.inc, !dbg !150

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !151
    #dbg_value(i64 %indvars.iv.next, !136, !DIExpression(), !144)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !152
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !145, !llvm.loop !153

for.end:                                          ; preds = %for.cond.cleanup
  store i32 4, ptr @data, align 4, !dbg !155, !tbaa !112
  %call3 = call i32 @pthread_mutex_lock(ptr noundef @ready_mutex) #4, !dbg !156
  store i8 1, ptr @ready, align 1, !dbg !157, !tbaa !97
  %call4 = call i32 @pthread_cond_broadcast(ptr noundef @ready_cond) #4, !dbg !158
  %call5 = call i32 @pthread_mutex_unlock(ptr noundef @ready_mutex) #4, !dbg !159
    #dbg_value(i32 0, !138, !DIExpression(), !160)
  br label %for.body11, !dbg !161

for.cond.cleanup10:                               ; preds = %for.inc15
  br label %for.end17

for.body11:                                       ; preds = %for.end, %for.inc15
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc15 ]
    #dbg_value(i64 %indvars.iv12, !138, !DIExpression(), !160)
  %arrayidx13 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !162
  %0 = load i64, ptr %arrayidx13, align 8, !dbg !162, !tbaa !165
  %call14 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !167
  br label %for.inc15, !dbg !168

for.inc15:                                        ; preds = %for.body11
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !169
    #dbg_value(i64 %indvars.iv.next13, !138, !DIExpression(), !160)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !170
  br i1 %exitcond15, label %for.body11, label %for.cond.cleanup10, !dbg !161, !llvm.loop !171

for.end17:                                        ; preds = %for.cond.cleanup10
  call void @free(ptr noundef %call) #4, !dbg !173
  ret i32 0, !dbg !174
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !175 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !181 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !198 i32 @pthread_cond_broadcast(ptr noundef) #1

declare !dbg !201 i32 @pthread_join(i64 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !205 void @free(ptr noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!81}
!llvm.module.flags = !{!82, !83, !84, !85, !86, !87}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "ready", scope: !2, file: !9, line: 14, type: !80, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/value-barrier.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "4be1e056b7580bb5e077b513162631ad")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43, !78}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "ready_mutex", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "value-barrier.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "4be1e056b7580bb5e077b513162631ad")
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
!44 = distinct !DIGlobalVariable(name: "ready_cond", scope: !2, file: !9, line: 16, type: !45, isLocal: false, isDefinition: true)
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
!79 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 18, type: !19, isLocal: false, isDefinition: true)
!80 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!81 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!82 = !{i32 7, !"Dwarf Version", i32 5}
!83 = !{i32 2, !"Debug Info Version", i32 3}
!84 = !{i32 1, !"wchar_size", i32 4}
!85 = !{i32 8, !"PIC Level", i32 2}
!86 = !{i32 7, !"PIE Level", i32 2}
!87 = !{i32 7, !"uwtable", i32 2}
!88 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 20, type: !89, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !91)
!89 = !DISubroutineType(types: !90)
!90 = !{!5, !5}
!91 = !{!92, !93}
!92 = !DILocalVariable(name: "arg", arg: 1, scope: !88, file: !9, line: 20, type: !5)
!93 = !DILocalVariable(name: "x", scope: !88, file: !9, line: 27, type: !19)
!94 = !DILocation(line: 0, scope: !88)
!95 = !DILocation(line: 22, column: 3, scope: !88)
!96 = !DILocation(line: 23, column: 11, scope: !88)
!97 = !{!98, !98, i64 0}
!98 = !{!"_Bool", !99, i64 0}
!99 = !{!"omnipotent char", !100, i64 0}
!100 = !{!"Simple C/C++ TBAA"}
!101 = !{i8 0, i8 2}
!102 = !{}
!103 = !DILocation(line: 23, column: 10, scope: !88)
!104 = !DILocation(line: 23, column: 3, scope: !88)
!105 = !DILocation(line: 24, column: 5, scope: !88)
!106 = distinct !{!106, !104, !107, !108, !109}
!107 = !DILocation(line: 24, column: 48, scope: !88)
!108 = !{!"llvm.loop.mustprogress"}
!109 = !{!"llvm.loop.unroll.disable"}
!110 = !DILocation(line: 25, column: 3, scope: !88)
!111 = !DILocation(line: 27, column: 11, scope: !88)
!112 = !{!113, !113, i64 0}
!113 = !{!"int", !99, i64 0}
!114 = !DILocation(line: 28, column: 3, scope: !88)
!115 = !DISubprogram(name: "pthread_mutex_lock", scope: !116, file: !116, line: 794, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!116 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!117 = !DISubroutineType(types: !118)
!118 = !{!19, !119}
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!120 = !DISubprogram(name: "pthread_cond_wait", scope: !116, file: !116, line: 1133, type: !121, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DISubroutineType(types: !122)
!122 = !{!19, !123, !125}
!123 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !124)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !119)
!126 = !DISubprogram(name: "pthread_mutex_unlock", scope: !116, file: !116, line: 835, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!127 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 31, type: !128, scopeLine: 31, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !130)
!128 = !DISubroutineType(types: !129)
!129 = !{!19}
!130 = !{!131, !132, !136, !138}
!131 = !DILocalVariable(name: "threads_total", scope: !127, file: !9, line: 32, type: !19)
!132 = !DILocalVariable(name: "tids", scope: !127, file: !9, line: 34, type: !133)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !135)
!135 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!136 = !DILocalVariable(name: "i", scope: !137, file: !9, line: 37, type: !19)
!137 = distinct !DILexicalBlock(scope: !127, file: !9, line: 37, column: 3)
!138 = !DILocalVariable(name: "i", scope: !139, file: !9, line: 50, type: !19)
!139 = distinct !DILexicalBlock(scope: !127, file: !9, line: 50, column: 3)
!140 = !DILocation(line: 0, scope: !127)
!141 = !DILocation(line: 34, column: 28, scope: !127)
!142 = !DILocation(line: 34, column: 42, scope: !127)
!143 = !DILocation(line: 34, column: 21, scope: !127)
!144 = !DILocation(line: 0, scope: !137)
!145 = !DILocation(line: 37, column: 3, scope: !137)
!146 = !DILocation(line: 38, column: 21, scope: !147)
!147 = distinct !DILexicalBlock(scope: !148, file: !9, line: 37, column: 43)
!148 = distinct !DILexicalBlock(scope: !137, file: !9, line: 37, column: 3)
!149 = !DILocation(line: 38, column: 5, scope: !147)
!150 = !DILocation(line: 39, column: 3, scope: !147)
!151 = !DILocation(line: 37, column: 39, scope: !148)
!152 = !DILocation(line: 37, column: 21, scope: !148)
!153 = distinct !{!153, !145, !154, !108, !109}
!154 = !DILocation(line: 39, column: 3, scope: !137)
!155 = !DILocation(line: 41, column: 8, scope: !127)
!156 = !DILocation(line: 44, column: 3, scope: !127)
!157 = !DILocation(line: 45, column: 9, scope: !127)
!158 = !DILocation(line: 46, column: 3, scope: !127)
!159 = !DILocation(line: 47, column: 3, scope: !127)
!160 = !DILocation(line: 0, scope: !139)
!161 = !DILocation(line: 50, column: 3, scope: !139)
!162 = !DILocation(line: 51, column: 18, scope: !163)
!163 = distinct !DILexicalBlock(scope: !164, file: !9, line: 50, column: 43)
!164 = distinct !DILexicalBlock(scope: !139, file: !9, line: 50, column: 3)
!165 = !{!166, !166, i64 0}
!166 = !{!"long", !99, i64 0}
!167 = !DILocation(line: 51, column: 5, scope: !163)
!168 = !DILocation(line: 52, column: 3, scope: !163)
!169 = !DILocation(line: 50, column: 39, scope: !164)
!170 = !DILocation(line: 50, column: 21, scope: !164)
!171 = distinct !{!171, !161, !172, !108, !109}
!172 = !DILocation(line: 52, column: 3, scope: !139)
!173 = !DILocation(line: 54, column: 3, scope: !127)
!174 = !DILocation(line: 56, column: 3, scope: !127)
!175 = !DISubprogram(name: "malloc", scope: !176, file: !176, line: 672, type: !177, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!176 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!177 = !DISubroutineType(types: !178)
!178 = !{!5, !179}
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !180, line: 18, baseType: !135)
!180 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!181 = !DISubprogram(name: "pthread_create", scope: !116, file: !116, line: 202, type: !182, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!182 = !DISubroutineType(types: !183)
!183 = !{!19, !184, !185, !196, !197}
!184 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !133)
!185 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !186)
!186 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !187, size: 64)
!187 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !188)
!188 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !189)
!189 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !190)
!190 = !{!191, !195}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !189, file: !11, line: 58, baseType: !192, size: 448)
!192 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !193)
!193 = !{!194}
!194 = !DISubrange(count: 56)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !189, file: !11, line: 59, baseType: !42, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!197 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!198 = !DISubprogram(name: "pthread_cond_broadcast", scope: !116, file: !116, line: 1125, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!199 = !DISubroutineType(types: !200)
!200 = !{!19, !124}
!201 = !DISubprogram(name: "pthread_join", scope: !116, file: !116, line: 219, type: !202, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!202 = !DISubroutineType(types: !203)
!203 = !{!19, !134, !204}
!204 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!205 = !DISubprogram(name: "free", scope: !176, file: !176, line: 687, type: !206, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!206 = !DISubroutineType(types: !207)
!207 = !{null, !5}
