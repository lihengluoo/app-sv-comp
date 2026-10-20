; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-index-inc-race-2.linked.bc'
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
  %div = sdiv i32 %0, 2, !dbg !66
    #dbg_value(i32 %div, !58, !DIExpression(), !59)
  %1 = load i32, ptr @next_j, align 4, !dbg !67, !tbaa !62
  %inc = add nsw i32 %1, 1, !dbg !67
  store i32 %inc, ptr @next_j, align 4, !dbg !67, !tbaa !62
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @next_j_mutex) #4, !dbg !68
  %2 = load ptr, ptr @datas, align 8, !dbg !69, !tbaa !70
  %idxprom = sext i32 %div to i64, !dbg !69
  %arrayidx = getelementptr inbounds i32, ptr %2, i64 %idxprom, !dbg !69
  store i32 4, ptr %arrayidx, align 4, !dbg !73, !tbaa !62
  ret ptr null, !dbg !74
}

; Function Attrs: nounwind
declare !dbg !75 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !80 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !81 {
entry:
    #dbg_value(i32 4, !85, !DIExpression(), !94)
  %conv = sext i32 4 to i64, !dbg !95
  %mul = mul i64 %conv, 8, !dbg !96
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !97
    #dbg_value(ptr %call, !86, !DIExpression(), !94)
  %conv1 = sext i32 4 to i64, !dbg !98
  %mul2 = mul i64 %conv1, 4, !dbg !99
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #5, !dbg !100
  store ptr %call3, ptr @datas, align 8, !dbg !101, !tbaa !70
    #dbg_value(i32 0, !90, !DIExpression(), !102)
  br label %for.body, !dbg !103

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !90, !DIExpression(), !102)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !104
  %call5 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !107
  br label %for.inc, !dbg !108

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !109
    #dbg_value(i64 %indvars.iv.next, !90, !DIExpression(), !102)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !110
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !103, !llvm.loop !111

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !92, !DIExpression(), !115)
  br label %for.body11, !dbg !116

for.cond.cleanup10:                               ; preds = %for.inc15
  br label %for.end17

for.body11:                                       ; preds = %for.end, %for.inc15
  %indvars.iv13 = phi i64 [ 0, %for.end ], [ %indvars.iv.next14, %for.inc15 ]
    #dbg_value(i64 %indvars.iv13, !92, !DIExpression(), !115)
  %arrayidx13 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv13, !dbg !117
  %0 = load i64, ptr %arrayidx13, align 8, !dbg !117, !tbaa !120
  %call14 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !122
  br label %for.inc15, !dbg !123

for.inc15:                                        ; preds = %for.body11
  %indvars.iv.next14 = add nuw nsw i64 %indvars.iv13, 1, !dbg !124
    #dbg_value(i64 %indvars.iv.next14, !92, !DIExpression(), !115)
  %exitcond16 = icmp ne i64 %indvars.iv.next14, 4, !dbg !125
  br i1 %exitcond16, label %for.body11, label %for.cond.cleanup10, !dbg !116, !llvm.loop !126

