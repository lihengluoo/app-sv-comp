; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-index-bitmask-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@threads_mask = dso_local global i32 -1, align 4, !dbg !0
@datas = dso_local global ptr null, align 8, !dbg !8

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !19 {
entry:
    #dbg_value(ptr %arg, !23, !DIExpression(), !25)
  %0 = ptrtoint ptr %arg to i32, !dbg !26
    #dbg_value(i32 %0, !24, !DIExpression(), !25)
  %1 = load ptr, ptr @datas, align 8, !dbg !27, !tbaa !28
  %idxprom = sext i32 %0 to i64, !dbg !27
  %arrayidx = getelementptr inbounds i32, ptr %1, i64 %idxprom, !dbg !27
  store i32 4, ptr %arrayidx, align 4, !dbg !33, !tbaa !34
  %shl = shl i32 1, %0, !dbg !36
  %2 = load i32, ptr @threads_mask, align 4, !dbg !37, !tbaa !34
  %or = or i32 %2, %shl, !dbg !37
  store i32 %or, ptr @threads_mask, align 4, !dbg !37, !tbaa !34
  ret ptr null, !dbg !38
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !39 {
entry:
    #dbg_value(i32 4, !43, !DIExpression(), !56)
  %conv = sext i32 4 to i64, !dbg !57
  %mul = mul i64 %conv, 8, !dbg !58
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !59
    #dbg_value(ptr %call, !44, !DIExpression(), !56)
  %conv1 = sext i32 4 to i64, !dbg !60
  %mul2 = mul i64 %conv1, 4, !dbg !61
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #5, !dbg !62
  store ptr %call3, ptr @datas, align 8, !dbg !63, !tbaa !28
    #dbg_value(i32 0, !49, !DIExpression(), !64)
  br label %for.body, !dbg !65

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !49, !DIExpression(), !64)
  %0 = load i32, ptr @threads_mask, align 4, !dbg !66, !tbaa !34
  %call5 = call i32 @ffs(i32 noundef %0) #6, !dbg !67
  %sub = sub nsw i32 %call5, 1, !dbg !68
    #dbg_value(i32 %sub, !51, !DIExpression(), !69)
  %shl = shl i32 1, %sub, !dbg !70
  %not = xor i32 %shl, -1, !dbg !71
  %1 = load i32, ptr @threads_mask, align 4, !dbg !72, !tbaa !34
  %and = and i32 %1, %not, !dbg !72
  store i32 %and, ptr @threads_mask, align 4, !dbg !72, !tbaa !34
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !73
  %conv6 = sext i32 %sub to i64, !dbg !74
  %2 = inttoptr i64 %conv6 to ptr, !dbg !74
  %call7 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %2) #7, !dbg !75
  br label %for.inc, !dbg !76

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !77
    #dbg_value(i64 %indvars.iv.next, !49, !DIExpression(), !64)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !78
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !65, !llvm.loop !79

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !54, !DIExpression(), !83)
  br label %for.body13, !dbg !84

for.cond.cleanup12:                               ; preds = %for.inc17
  br label %for.end19

for.body13:                                       ; preds = %for.end, %for.inc17
  %indvars.iv14 = phi i64 [ 0, %for.end ], [ %indvars.iv.next15, %for.inc17 ]
    #dbg_value(i64 %indvars.iv14, !54, !DIExpression(), !83)
  %arrayidx15 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv14, !dbg !85
  %3 = load i64, ptr %arrayidx15, align 8, !dbg !85, !tbaa !88
  %call16 = call i32 @pthread_join(i64 noundef %3, ptr noundef null), !dbg !90
  br label %for.inc17, !dbg !91

for.inc17:                                        ; preds = %for.body13
  %indvars.iv.next15 = add nuw nsw i64 %indvars.iv14, 1, !dbg !92
    #dbg_value(i64 %indvars.iv.next15, !54, !DIExpression(), !83)
  %exitcond17 = icmp ne i64 %indvars.iv.next15, 4, !dbg !93
  br i1 %exitcond17, label %for.body13, label %for.cond.cleanup12, !dbg !84, !llvm.loop !94

