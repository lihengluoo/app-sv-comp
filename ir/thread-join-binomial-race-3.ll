; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-binomial-race-3.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@data = dso_local global i32 0, align 4, !dbg !0
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !8
@threads_total = dso_local global i32 0, align 4, !dbg !43
@tids = dso_local global ptr null, align 8, !dbg !45

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !57 {
entry:
    #dbg_value(ptr %arg, !61, !DIExpression(), !68)
  %0 = ptrtoint ptr %arg to i32, !dbg !69
    #dbg_value(i32 %0, !62, !DIExpression(), !68)
  %call = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #4, !dbg !70
  store i32 4, ptr @data, align 4, !dbg !71, !tbaa !72
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #4, !dbg !76
    #dbg_value(i32 0, !63, !DIExpression(), !77)
  %rem5 = srem i32 %0, 2, !dbg !78
  %tobool6 = icmp ne i32 %rem5, 0, !dbg !78
  br i1 %tobool6, label %if.then, label %if.end.lr.ph, !dbg !78

if.end.lr.ph:                                     ; preds = %entry
  br label %if.end, !dbg !78

for.cond.if.then_crit_edge:                       ; preds = %for.inc
  br label %if.then, !dbg !78

if.then:                                          ; preds = %for.cond.if.then_crit_edge, %entry
  br label %cleanup6, !dbg !80

if.end:                                           ; preds = %if.end.lr.ph, %for.inc
  %step.07 = phi i32 [ 0, %if.end.lr.ph ], [ %inc, %for.inc ]
    #dbg_value(i32 %step.07, !63, !DIExpression(), !77)
  %shl2 = shl i32 1, %step.07, !dbg !81
  %or = or i32 %0, %shl2, !dbg !82
    #dbg_value(i32 %or, !65, !DIExpression(), !83)
  %1 = load i32, ptr @threads_total, align 4, !dbg !84, !tbaa !72
  %cmp = icmp uge i32 %or, %1, !dbg !86
  br i1 %cmp, label %if.then3, label %if.end4, !dbg !86

if.then3:                                         ; preds = %if.end
  br label %cleanup, !dbg !87

if.end4:                                          ; preds = %if.end
  %2 = load ptr, ptr @tids, align 8, !dbg !88, !tbaa !89
  %idxprom = zext i32 %or to i64, !dbg !88
  %arrayidx = getelementptr inbounds nuw i64, ptr %2, i64 %idxprom, !dbg !88
  %3 = load i64, ptr %arrayidx, align 8, !dbg !88, !tbaa !92
  %call5 = call i32 @pthread_join(i64 noundef %3, ptr noundef null), !dbg !94
  br label %cleanup, !dbg !95

cleanup:                                          ; preds = %if.end4, %if.then3
  %cleanup.dest.slot.0 = phi i32 [ 2, %if.then3 ], [ 0, %if.end4 ]
  switch i32 %cleanup.dest.slot.0, label %cleanup6.loopexit [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %for.inc, !dbg !96

for.inc:                                          ; preds = %cleanup.cont
  %inc = add i32 %step.07, 1, !dbg !97
    #dbg_value(i32 %inc, !63, !DIExpression(), !77)
  %shl = shl i32 2, %inc, !dbg !98
  %rem = srem i32 %0, %shl, !dbg !78
  %tobool = icmp ne i32 %rem, 0, !dbg !78
  br i1 %tobool, label %for.cond.if.then_crit_edge, label %if.end, !dbg !78, !llvm.loop !99

cleanup6.loopexit:                                ; preds = %cleanup
  br label %cleanup6

cleanup6:                                         ; preds = %cleanup6.loopexit, %if.then
  br label %for.end

for.end:                                          ; preds = %cleanup6
  ret ptr null, !dbg !103
}

; Function Attrs: nounwind
declare !dbg !104 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !109 i32 @pthread_mutex_unlock(ptr noundef) #1

declare !dbg !110 i32 @pthread_join(i64 noundef, ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !114 {
entry:
  store i32 4, ptr @threads_total, align 4, !dbg !120, !tbaa !72
  %0 = load i32, ptr @threads_total, align 4, !dbg !121, !tbaa !72
  %add = add nsw i32 %0, 1, !dbg !122
  %conv = sext i32 %add to i64, !dbg !123
  %mul = mul i64 %conv, 8, !dbg !124
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !125
  store ptr %call, ptr @tids, align 8, !dbg !126, !tbaa !89
  %1 = load i32, ptr @threads_total, align 4, !dbg !127, !tbaa !72
    #dbg_value(i32 %1, !118, !DIExpression(), !128)
  %cmp4 = icmp sge i32 %1, 0, !dbg !129
  br i1 %cmp4, label %for.body.lr.ph, label %for.cond.cleanup, !dbg !131

for.body.lr.ph:                                   ; preds = %entry
  %2 = sext i32 %1 to i64, !dbg !131
  br label %for.body, !dbg !131

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.inc
  br label %for.cond.cleanup, !dbg !131

for.cond.cleanup:                                 ; preds = %for.cond.for.cond.cleanup_crit_edge, %entry
  br label %for.end

for.body:                                         ; preds = %for.body.lr.ph, %for.inc
  %indvars.iv = phi i64 [ %2, %for.body.lr.ph ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !118, !DIExpression(), !128)
  %3 = load ptr, ptr @tids, align 8, !dbg !132, !tbaa !89
  %arrayidx = getelementptr inbounds i64, ptr %3, i64 %indvars.iv, !dbg !132
  %4 = inttoptr i64 %indvars.iv to ptr, !dbg !134
  %call3 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %4) #4, !dbg !135
  br label %for.inc, !dbg !136

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nsw i64 %indvars.iv, -1, !dbg !137
    #dbg_value(i64 %indvars.iv.next, !118, !DIExpression(), !128)
  %cmp = icmp sge i64 %indvars.iv.next, 0, !dbg !129
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge, !dbg !131, !llvm.loop !138

for.end:                                          ; preds = %for.cond.cleanup
  %5 = load ptr, ptr @tids, align 8, !dbg !141, !tbaa !89
  %arrayidx4 = getelementptr inbounds i64, ptr %5, i64 0, !dbg !141
  %6 = load i64, ptr %arrayidx4, align 8, !dbg !141, !tbaa !92
  %call5 = call i32 @pthread_join(i64 noundef %6, ptr noundef null), !dbg !142
  %7 = load ptr, ptr @tids, align 8, !dbg !143, !tbaa !89
  call void @free(ptr noundef %7) #4, !dbg !144
  %8 = load i32, ptr @data, align 4, !dbg !145, !tbaa !72
  ret i32 %8, !dbg !146
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !147 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !153 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !170 void @free(ptr noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!50}
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !10, line: 30, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-binomial-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "a075f4365ffd6e8dfb641b7b8e47280d")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8, !43, !45}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !10, line: 31, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "thread-join-binomial-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "a075f4365ffd6e8dfb641b7b8e47280d")
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
!44 = distinct !DIGlobalVariable(name: "threads_total", scope: !2, file: !10, line: 27, type: !5, isLocal: false, isDefinition: true)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "tids", scope: !2, file: !10, line: 28, type: !47, isLocal: false, isDefinition: true)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !12, line: 27, baseType: !49)
!49 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!50 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 8, !"PIC Level", i32 2}
!55 = !{i32 7, !"PIE Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 2}
!57 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 33, type: !58, scopeLine: 33, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{!6, !6}
!60 = !{!61, !62, !63, !65}
!61 = !DILocalVariable(name: "arg", arg: 1, scope: !57, file: !10, line: 33, type: !6)
!62 = !DILocalVariable(name: "i", scope: !57, file: !10, line: 34, type: !5)
!63 = !DILocalVariable(name: "step", scope: !64, file: !10, line: 41, type: !21)
!64 = distinct !DILexicalBlock(scope: !57, file: !10, line: 41, column: 3)
!65 = !DILocalVariable(name: "next_worker", scope: !66, file: !10, line: 45, type: !21)
!66 = distinct !DILexicalBlock(scope: !67, file: !10, line: 41, column: 39)
!67 = distinct !DILexicalBlock(scope: !64, file: !10, line: 41, column: 3)
!68 = !DILocation(line: 0, scope: !57)
!69 = !DILocation(line: 34, column: 11, scope: !57)
!70 = !DILocation(line: 35, column: 3, scope: !57)
!71 = !DILocation(line: 36, column: 8, scope: !57)
!72 = !{!73, !73, i64 0}
!73 = !{!"int", !74, i64 0}
!74 = !{!"omnipotent char", !75, i64 0}
!75 = !{!"Simple C/C++ TBAA"}
!76 = !DILocation(line: 37, column: 3, scope: !57)
!77 = !DILocation(line: 0, scope: !64)
!78 = !DILocation(line: 42, column: 11, scope: !79)
!79 = distinct !DILexicalBlock(scope: !66, file: !10, line: 42, column: 9)
!80 = !DILocation(line: 43, column: 7, scope: !79)
!81 = !DILocation(line: 45, column: 39, scope: !66)
!82 = !DILocation(line: 45, column: 34, scope: !66)
!83 = !DILocation(line: 0, scope: !66)
!84 = !DILocation(line: 46, column: 24, scope: !85)
!85 = distinct !DILexicalBlock(scope: !66, file: !10, line: 46, column: 9)
!86 = !DILocation(line: 46, column: 21, scope: !85)
!87 = !DILocation(line: 47, column: 7, scope: !85)
!88 = !DILocation(line: 49, column: 18, scope: !66)
!89 = !{!90, !90, i64 0}
!90 = !{!"p1 long", !91, i64 0}
!91 = !{!"any pointer", !74, i64 0}
!92 = !{!93, !93, i64 0}
!93 = !{!"long", !74, i64 0}
!94 = !DILocation(line: 49, column: 5, scope: !66)
!95 = !DILocation(line: 50, column: 3, scope: !67)
!96 = !DILocation(line: 50, column: 3, scope: !66)
!97 = !DILocation(line: 41, column: 35, scope: !67)
!98 = !DILocation(line: 42, column: 16, scope: !79)
!99 = distinct !{!99, !100, !101, !102}
!100 = !DILocation(line: 41, column: 3, scope: !64)
!101 = !DILocation(line: 50, column: 3, scope: !64)
!102 = !{!"llvm.loop.unroll.disable"}
!103 = !DILocation(line: 51, column: 3, scope: !57)
!104 = !DISubprogram(name: "pthread_mutex_lock", scope: !105, file: !105, line: 794, type: !106, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!105 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!106 = !DISubroutineType(types: !107)
!107 = !{!5, !108}
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!109 = !DISubprogram(name: "pthread_mutex_unlock", scope: !105, file: !105, line: 835, type: !106, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!110 = !DISubprogram(name: "pthread_join", scope: !105, file: !105, line: 219, type: !111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DISubroutineType(types: !112)
!112 = !{!5, !48, !113}
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!114 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 54, type: !115, scopeLine: 54, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !117)
!115 = !DISubroutineType(types: !116)
!116 = !{!5}
!117 = !{!118}
!118 = !DILocalVariable(name: "i", scope: !119, file: !10, line: 61, type: !5)
!119 = distinct !DILexicalBlock(scope: !114, file: !10, line: 61, column: 3)
!120 = !DILocation(line: 55, column: 17, scope: !114)
!121 = !DILocation(line: 57, column: 18, scope: !114)
!122 = !DILocation(line: 57, column: 32, scope: !114)
!123 = !DILocation(line: 57, column: 17, scope: !114)
!124 = !DILocation(line: 57, column: 37, scope: !114)
!125 = !DILocation(line: 57, column: 10, scope: !114)
!126 = !DILocation(line: 57, column: 8, scope: !114)
!127 = !DILocation(line: 61, column: 16, scope: !119)
!128 = !DILocation(line: 0, scope: !119)
!129 = !DILocation(line: 61, column: 33, scope: !130)
!130 = distinct !DILexicalBlock(scope: !119, file: !10, line: 61, column: 3)
!131 = !DILocation(line: 61, column: 3, scope: !119)
!132 = !DILocation(line: 62, column: 21, scope: !133)
!133 = distinct !DILexicalBlock(scope: !130, file: !10, line: 61, column: 44)
!134 = !DILocation(line: 62, column: 45, scope: !133)
!135 = !DILocation(line: 62, column: 5, scope: !133)
!136 = !DILocation(line: 63, column: 3, scope: !133)
!137 = !DILocation(line: 61, column: 40, scope: !130)
!138 = distinct !{!138, !131, !139, !140, !102}
!139 = !DILocation(line: 63, column: 3, scope: !119)
!140 = !{!"llvm.loop.mustprogress"}
!141 = !DILocation(line: 66, column: 16, scope: !114)
!142 = !DILocation(line: 66, column: 3, scope: !114)
!143 = !DILocation(line: 68, column: 8, scope: !114)
!144 = !DILocation(line: 68, column: 3, scope: !114)
!145 = !DILocation(line: 70, column: 10, scope: !114)
!146 = !DILocation(line: 70, column: 3, scope: !114)
!147 = !DISubprogram(name: "malloc", scope: !148, file: !148, line: 672, type: !149, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!148 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!149 = !DISubroutineType(types: !150)
!150 = !{!6, !151}
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !152, line: 18, baseType: !49)
!152 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!153 = !DISubprogram(name: "pthread_create", scope: !105, file: !105, line: 202, type: !154, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!154 = !DISubroutineType(types: !155)
!155 = !{!5, !156, !157, !168, !169}
!156 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !47)
!157 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !158)
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !160)
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !12, line: 62, baseType: !161)
!161 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !12, line: 56, size: 448, elements: !162)
!162 = !{!163, !167}
!163 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !161, file: !12, line: 58, baseType: !164, size: 448)
!164 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !165)
!165 = !{!166}
!166 = !DISubrange(count: 56)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !161, file: !12, line: 59, baseType: !42, size: 64)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!170 = !DISubprogram(name: "free", scope: !148, file: !148, line: 687, type: !171, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!171 = !DISubroutineType(types: !172)
!172 = !{null, !6}
