; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-index-inc.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@next_j = dso_local global i32 0, align 4, !dbg !0
@next_j_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@datas = dso_local global ptr null, align 8, !dbg !43

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !53 {
entry:
    #dbg_value(ptr %arg, !57, !DIExpression(), !59)
  %call = call i32 @pthread_mutex_lock(ptr noundef @next_j_mutex) #4, !dbg !60
  %0 = load i32, ptr @next_j, align 4, !dbg !61, !tbaa !62
    #dbg_value(i32 %0, !58, !DIExpression(), !59)
  %1 = load i32, ptr @next_j, align 4, !dbg !66, !tbaa !62
  %inc = add nsw i32 %1, 1, !dbg !66
  store i32 %inc, ptr @next_j, align 4, !dbg !66, !tbaa !62
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @next_j_mutex) #4, !dbg !67
  %2 = load ptr, ptr @datas, align 8, !dbg !68, !tbaa !69
  %idxprom = sext i32 %0 to i64, !dbg !68
  %arrayidx = getelementptr inbounds i32, ptr %2, i64 %idxprom, !dbg !68
  store i32 4, ptr %arrayidx, align 4, !dbg !72, !tbaa !62
  ret ptr null, !dbg !73
}

; Function Attrs: nounwind
declare !dbg !74 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !79 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !80 {
entry:
    #dbg_value(i32 4, !84, !DIExpression(), !93)
  %conv = sext i32 4 to i64, !dbg !94
  %mul = mul i64 %conv, 8, !dbg !95
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !96
    #dbg_value(ptr %call, !85, !DIExpression(), !93)
  %conv1 = sext i32 4 to i64, !dbg !97
  %mul2 = mul i64 %conv1, 4, !dbg !98
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #5, !dbg !99
  store ptr %call3, ptr @datas, align 8, !dbg !100, !tbaa !69
    #dbg_value(i32 0, !89, !DIExpression(), !101)
  br label %for.body, !dbg !102

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !89, !DIExpression(), !101)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !103
  %call5 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !106
  br label %for.inc, !dbg !107

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !108
    #dbg_value(i64 %indvars.iv.next, !89, !DIExpression(), !101)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !109
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !102, !llvm.loop !110

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !91, !DIExpression(), !114)
  br label %for.body11, !dbg !115

for.cond.cleanup10:                               ; preds = %for.inc15
  br label %for.end17

for.body11:                                       ; preds = %for.end, %for.inc15
  %indvars.iv13 = phi i64 [ 0, %for.end ], [ %indvars.iv.next14, %for.inc15 ]
    #dbg_value(i64 %indvars.iv13, !91, !DIExpression(), !114)
  %arrayidx13 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv13, !dbg !116
  %0 = load i64, ptr %arrayidx13, align 8, !dbg !116, !tbaa !119
  %call14 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !121
  br label %for.inc15, !dbg !122

for.inc15:                                        ; preds = %for.body11
  %indvars.iv.next14 = add nuw nsw i64 %indvars.iv13, 1, !dbg !123
    #dbg_value(i64 %indvars.iv.next14, !91, !DIExpression(), !114)
  %exitcond16 = icmp ne i64 %indvars.iv.next14, 4, !dbg !124
  br i1 %exitcond16, label %for.body11, label %for.cond.cleanup10, !dbg !115, !llvm.loop !125