for.end19:                                        ; preds = %for.cond.cleanup12
  call void @free(ptr noundef %call) #7, !dbg !96
  %4 = load ptr, ptr @datas, align 8, !dbg !97, !tbaa !28
  call void @free(ptr noundef %4) #7, !dbg !98
  ret i32 0, !dbg !99
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !100 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind willreturn memory(none)
declare !dbg !106 i32 @ffs(i32 noundef) #2

; Function Attrs: nounwind
declare !dbg !110 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare !dbg !130 i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: nounwind
declare !dbg !134 void @free(ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind willreturn memory(none) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind allocsize(0) }
attributes #6 = { nounwind willreturn memory(none) }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_mask", scope: !2, file: !10, line: 14, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-index-bitmask-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "b1d7b2f2b6bf999db89ef863e267c478")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !10, line: 16, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "per-thread-index-bitmask-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "b1d7b2f2b6bf999db89ef863e267c478")
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!12 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 8, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 2}
!19 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 18, type: !20, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !22)
!20 = !DISubroutineType(types: !21)
!21 = !{!6, !6}
!22 = !{!23, !24}
!23 = !DILocalVariable(name: "arg", arg: 1, scope: !19, file: !10, line: 18, type: !6)
!24 = !DILocalVariable(name: "j", scope: !19, file: !10, line: 19, type: !5)
!25 = !DILocation(line: 0, scope: !19)
!26 = !DILocation(line: 19, column: 11, scope: !19)
!27 = !DILocation(line: 20, column: 3, scope: !19)
!28 = !{!29, !29, i64 0}
!29 = !{!"p1 int", !30, i64 0}
!30 = !{!"any pointer", !31, i64 0}
!31 = !{!"omnipotent char", !32, i64 0}
!32 = !{!"Simple C/C++ TBAA"}
!33 = !DILocation(line: 20, column: 12, scope: !19)
!34 = !{!35, !35, i64 0}
!35 = !{!"int", !31, i64 0}
!36 = !DILocation(line: 23, column: 21, scope: !19)
!37 = !DILocation(line: 23, column: 16, scope: !19)
!38 = !DILocation(line: 24, column: 3, scope: !19)
!39 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 27, type: !40, scopeLine: 27, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !42)
!40 = !DISubroutineType(types: !41)
!41 = !{!5}
!42 = !{!43, !44, !49, !51, !54}
!43 = !DILocalVariable(name: "threads_total", scope: !39, file: !10, line: 28, type: !5)
!44 = !DILocalVariable(name: "tids", scope: !39, file: !10, line: 30, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !47, line: 27, baseType: !48)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!48 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!49 = !DILocalVariable(name: "i", scope: !50, file: !10, line: 34, type: !5)
!50 = distinct !DILexicalBlock(scope: !39, file: !10, line: 34, column: 3)
!51 = !DILocalVariable(name: "j", scope: !52, file: !10, line: 36, type: !5)
!52 = distinct !DILexicalBlock(scope: !53, file: !10, line: 34, column: 43)
!53 = distinct !DILexicalBlock(scope: !50, file: !10, line: 34, column: 3)
!54 = !DILocalVariable(name: "i", scope: !55, file: !10, line: 44, type: !5)
!55 = distinct !DILexicalBlock(scope: !39, file: !10, line: 44, column: 3)
!56 = !DILocation(line: 0, scope: !39)
!57 = !DILocation(line: 30, column: 28, scope: !39)
!58 = !DILocation(line: 30, column: 42, scope: !39)
!59 = !DILocation(line: 30, column: 21, scope: !39)
!60 = !DILocation(line: 31, column: 18, scope: !39)
!61 = !DILocation(line: 31, column: 32, scope: !39)
!62 = !DILocation(line: 31, column: 11, scope: !39)
!63 = !DILocation(line: 31, column: 9, scope: !39)
!64 = !DILocation(line: 0, scope: !50)
!65 = !DILocation(line: 34, column: 3, scope: !50)
!66 = !DILocation(line: 36, column: 17, scope: !52)
!67 = !DILocation(line: 36, column: 13, scope: !52)
!68 = !DILocation(line: 36, column: 31, scope: !52)
!69 = !DILocation(line: 0, scope: !52)
!70 = !DILocation(line: 38, column: 25, scope: !52)
!71 = !DILocation(line: 38, column: 21, scope: !52)
!72 = !DILocation(line: 38, column: 18, scope: !52)
!73 = !DILocation(line: 40, column: 21, scope: !52)
!74 = !DILocation(line: 40, column: 45, scope: !52)
!75 = !DILocation(line: 40, column: 5, scope: !52)
!76 = !DILocation(line: 41, column: 3, scope: !52)
!77 = !DILocation(line: 34, column: 39, scope: !53)
!78 = !DILocation(line: 34, column: 21, scope: !53)
!79 = distinct !{!79, !65, !80, !81, !82}
!80 = !DILocation(line: 41, column: 3, scope: !50)
!81 = !{!"llvm.loop.mustprogress"}
!82 = !{!"llvm.loop.unroll.disable"}
!83 = !DILocation(line: 0, scope: !55)
!84 = !DILocation(line: 44, column: 3, scope: !55)
!85 = !DILocation(line: 45, column: 18, scope: !86)
!86 = distinct !DILexicalBlock(scope: !87, file: !10, line: 44, column: 43)
!87 = distinct !DILexicalBlock(scope: !55, file: !10, line: 44, column: 3)
!88 = !{!89, !89, i64 0}
!89 = !{!"long", !31, i64 0}
!90 = !DILocation(line: 45, column: 5, scope: !86)
!91 = !DILocation(line: 46, column: 3, scope: !86)
!92 = !DILocation(line: 44, column: 39, scope: !87)
!93 = !DILocation(line: 44, column: 21, scope: !87)
!94 = distinct !{!94, !84, !95, !81, !82}
!95 = !DILocation(line: 46, column: 3, scope: !55)
!96 = !DILocation(line: 48, column: 3, scope: !39)
!97 = !DILocation(line: 49, column: 8, scope: !39)
!98 = !DILocation(line: 49, column: 3, scope: !39)
!99 = !DILocation(line: 51, column: 3, scope: !39)
!100 = !DISubprogram(name: "malloc", scope: !101, file: !101, line: 672, type: !102, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!101 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!102 = !DISubroutineType(types: !103)
!103 = !{!6, !104}
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !105, line: 18, baseType: !48)
!105 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!106 = !DISubprogram(name: "ffs", scope: !107, file: !107, line: 104, type: !108, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!107 = !DIFile(filename: "/usr/include/strings.h", directory: "", checksumkind: CSK_MD5, checksum: "5d92b6448a8d3cbcc2a27725c7a2efe7")
!108 = !DISubroutineType(types: !109)
!109 = !{!5, !5}
!110 = !DISubprogram(name: "pthread_create", scope: !111, file: !111, line: 202, type: !112, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!112 = !DISubroutineType(types: !113)
!113 = !{!5, !114, !115, !128, !129}
!114 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !45)
!115 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !116)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !118)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !47, line: 62, baseType: !119)
!119 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !47, line: 56, size: 448, elements: !120)
!120 = !{!121, !126}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !119, file: !47, line: 58, baseType: !122, size: 448)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !123, size: 448, elements: !124)
!123 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!124 = !{!125}
!125 = !DISubrange(count: 56)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !119, file: !47, line: 59, baseType: !127, size: 64)
!127 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!129 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!130 = !DISubprogram(name: "pthread_join", scope: !111, file: !111, line: 219, type: !131, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!131 = !DISubroutineType(types: !132)
!132 = !{!5, !46, !133}
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!134 = !DISubprogram(name: "free", scope: !101, file: !101, line: 687, type: !135, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!135 = !DISubroutineType(types: !136)
!136 = !{null, !6}