for.end17:                                        ; preds = %for.cond.cleanup10
  call void @free(ptr noundef %call) #4, !dbg !128
  %1 = load ptr, ptr @datas, align 8, !dbg !129, !tbaa !70
  call void @free(ptr noundef %1) #4, !dbg !130
  ret i32 0, !dbg !131
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !132 noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare !dbg !138 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !155 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !159 void @free(ptr noundef) #1

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
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-index-inc-race-2.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "f750a2abdddb451fcd5ead5e9b79c609")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "next_j_mutex", scope: !2, file: !9, line: 17, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "per-thread-index-inc-race-2.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "f750a2abdddb451fcd5ead5e9b79c609")
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
!66 = !DILocation(line: 22, column: 14, scope: !53)
!67 = !DILocation(line: 23, column: 9, scope: !53)
!68 = !DILocation(line: 24, column: 3, scope: !53)
!69 = !DILocation(line: 26, column: 3, scope: !53)
!70 = !{!71, !71, i64 0}
!71 = !{!"p1 int", !72, i64 0}
!72 = !{!"any pointer", !64, i64 0}
!73 = !DILocation(line: 26, column: 12, scope: !53)
!74 = !DILocation(line: 27, column: 3, scope: !53)
!75 = !DISubprogram(name: "pthread_mutex_lock", scope: !76, file: !76, line: 794, type: !77, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!76 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!77 = !DISubroutineType(types: !78)
!78 = !{!19, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!80 = !DISubprogram(name: "pthread_mutex_unlock", scope: !76, file: !76, line: 835, type: !77, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!81 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 30, type: !82, scopeLine: 30, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !84)
!82 = !DISubroutineType(types: !83)
!83 = !{!19}
!84 = !{!85, !86, !90, !92}
!85 = !DILocalVariable(name: "threads_total", scope: !81, file: !9, line: 31, type: !19)
!86 = !DILocalVariable(name: "tids", scope: !81, file: !9, line: 33, type: !87)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !89)
!89 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!90 = !DILocalVariable(name: "i", scope: !91, file: !9, line: 37, type: !19)
!91 = distinct !DILexicalBlock(scope: !81, file: !9, line: 37, column: 3)
!92 = !DILocalVariable(name: "i", scope: !93, file: !9, line: 42, type: !19)
!93 = distinct !DILexicalBlock(scope: !81, file: !9, line: 42, column: 3)
!94 = !DILocation(line: 0, scope: !81)
!95 = !DILocation(line: 33, column: 28, scope: !81)
!96 = !DILocation(line: 33, column: 42, scope: !81)
!97 = !DILocation(line: 33, column: 21, scope: !81)
!98 = !DILocation(line: 34, column: 18, scope: !81)
!99 = !DILocation(line: 34, column: 32, scope: !81)
!100 = !DILocation(line: 34, column: 11, scope: !81)
!101 = !DILocation(line: 34, column: 9, scope: !81)
!102 = !DILocation(line: 0, scope: !91)
!103 = !DILocation(line: 37, column: 3, scope: !91)
!104 = !DILocation(line: 38, column: 21, scope: !105)
!105 = distinct !DILexicalBlock(scope: !106, file: !9, line: 37, column: 43)
!106 = distinct !DILexicalBlock(scope: !91, file: !9, line: 37, column: 3)
!107 = !DILocation(line: 38, column: 5, scope: !105)
!108 = !DILocation(line: 39, column: 3, scope: !105)
!109 = !DILocation(line: 37, column: 39, scope: !106)
!110 = !DILocation(line: 37, column: 21, scope: !106)
!111 = distinct !{!111, !103, !112, !113, !114}
!112 = !DILocation(line: 39, column: 3, scope: !91)
!113 = !{!"llvm.loop.mustprogress"}
!114 = !{!"llvm.loop.unroll.disable"}
!115 = !DILocation(line: 0, scope: !93)
!116 = !DILocation(line: 42, column: 3, scope: !93)
!117 = !DILocation(line: 43, column: 18, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !9, line: 42, column: 43)
!119 = distinct !DILexicalBlock(scope: !93, file: !9, line: 42, column: 3)
!120 = !{!121, !121, i64 0}
!121 = !{!"long", !64, i64 0}
!122 = !DILocation(line: 43, column: 5, scope: !118)
!123 = !DILocation(line: 44, column: 3, scope: !118)
!124 = !DILocation(line: 42, column: 39, scope: !119)
!125 = !DILocation(line: 42, column: 21, scope: !119)
!126 = distinct !{!126, !116, !127, !113, !114}
!127 = !DILocation(line: 44, column: 3, scope: !93)
!128 = !DILocation(line: 46, column: 3, scope: !81)
!129 = !DILocation(line: 47, column: 8, scope: !81)
!130 = !DILocation(line: 47, column: 3, scope: !81)
!131 = !DILocation(line: 49, column: 3, scope: !81)
!132 = !DISubprogram(name: "malloc", scope: !133, file: !133, line: 672, type: !134, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!133 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!134 = !DISubroutineType(types: !135)
!135 = !{!5, !136}
!136 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !137, line: 18, baseType: !89)
!137 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!138 = !DISubprogram(name: "pthread_create", scope: !76, file: !76, line: 202, type: !139, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!139 = !DISubroutineType(types: !140)
!140 = !{!19, !141, !142, !153, !154}
!141 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !87)
!142 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !143)
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !144, size: 64)
!144 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !145)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !146)
!146 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !147)
!147 = !{!148, !152}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !146, file: !11, line: 58, baseType: !149, size: 448)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 56)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !146, file: !11, line: 59, baseType: !42, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!155 = !DISubprogram(name: "pthread_join", scope: !76, file: !76, line: 219, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!156 = !DISubroutineType(types: !157)
!157 = !{!19, !88, !158}
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!159 = !DISubprogram(name: "free", scope: !133, file: !133, line: 687, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!160 = !DISubroutineType(types: !161)
!161 = !{null, !5}
