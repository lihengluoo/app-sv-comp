; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value-dynamic.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [5 x i8] c"cond\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-dynamic.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.__VERIFIER_assert = private unnamed_addr constant [28 x i8] c"void __VERIFIER_assert(int)\00", align 1, !dbg !12
@data = dso_local thread_local global ptr null, align 8, !dbg !18

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !34 {
entry:
    #dbg_value(i32 %cond, !38, !DIExpression(), !39)
  %tobool = icmp ne i32 %cond, 0, !dbg !40
  br i1 %tobool, label %cond.true, label %cond.false, !dbg !40

cond.true:                                        ; preds = %entry
  br label %cond.end, !dbg !40

cond.false:                                       ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 14, ptr noundef @__PRETTY_FUNCTION__.__VERIFIER_assert) #7, !dbg !40
  unreachable, !dbg !40

0:                                                ; No predecessors!
  br label %cond.end, !dbg !40

cond.end:                                         ; preds = %0, %cond.true
  ret void, !dbg !41
}

; Function Attrs: noreturn nounwind
declare !dbg !42 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !48 {
entry:
    #dbg_value(ptr %arg, !52, !DIExpression(), !58)
    #dbg_value(i32 4, !53, !DIExpression(), !58)
  %conv = sext i32 4 to i64, !dbg !59
  %call = call noalias ptr @calloc(i64 noundef %conv, i64 noundef 4) #8, !dbg !60
  %0 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !61
  store ptr %call, ptr %0, align 8, !dbg !62, !tbaa !63
    #dbg_value(i32 0, !54, !DIExpression(), !68)
  br label %for.body, !dbg !69

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !54, !DIExpression(), !68)
  %1 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !70
  %2 = load ptr, ptr %1, align 8, !dbg !70, !tbaa !63
  %arrayidx = getelementptr inbounds i32, ptr %2, i64 %indvars.iv, !dbg !70
  %3 = load i32, ptr %arrayidx, align 4, !dbg !70, !tbaa !73
  %cmp2 = icmp eq i32 %3, 0, !dbg !75
  %conv3 = zext i1 %cmp2 to i32, !dbg !75
  call void @__VERIFIER_assert(i32 noundef %conv3), !dbg !76
  br label %for.inc, !dbg !77

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !78
    #dbg_value(i64 %indvars.iv.next, !54, !DIExpression(), !68)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !79
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !69, !llvm.loop !80

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !56, !DIExpression(), !84)
  br label %for.body9, !dbg !85

for.cond.cleanup8:                                ; preds = %for.inc12
  br label %for.end14

for.body9:                                        ; preds = %for.end, %for.inc12
  %indvars.iv10 = phi i64 [ 0, %for.end ], [ %indvars.iv.next11, %for.inc12 ]
    #dbg_value(i64 %indvars.iv10, !56, !DIExpression(), !84)
  %4 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !86
  %5 = load ptr, ptr %4, align 8, !dbg !86, !tbaa !63
  %arrayidx11 = getelementptr inbounds i32, ptr %5, i64 %indvars.iv10, !dbg !86
  store i32 1, ptr %arrayidx11, align 4, !dbg !89, !tbaa !73
  br label %for.inc12, !dbg !90

for.inc12:                                        ; preds = %for.body9
  %indvars.iv.next11 = add nuw nsw i64 %indvars.iv10, 1, !dbg !91
    #dbg_value(i64 %indvars.iv.next11, !56, !DIExpression(), !84)
  %exitcond13 = icmp ne i64 %indvars.iv.next11, 4, !dbg !92
  br i1 %exitcond13, label %for.body9, label %for.cond.cleanup8, !dbg !85, !llvm.loop !93

for.end14:                                        ; preds = %for.cond.cleanup8
  %6 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !95
  %7 = load ptr, ptr %6, align 8, !dbg !95, !tbaa !63
  call void @free(ptr noundef %7) #9, !dbg !96
  ret ptr null, !dbg !97
}

; Function Attrs: nounwind allocsize(0,1)
declare !dbg !98 noalias ptr @calloc(i64 noundef, i64 noundef) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #3

; Function Attrs: nounwind
declare !dbg !105 void @free(ptr noundef) #4

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !108 {
entry:
    #dbg_value(i32 4, !112, !DIExpression(), !121)
  %conv = sext i32 4 to i64, !dbg !122
  %mul = mul i64 %conv, 8, !dbg !123
  %call = call noalias ptr @malloc(i64 noundef %mul) #10, !dbg !124
    #dbg_value(ptr %call, !113, !DIExpression(), !121)
    #dbg_value(i32 0, !117, !DIExpression(), !125)
  br label %for.body, !dbg !126

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !117, !DIExpression(), !125)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !127
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #9, !dbg !130
  br label %for.inc, !dbg !131

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !132
    #dbg_value(i64 %indvars.iv.next, !117, !DIExpression(), !125)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !133
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !126, !llvm.loop !134

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !119, !DIExpression(), !136)
  br label %for.body8, !dbg !137

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !119, !DIExpression(), !136)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !138
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !138, !tbaa !141
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !143
  br label %for.inc12, !dbg !144

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !145
    #dbg_value(i64 %indvars.iv.next13, !119, !DIExpression(), !136)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !146
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !137, !llvm.loop !147

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #9, !dbg !149
  ret i32 0, !dbg !150
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !151 noalias ptr @malloc(i64 noundef) #5

