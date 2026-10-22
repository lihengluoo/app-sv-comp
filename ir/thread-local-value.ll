; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [5 x i8] c"cond\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [70 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.__VERIFIER_assert = private unnamed_addr constant [28 x i8] c"void __VERIFIER_assert(int)\00", align 1, !dbg !12
@data = dso_local thread_local global i32 0, align 4, !dbg !18

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !33 {
entry:
    #dbg_value(i32 %cond, !37, !DIExpression(), !38)
  %tobool = icmp ne i32 %cond, 0, !dbg !39
  br i1 %tobool, label %cond.true, label %cond.false, !dbg !39

cond.true:                                        ; preds = %entry
  br label %cond.end, !dbg !39

cond.false:                                       ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 14, ptr noundef @__PRETTY_FUNCTION__.__VERIFIER_assert) #6, !dbg !39
  unreachable, !dbg !39

0:                                                ; No predecessors!
  br label %cond.end, !dbg !39

cond.end:                                         ; preds = %0, %cond.true
  ret void, !dbg !40
}

; Function Attrs: noreturn nounwind
declare !dbg !41 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !47 {
entry:
    #dbg_value(ptr %arg, !51, !DIExpression(), !52)
  %0 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !53
  %1 = load i32, ptr %0, align 4, !dbg !53, !tbaa !54
  %cmp = icmp eq i32 %1, 0, !dbg !58
  %conv = zext i1 %cmp to i32, !dbg !58
  call void @__VERIFIER_assert(i32 noundef %conv), !dbg !59
  %2 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !60
  store i32 1, ptr %2, align 4, !dbg !61, !tbaa !54
  %3 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !62
  %4 = load i32, ptr %3, align 4, !dbg !62, !tbaa !54
  %cmp1 = icmp eq i32 %4, 1, !dbg !63
  %conv2 = zext i1 %cmp1 to i32, !dbg !63
  call void @__VERIFIER_assert(i32 noundef %conv2), !dbg !64
  %5 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !65
  %6 = load i32, ptr %5, align 4, !dbg !65, !tbaa !54
  %cmp3 = icmp ne i32 %6, 0, !dbg !66
  %conv4 = zext i1 %cmp3 to i32, !dbg !66
  call void @__VERIFIER_assert(i32 noundef %conv4), !dbg !67
  ret ptr null, !dbg !68
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !69 {
entry:
    #dbg_value(i32 4, !73, !DIExpression(), !83)
  %conv = sext i32 4 to i64, !dbg !84
  %mul = mul i64 %conv, 8, !dbg !85
  %call = call noalias ptr @malloc(i64 noundef %mul) #7, !dbg !86
    #dbg_value(ptr %call, !74, !DIExpression(), !83)
    #dbg_value(i32 0, !79, !DIExpression(), !87)
  br label %for.body, !dbg !88

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !79, !DIExpression(), !87)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !89
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #8, !dbg !92
  br label %for.inc, !dbg !93

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !94
    #dbg_value(i64 %indvars.iv.next, !79, !DIExpression(), !87)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !95
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !88, !llvm.loop !96

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !81, !DIExpression(), !100)
  br label %for.body8, !dbg !101

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !81, !DIExpression(), !100)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !102
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !102, !tbaa !105
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !107
  br label %for.inc12, !dbg !108

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !109
    #dbg_value(i64 %indvars.iv.next13, !81, !DIExpression(), !100)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !110
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !101, !llvm.loop !111

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #8, !dbg !113
  ret i32 0, !dbg !114
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !115 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !121 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #4

declare !dbg !140 i32 @pthread_join(i64 noundef, ptr noundef) #5