for.end17:                                        ; preds = %for.cond.cleanup10
  call void @free(ptr noundef %call) #4, !dbg !127
  %1 = load ptr, ptr @datas, align 8, !dbg !128, !tbaa !69
  call void @free(ptr noundef %1) #4, !dbg !129
  ret i32 0, !dbg !130
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !131 noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare !dbg !137 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !154 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !158 void @free(ptr noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!46}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "next_j", scope: !2, file: !9, line: 16, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-index-inc.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "ae3f460d995bbfd1a6fa3d97653774d8")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "next_j_mutex", scope: !2, file: !9, line: 17, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "per-thread-index-inc.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "ae3f460d995bbfd1a6fa3d97653774d8")
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
!44 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !9, line: 14, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!46 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 2}
!53 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 19, type: !54, scopeLine: 19, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!5, !5}
!56 = !{!57, !58}
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !53, file: !9, line: 19, type: !5)
!58 = !DILocalVariable(name: "j", scope: !53, file: !9, line: 20, type: !19)
!59 = !DILocation(line: 0, scope: !53)
!60 = !DILocation(line: 21, column: 3, scope: !53)
!61 = !DILocation(line: 22, column: 7, scope: !53)
!62 = !{!63, !63, i64 0}
!63 = !{!"int", !64, i64 0}
!64 = !{!"omnipotent char", !65, i64 0}
!65 = !{!"Simple C/C++ TBAA"}
!66 = !DILocation(line: 23, column: 9, scope: !53)
!67 = !DILocation(line: 24, column: 3, scope: !53)
!68 = !DILocation(line: 26, column: 3, scope: !53)
!69 = !{!70, !70, i64 0}
!70 = !{!"p1 int", !71, i64 0}
!71 = !{!"any pointer", !64, i64 0}
!72 = !DILocation(line: 26, column: 12, scope: !53)
!73 = !DILocation(line: 27, column: 3, scope: !53)
!74 = !DISubprogram(name: "pthread_mutex_lock", scope: !75, file: !75, line: 794, type: !76, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!75 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!76 = !DISubroutineType(types: !77)
!77 = !{!19, !78}
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!79 = !DISubprogram(name: "pthread_mutex_unlock", scope: !75, file: !75, line: 835, type: !76, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!80 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 30, type: !81, scopeLine: 30, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !83)
!81 = !DISubroutineType(types: !82)
!82 = !{!19}
!83 = !{!84, !85, !89, !91}
!84 = !DILocalVariable(name: "threads_total", scope: !80, file: !9, line: 31, type: !19)
!85 = !DILocalVariable(name: "tids", scope: !80, file: !9, line: 33, type: !86)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !88)
!88 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!89 = !DILocalVariable(name: "i", scope: !90, file: !9, line: 37, type: !19)
!90 = distinct !DILexicalBlock(scope: !80, file: !9, line: 37, column: 3)
!91 = !DILocalVariable(name: "i", scope: !92, file: !9, line: 42, type: !19)
!92 = distinct !DILexicalBlock(scope: !80, file: !9, line: 42, column: 3)
!93 = !DILocation(line: 0, scope: !80)
!94 = !DILocation(line: 33, column: 28, scope: !80)
!95 = !DILocation(line: 33, column: 42, scope: !80)
!96 = !DILocation(line: 33, column: 21, scope: !80)
!97 = !DILocation(line: 34, column: 18, scope: !80)
!98 = !DILocation(line: 34, column: 32, scope: !80)
!99 = !DILocation(line: 34, column: 11, scope: !80)
!100 = !DILocation(line: 34, column: 9, scope: !80)
!101 = !DILocation(line: 0, scope: !90)
!102 = !DILocation(line: 37, column: 3, scope: !90)
!103 = !DILocation(line: 38, column: 21, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !9, line: 37, column: 43)
!105 = distinct !DILexicalBlock(scope: !90, file: !9, line: 37, column: 3)
!106 = !DILocation(line: 38, column: 5, scope: !104)
!107 = !DILocation(line: 39, column: 3, scope: !104)
!108 = !DILocation(line: 37, column: 39, scope: !105)
!109 = !DILocation(line: 37, column: 21, scope: !105)
!110 = distinct !{!110, !102, !111, !112, !113}
!111 = !DILocation(line: 39, column: 3, scope: !90)
!112 = !{!"llvm.loop.mustprogress"}
!113 = !{!"llvm.loop.unroll.disable"}
!114 = !DILocation(line: 0, scope: !92)
!115 = !DILocation(line: 42, column: 3, scope: !92)
!116 = !DILocation(line: 43, column: 18, scope: !117)
!117 = distinct !DILexicalBlock(scope: !118, file: !9, line: 42, column: 43)
!118 = distinct !DILexicalBlock(scope: !92, file: !9, line: 42, column: 3)
!119 = !{!120, !120, i64 0}
!120 = !{!"long", !64, i64 0}
!121 = !DILocation(line: 43, column: 5, scope: !117)
!122 = !DILocation(line: 44, column: 3, scope: !117)
!123 = !DILocation(line: 42, column: 39, scope: !118)
!124 = !DILocation(line: 42, column: 21, scope: !118)
!125 = distinct !{!125, !115, !126, !112, !113}
!126 = !DILocation(line: 44, column: 3, scope: !92)
!127 = !DILocation(line: 46, column: 3, scope: !80)
!128 = !DILocation(line: 47, column: 8, scope: !80)
!129 = !DILocation(line: 47, column: 3, scope: !80)
!130 = !DILocation(line: 49, column: 3, scope: !80)
!131 = !DISubprogram(name: "malloc", scope: !132, file: !132, line: 672, type: !133, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!132 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!133 = !DISubroutineType(types: !134)
!134 = !{!5, !135}
!135 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !136, line: 18, baseType: !88)
!136 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!137 = !DISubprogram(name: "pthread_create", scope: !75, file: !75, line: 202, type: !138, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!138 = !DISubroutineType(types: !139)
!139 = !{!19, !140, !141, !152, !153}
!140 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !86)
!141 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !142)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !144)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !145)
!145 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !146)
!146 = !{!147, !151}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !145, file: !11, line: 58, baseType: !148, size: 448)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !149)
!149 = !{!150}
!150 = !DISubrange(count: 56)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !145, file: !11, line: 59, baseType: !42, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!154 = !DISubprogram(name: "pthread_join", scope: !75, file: !75, line: 219, type: !155, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DISubroutineType(types: !156)
!156 = !{!19, !87, !157}
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!158 = !DISubprogram(name: "free", scope: !132, file: !132, line: 687, type: !159, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!159 = !DISubroutineType(types: !160)
!160 = !{null, !5}