; Function Attrs: nounwind
declare !dbg !154 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #4

declare !dbg !173 i32 @pthread_join(i64 noundef, ptr noundef) #6

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0,1) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind allocsize(0,1) }
attributes #9 = { nounwind }
attributes #10 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!20}
!llvm.ident = !{!27}
!llvm.module.flags = !{!28, !29, !30, !31, !32, !33}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-value-dynamic.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "f176a54bd6075f5f73dec74b1998d090")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 5)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 624, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 78)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 224, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 28)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "data", scope: !20, file: !2, line: 17, type: !25, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-dynamic.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "f176a54bd6075f5f73dec74b1998d090")
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!24 = !{!0, !7, !12, !18}
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!28 = !{i32 7, !"Dwarf Version", i32 5}
!29 = !{i32 2, !"Debug Info Version", i32 3}
!30 = !{i32 1, !"wchar_size", i32 4}
!31 = !{i32 8, !"PIC Level", i32 2}
!32 = !{i32 7, !"PIE Level", i32 2}
!33 = !{i32 7, !"uwtable", i32 2}
!34 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 13, type: !35, scopeLine: 13, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !37)
!35 = !DISubroutineType(types: !36)
!36 = !{null, !26}
!37 = !{!38}
!38 = !DILocalVariable(name: "cond", arg: 1, scope: !34, file: !2, line: 13, type: !26)
!39 = !DILocation(line: 0, scope: !34)
!40 = !DILocation(line: 14, column: 3, scope: !34)
!41 = !DILocation(line: 15, column: 1, scope: !34)
!42 = !DISubprogram(name: "__assert_fail", scope: !43, file: !43, line: 69, type: !44, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!43 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!44 = !DISubroutineType(types: !45)
!45 = !{null, !46, !46, !47, !46}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!47 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!48 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 19, type: !49, scopeLine: 19, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !51)
!49 = !DISubroutineType(types: !50)
!50 = !{!23, !23}
!51 = !{!52, !53, !54, !56}
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !2, line: 19, type: !23)
!53 = !DILocalVariable(name: "n", scope: !48, file: !2, line: 20, type: !26)
!54 = !DILocalVariable(name: "i", scope: !55, file: !2, line: 24, type: !26)
!55 = distinct !DILexicalBlock(scope: !48, file: !2, line: 24, column: 3)
!56 = !DILocalVariable(name: "i", scope: !57, file: !2, line: 28, type: !26)
!57 = distinct !DILexicalBlock(scope: !48, file: !2, line: 28, column: 3)
!58 = !DILocation(line: 0, scope: !48)
!59 = !DILocation(line: 22, column: 17, scope: !48)
!60 = !DILocation(line: 22, column: 10, scope: !48)
!61 = !DILocation(line: 22, column: 3, scope: !48)
!62 = !DILocation(line: 22, column: 8, scope: !48)
!63 = !{!64, !64, i64 0}
!64 = !{!"p1 int", !65, i64 0}
!65 = !{!"any pointer", !66, i64 0}
!66 = !{!"omnipotent char", !67, i64 0}
!67 = !{!"Simple C/C++ TBAA"}
!68 = !DILocation(line: 0, scope: !55)
!69 = !DILocation(line: 24, column: 3, scope: !55)
!70 = !DILocation(line: 25, column: 23, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !2, line: 24, column: 31)
!72 = distinct !DILexicalBlock(scope: !55, file: !2, line: 24, column: 3)
!73 = !{!74, !74, i64 0}
!74 = !{!"int", !66, i64 0}
!75 = !DILocation(line: 25, column: 31, scope: !71)
!76 = !DILocation(line: 25, column: 5, scope: !71)
!77 = !DILocation(line: 26, column: 3, scope: !71)
!78 = !DILocation(line: 24, column: 27, scope: !72)
!79 = !DILocation(line: 24, column: 21, scope: !72)
!80 = distinct !{!80, !69, !81, !82, !83}
!81 = !DILocation(line: 26, column: 3, scope: !55)
!82 = !{!"llvm.loop.mustprogress"}
!83 = !{!"llvm.loop.unroll.disable"}
!84 = !DILocation(line: 0, scope: !57)
!85 = !DILocation(line: 28, column: 3, scope: !57)
!86 = !DILocation(line: 29, column: 5, scope: !87)
!87 = distinct !DILexicalBlock(scope: !88, file: !2, line: 28, column: 31)
!88 = distinct !DILexicalBlock(scope: !57, file: !2, line: 28, column: 3)
!89 = !DILocation(line: 29, column: 13, scope: !87)
!90 = !DILocation(line: 30, column: 3, scope: !87)
!91 = !DILocation(line: 28, column: 27, scope: !88)
!92 = !DILocation(line: 28, column: 21, scope: !88)
!93 = distinct !{!93, !85, !94, !82, !83}
!94 = !DILocation(line: 30, column: 3, scope: !57)
!95 = !DILocation(line: 32, column: 8, scope: !48)
!96 = !DILocation(line: 32, column: 3, scope: !48)
!97 = !DILocation(line: 33, column: 3, scope: !48)
!98 = !DISubprogram(name: "calloc", scope: !99, file: !99, line: 675, type: !100, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!99 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!100 = !DISubroutineType(types: !101)
!101 = !{!23, !102, !102}
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !103, line: 18, baseType: !104)
!103 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!104 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!105 = !DISubprogram(name: "free", scope: !99, file: !99, line: 687, type: !106, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!106 = !DISubroutineType(types: !107)
!107 = !{null, !23}
!108 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 36, type: !109, scopeLine: 36, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !111)
!109 = !DISubroutineType(types: !110)
!110 = !{!26}
!111 = !{!112, !113, !117, !119}
!112 = !DILocalVariable(name: "threads_total", scope: !108, file: !2, line: 37, type: !26)
!113 = !DILocalVariable(name: "tids", scope: !108, file: !2, line: 39, type: !114)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !116, line: 27, baseType: !104)
!116 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!117 = !DILocalVariable(name: "i", scope: !118, file: !2, line: 42, type: !26)
!118 = distinct !DILexicalBlock(scope: !108, file: !2, line: 42, column: 3)
!119 = !DILocalVariable(name: "i", scope: !120, file: !2, line: 47, type: !26)
!120 = distinct !DILexicalBlock(scope: !108, file: !2, line: 47, column: 3)
!121 = !DILocation(line: 0, scope: !108)
!122 = !DILocation(line: 39, column: 28, scope: !108)
!123 = !DILocation(line: 39, column: 42, scope: !108)
!124 = !DILocation(line: 39, column: 21, scope: !108)
!125 = !DILocation(line: 0, scope: !118)
!126 = !DILocation(line: 42, column: 3, scope: !118)
!127 = !DILocation(line: 43, column: 21, scope: !128)
!128 = distinct !DILexicalBlock(scope: !129, file: !2, line: 42, column: 43)
!129 = distinct !DILexicalBlock(scope: !118, file: !2, line: 42, column: 3)
!130 = !DILocation(line: 43, column: 5, scope: !128)
!131 = !DILocation(line: 44, column: 3, scope: !128)
!132 = !DILocation(line: 42, column: 39, scope: !129)
!133 = !DILocation(line: 42, column: 21, scope: !129)
!134 = distinct !{!134, !126, !135, !82, !83}
!135 = !DILocation(line: 44, column: 3, scope: !118)
!136 = !DILocation(line: 0, scope: !120)
!137 = !DILocation(line: 47, column: 3, scope: !120)
!138 = !DILocation(line: 48, column: 18, scope: !139)
!139 = distinct !DILexicalBlock(scope: !140, file: !2, line: 47, column: 43)
!140 = distinct !DILexicalBlock(scope: !120, file: !2, line: 47, column: 3)
!141 = !{!142, !142, i64 0}
!142 = !{!"long", !66, i64 0}
!143 = !DILocation(line: 48, column: 5, scope: !139)
!144 = !DILocation(line: 49, column: 3, scope: !139)
!145 = !DILocation(line: 47, column: 39, scope: !140)
!146 = !DILocation(line: 47, column: 21, scope: !140)
!147 = distinct !{!147, !137, !148, !82, !83}
!148 = !DILocation(line: 49, column: 3, scope: !120)
!149 = !DILocation(line: 51, column: 3, scope: !108)
!150 = !DILocation(line: 53, column: 3, scope: !108)
!151 = !DISubprogram(name: "malloc", scope: !99, file: !99, line: 672, type: !152, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!152 = !DISubroutineType(types: !153)
!153 = !{!23, !102}
!154 = !DISubprogram(name: "pthread_create", scope: !155, file: !155, line: 202, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!156 = !DISubroutineType(types: !157)
!157 = !{!26, !158, !159, !171, !172}
!158 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !114)
!159 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !160)
!160 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !161, size: 64)
!161 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !162)
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !116, line: 62, baseType: !163)
!163 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !116, line: 56, size: 448, elements: !164)
!164 = !{!165, !169}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !163, file: !116, line: 58, baseType: !166, size: 448)
!166 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !167)
!167 = !{!168}
!168 = !DISubrange(count: 56)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !163, file: !116, line: 59, baseType: !170, size: 64)
!170 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!173 = !DISubprogram(name: "pthread_join", scope: !155, file: !155, line: 219, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!174 = !DISubroutineType(types: !175)
!175 = !{!26, !115, !176}
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