; Function Attrs: nounwind
declare !dbg !144 void @free(ptr noundef) #4

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind }
attributes #7 = { nounwind allocsize(0) }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!20}
!llvm.ident = !{!26}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-value.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "f6faa209a5b29cc98d9f1cfc5db3b1b2")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 5)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 560, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 70)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 224, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 28)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "data", scope: !20, file: !2, line: 17, type: !25, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "f6faa209a5b29cc98d9f1cfc5db3b1b2")
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!24 = !{!0, !7, !12, !18}
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 8, !"PIC Level", i32 2}
!31 = !{i32 7, !"PIE Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 2}
!33 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 13, type: !34, scopeLine: 13, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !36)
!34 = !DISubroutineType(types: !35)
!35 = !{null, !25}
!36 = !{!37}
!37 = !DILocalVariable(name: "cond", arg: 1, scope: !33, file: !2, line: 13, type: !25)
!38 = !DILocation(line: 0, scope: !33)
!39 = !DILocation(line: 14, column: 3, scope: !33)
!40 = !DILocation(line: 15, column: 1, scope: !33)
!41 = !DISubprogram(name: "__assert_fail", scope: !42, file: !42, line: 69, type: !43, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!42 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!43 = !DISubroutineType(types: !44)
!44 = !{null, !45, !45, !46, !45}
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!46 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!47 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 19, type: !48, scopeLine: 19, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !50)
!48 = !DISubroutineType(types: !49)
!49 = !{!23, !23}
!50 = !{!51}
!51 = !DILocalVariable(name: "arg", arg: 1, scope: !47, file: !2, line: 19, type: !23)
!52 = !DILocation(line: 0, scope: !47)
!53 = !DILocation(line: 20, column: 21, scope: !47)
!54 = !{!55, !55, i64 0}
!55 = !{!"int", !56, i64 0}
!56 = !{!"omnipotent char", !57, i64 0}
!57 = !{!"Simple C/C++ TBAA"}
!58 = !DILocation(line: 20, column: 26, scope: !47)
!59 = !DILocation(line: 20, column: 3, scope: !47)
!60 = !DILocation(line: 21, column: 3, scope: !47)
!61 = !DILocation(line: 21, column: 8, scope: !47)
!62 = !DILocation(line: 22, column: 21, scope: !47)
!63 = !DILocation(line: 22, column: 26, scope: !47)
!64 = !DILocation(line: 22, column: 3, scope: !47)
!65 = !DILocation(line: 23, column: 21, scope: !47)
!66 = !DILocation(line: 23, column: 26, scope: !47)
!67 = !DILocation(line: 23, column: 3, scope: !47)
!68 = !DILocation(line: 24, column: 3, scope: !47)
!69 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 27, type: !70, scopeLine: 27, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!25}
!72 = !{!73, !74, !79, !81}
!73 = !DILocalVariable(name: "threads_total", scope: !69, file: !2, line: 28, type: !25)
!74 = !DILocalVariable(name: "tids", scope: !69, file: !2, line: 30, type: !75)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !77, line: 27, baseType: !78)
!77 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!78 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!79 = !DILocalVariable(name: "i", scope: !80, file: !2, line: 33, type: !25)
!80 = distinct !DILexicalBlock(scope: !69, file: !2, line: 33, column: 3)
!81 = !DILocalVariable(name: "i", scope: !82, file: !2, line: 38, type: !25)
!82 = distinct !DILexicalBlock(scope: !69, file: !2, line: 38, column: 3)
!83 = !DILocation(line: 0, scope: !69)
!84 = !DILocation(line: 30, column: 28, scope: !69)
!85 = !DILocation(line: 30, column: 42, scope: !69)
!86 = !DILocation(line: 30, column: 21, scope: !69)
!87 = !DILocation(line: 0, scope: !80)
!88 = !DILocation(line: 33, column: 3, scope: !80)
!89 = !DILocation(line: 34, column: 21, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !2, line: 33, column: 43)
!91 = distinct !DILexicalBlock(scope: !80, file: !2, line: 33, column: 3)
!92 = !DILocation(line: 34, column: 5, scope: !90)
!93 = !DILocation(line: 35, column: 3, scope: !90)
!94 = !DILocation(line: 33, column: 39, scope: !91)
!95 = !DILocation(line: 33, column: 21, scope: !91)
!96 = distinct !{!96, !88, !97, !98, !99}
!97 = !DILocation(line: 35, column: 3, scope: !80)
!98 = !{!"llvm.loop.mustprogress"}
!99 = !{!"llvm.loop.unroll.disable"}
!100 = !DILocation(line: 0, scope: !82)
!101 = !DILocation(line: 38, column: 3, scope: !82)
!102 = !DILocation(line: 39, column: 18, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !2, line: 38, column: 43)
!104 = distinct !DILexicalBlock(scope: !82, file: !2, line: 38, column: 3)
!105 = !{!106, !106, i64 0}
!106 = !{!"long", !56, i64 0}
!107 = !DILocation(line: 39, column: 5, scope: !103)
!108 = !DILocation(line: 40, column: 3, scope: !103)
!109 = !DILocation(line: 38, column: 39, scope: !104)
!110 = !DILocation(line: 38, column: 21, scope: !104)
!111 = distinct !{!111, !101, !112, !98, !99}
!112 = !DILocation(line: 40, column: 3, scope: !82)
!113 = !DILocation(line: 42, column: 3, scope: !69)
!114 = !DILocation(line: 44, column: 3, scope: !69)
!115 = !DISubprogram(name: "malloc", scope: !116, file: !116, line: 672, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!116 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!117 = !DISubroutineType(types: !118)
!118 = !{!23, !119}
!119 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !120, line: 18, baseType: !78)
!120 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!121 = !DISubprogram(name: "pthread_create", scope: !122, file: !122, line: 202, type: !123, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!122 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!123 = !DISubroutineType(types: !124)
!124 = !{!25, !125, !126, !138, !139}
!125 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !75)
!126 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !127)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !129)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !77, line: 62, baseType: !130)
!130 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !77, line: 56, size: 448, elements: !131)
!131 = !{!132, !136}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !130, file: !77, line: 58, baseType: !133, size: 448)
!133 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !134)
!134 = !{!135}
!135 = !DISubrange(count: 56)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !130, file: !77, line: 59, baseType: !137, size: 64)
!137 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!140 = !DISubprogram(name: "pthread_join", scope: !122, file: !122, line: 219, type: !141, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!141 = !DISubroutineType(types: !142)
!142 = !{!25, !76, !143}
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!144 = !DISubprogram(name: "free", scope: !116, file: !116, line: 687, type: !145, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!145 = !DISubroutineType(types: !146)
!146 = !{null, !23}
