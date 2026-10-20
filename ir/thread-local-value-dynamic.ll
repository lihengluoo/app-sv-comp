; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value-dynamic.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-dynamic.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1, !dbg !12
@data = dso_local thread_local global ptr null, align 8, !dbg !18

; Function Attrs: nounwind uwtable
define dso_local void @reach_error() #0 !dbg !34 {
entry:
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.reach_error) #7, !dbg !37
  unreachable, !dbg !37
}

; Function Attrs: noreturn nounwind
declare !dbg !38 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !44 {
entry:
    #dbg_value(i32 %cond, !48, !DIExpression(), !52)
  %tobool = icmp ne i32 %cond, 0, !dbg !53
  br i1 %tobool, label %if.end, label %if.then, !dbg !54

if.then:                                          ; preds = %entry
  br label %ERROR, !dbg !55

ERROR:                                            ; preds = %if.then
    #dbg_label(!49, !56)
  call void @reach_error(), !dbg !57
  call void @abort() #7, !dbg !59
  unreachable, !dbg !59

if.end:                                           ; preds = %entry
  ret void, !dbg !60
}

; Function Attrs: noreturn nounwind
declare !dbg !61 void @abort() #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !63 {
entry:
    #dbg_value(ptr %arg, !67, !DIExpression(), !73)
    #dbg_value(i32 4, !68, !DIExpression(), !73)
  %conv = sext i32 4 to i64, !dbg !74
  %call = call noalias ptr @calloc(i64 noundef %conv, i64 noundef 4) #8, !dbg !75
  %0 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !76
  store ptr %call, ptr %0, align 8, !dbg !77, !tbaa !78
    #dbg_value(i32 0, !69, !DIExpression(), !83)
  br label %for.body, !dbg !84

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !69, !DIExpression(), !83)
  %1 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !85
  %2 = load ptr, ptr %1, align 8, !dbg !85, !tbaa !78
  %arrayidx = getelementptr inbounds i32, ptr %2, i64 %indvars.iv, !dbg !85
  %3 = load i32, ptr %arrayidx, align 4, !dbg !85, !tbaa !88
  %cmp2 = icmp eq i32 %3, 0, !dbg !90
  %conv3 = zext i1 %cmp2 to i32, !dbg !90
  call void @__VERIFIER_assert(i32 noundef %conv3), !dbg !91
  br label %for.inc, !dbg !92

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !93
    #dbg_value(i64 %indvars.iv.next, !69, !DIExpression(), !83)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !94
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !84, !llvm.loop !95

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !71, !DIExpression(), !99)
  br label %for.body9, !dbg !100

for.cond.cleanup8:                                ; preds = %for.inc12
  br label %for.end14

for.body9:                                        ; preds = %for.end, %for.inc12
  %indvars.iv10 = phi i64 [ 0, %for.end ], [ %indvars.iv.next11, %for.inc12 ]
    #dbg_value(i64 %indvars.iv10, !71, !DIExpression(), !99)
  %4 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !101
  %5 = load ptr, ptr %4, align 8, !dbg !101, !tbaa !78
  %arrayidx11 = getelementptr inbounds i32, ptr %5, i64 %indvars.iv10, !dbg !101
  store i32 1, ptr %arrayidx11, align 4, !dbg !104, !tbaa !88
  br label %for.inc12, !dbg !105

for.inc12:                                        ; preds = %for.body9
  %indvars.iv.next11 = add nuw nsw i64 %indvars.iv10, 1, !dbg !106
    #dbg_value(i64 %indvars.iv.next11, !71, !DIExpression(), !99)
  %exitcond13 = icmp ne i64 %indvars.iv.next11, 4, !dbg !107
  br i1 %exitcond13, label %for.body9, label %for.cond.cleanup8, !dbg !100, !llvm.loop !108

for.end14:                                        ; preds = %for.cond.cleanup8
  %6 = call align 8 ptr @llvm.threadlocal.address.p0(ptr align 8 @data), !dbg !110
  %7 = load ptr, ptr %6, align 8, !dbg !110, !tbaa !78
  call void @free(ptr noundef %7) #9, !dbg !111
  ret ptr null, !dbg !112
}

; Function Attrs: nounwind allocsize(0,1)
declare !dbg !113 noalias ptr @calloc(i64 noundef, i64 noundef) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #3

; Function Attrs: nounwind
declare !dbg !119 void @free(ptr noundef) #4

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !122 {
entry:
    #dbg_value(i32 4, !126, !DIExpression(), !135)
  %conv = sext i32 4 to i64, !dbg !136
  %mul = mul i64 %conv, 8, !dbg !137
  %call = call noalias ptr @malloc(i64 noundef %mul) #10, !dbg !138
    #dbg_value(ptr %call, !127, !DIExpression(), !135)
    #dbg_value(i32 0, !131, !DIExpression(), !139)
  br label %for.body, !dbg !140

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !131, !DIExpression(), !139)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !141
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #9, !dbg !144
  br label %for.inc, !dbg !145

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !146
    #dbg_value(i64 %indvars.iv.next, !131, !DIExpression(), !139)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !147
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !140, !llvm.loop !148

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !133, !DIExpression(), !150)
  br label %for.body8, !dbg !151

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !133, !DIExpression(), !150)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !152
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !152, !tbaa !155
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !157
  br label %for.inc12, !dbg !158

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !159
    #dbg_value(i64 %indvars.iv.next13, !133, !DIExpression(), !150)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !160
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !151, !llvm.loop !161

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #9, !dbg !163
  ret i32 0, !dbg !164
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !165 noalias ptr @malloc(i64 noundef) #5

; Function Attrs: nounwind
declare !dbg !168 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #4

declare !dbg !187 i32 @pthread_join(i64 noundef, ptr noundef) #6

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
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-value-dynamic.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "0e8711f9a8b96efd5e25365cd003ff85")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 16, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 2)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 624, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 78)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 152, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 19)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "data", scope: !20, file: !2, line: 21, type: !25, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-dynamic.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "0e8711f9a8b96efd5e25365cd003ff85")
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
!34 = distinct !DISubprogram(name: "reach_error", scope: !2, file: !2, line: 13, type: !35, scopeLine: 13, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!35 = !DISubroutineType(types: !36)
!36 = !{null}
!37 = !DILocation(line: 13, column: 22, scope: !34)
!38 = !DISubprogram(name: "__assert_fail", scope: !39, file: !39, line: 69, type: !40, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!39 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!40 = !DISubroutineType(types: !41)
!41 = !{null, !42, !42, !43, !42}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!43 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!44 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 14, type: !45, scopeLine: 14, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !47)
!45 = !DISubroutineType(types: !46)
!46 = !{null, !26}
!47 = !{!48, !49}
!48 = !DILocalVariable(name: "cond", arg: 1, scope: !44, file: !2, line: 14, type: !26)
!49 = !DILabel(scope: !50, name: "ERROR", file: !2, line: 16, column: 5)
!50 = distinct !DILexicalBlock(scope: !51, file: !2, line: 15, column: 16)
!51 = distinct !DILexicalBlock(scope: !44, file: !2, line: 15, column: 7)
!52 = !DILocation(line: 0, scope: !44)
!53 = !DILocation(line: 15, column: 8, scope: !51)
!54 = !DILocation(line: 15, column: 7, scope: !51)
!55 = !DILocation(line: 15, column: 16, scope: !51)
!56 = !DILocation(line: 16, column: 5, scope: !50)
!57 = !DILocation(line: 16, column: 13, scope: !58)
!58 = distinct !DILexicalBlock(scope: !50, file: !2, line: 16, column: 12)
!59 = !DILocation(line: 16, column: 27, scope: !58)
!60 = !DILocation(line: 18, column: 3, scope: !44)
!61 = !DISubprogram(name: "abort", scope: !62, file: !62, line: 730, type: !35, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!62 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!63 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 23, type: !64, scopeLine: 23, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !66)
!64 = !DISubroutineType(types: !65)
!65 = !{!23, !23}
!66 = !{!67, !68, !69, !71}
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !63, file: !2, line: 23, type: !23)
!68 = !DILocalVariable(name: "n", scope: !63, file: !2, line: 24, type: !26)
!69 = !DILocalVariable(name: "i", scope: !70, file: !2, line: 28, type: !26)
!70 = distinct !DILexicalBlock(scope: !63, file: !2, line: 28, column: 3)
!71 = !DILocalVariable(name: "i", scope: !72, file: !2, line: 32, type: !26)
!72 = distinct !DILexicalBlock(scope: !63, file: !2, line: 32, column: 3)
!73 = !DILocation(line: 0, scope: !63)
!74 = !DILocation(line: 26, column: 17, scope: !63)
!75 = !DILocation(line: 26, column: 10, scope: !63)
!76 = !DILocation(line: 26, column: 3, scope: !63)
!77 = !DILocation(line: 26, column: 8, scope: !63)
!78 = !{!79, !79, i64 0}
!79 = !{!"p1 int", !80, i64 0}
!80 = !{!"any pointer", !81, i64 0}
!81 = !{!"omnipotent char", !82, i64 0}
!82 = !{!"Simple C/C++ TBAA"}
!83 = !DILocation(line: 0, scope: !70)
!84 = !DILocation(line: 28, column: 3, scope: !70)
!85 = !DILocation(line: 29, column: 23, scope: !86)
!86 = distinct !DILexicalBlock(scope: !87, file: !2, line: 28, column: 31)
!87 = distinct !DILexicalBlock(scope: !70, file: !2, line: 28, column: 3)
!88 = !{!89, !89, i64 0}
!89 = !{!"int", !81, i64 0}
!90 = !DILocation(line: 29, column: 31, scope: !86)
!91 = !DILocation(line: 29, column: 5, scope: !86)
!92 = !DILocation(line: 30, column: 3, scope: !86)
!93 = !DILocation(line: 28, column: 27, scope: !87)
!94 = !DILocation(line: 28, column: 21, scope: !87)
!95 = distinct !{!95, !84, !96, !97, !98}
!96 = !DILocation(line: 30, column: 3, scope: !70)
!97 = !{!"llvm.loop.mustprogress"}
!98 = !{!"llvm.loop.unroll.disable"}
!99 = !DILocation(line: 0, scope: !72)
!100 = !DILocation(line: 32, column: 3, scope: !72)
!101 = !DILocation(line: 33, column: 5, scope: !102)
!102 = distinct !DILexicalBlock(scope: !103, file: !2, line: 32, column: 31)
!103 = distinct !DILexicalBlock(scope: !72, file: !2, line: 32, column: 3)
!104 = !DILocation(line: 33, column: 13, scope: !102)
!105 = !DILocation(line: 34, column: 3, scope: !102)
!106 = !DILocation(line: 32, column: 27, scope: !103)
!107 = !DILocation(line: 32, column: 21, scope: !103)
!108 = distinct !{!108, !100, !109, !97, !98}
!109 = !DILocation(line: 34, column: 3, scope: !72)
!110 = !DILocation(line: 36, column: 8, scope: !63)
!111 = !DILocation(line: 36, column: 3, scope: !63)
!112 = !DILocation(line: 37, column: 3, scope: !63)
!113 = !DISubprogram(name: "calloc", scope: !62, file: !62, line: 675, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!114 = !DISubroutineType(types: !115)
!115 = !{!23, !116, !116}
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !117, line: 18, baseType: !118)
!117 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!118 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!119 = !DISubprogram(name: "free", scope: !62, file: !62, line: 687, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!120 = !DISubroutineType(types: !121)
!121 = !{null, !23}
!122 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 40, type: !123, scopeLine: 40, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !125)
!123 = !DISubroutineType(types: !124)
!124 = !{!26}
!125 = !{!126, !127, !131, !133}
!126 = !DILocalVariable(name: "threads_total", scope: !122, file: !2, line: 41, type: !26)
!127 = !DILocalVariable(name: "tids", scope: !122, file: !2, line: 43, type: !128)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !130, line: 27, baseType: !118)
!130 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!131 = !DILocalVariable(name: "i", scope: !132, file: !2, line: 46, type: !26)
!132 = distinct !DILexicalBlock(scope: !122, file: !2, line: 46, column: 3)
!133 = !DILocalVariable(name: "i", scope: !134, file: !2, line: 51, type: !26)
!134 = distinct !DILexicalBlock(scope: !122, file: !2, line: 51, column: 3)
!135 = !DILocation(line: 0, scope: !122)
!136 = !DILocation(line: 43, column: 28, scope: !122)
!137 = !DILocation(line: 43, column: 42, scope: !122)
!138 = !DILocation(line: 43, column: 21, scope: !122)
!139 = !DILocation(line: 0, scope: !132)
!140 = !DILocation(line: 46, column: 3, scope: !132)
!141 = !DILocation(line: 47, column: 21, scope: !142)
!142 = distinct !DILexicalBlock(scope: !143, file: !2, line: 46, column: 43)
!143 = distinct !DILexicalBlock(scope: !132, file: !2, line: 46, column: 3)
!144 = !DILocation(line: 47, column: 5, scope: !142)
!145 = !DILocation(line: 48, column: 3, scope: !142)
!146 = !DILocation(line: 46, column: 39, scope: !143)
!147 = !DILocation(line: 46, column: 21, scope: !143)
!148 = distinct !{!148, !140, !149, !97, !98}
!149 = !DILocation(line: 48, column: 3, scope: !132)
!150 = !DILocation(line: 0, scope: !134)
!151 = !DILocation(line: 51, column: 3, scope: !134)
!152 = !DILocation(line: 52, column: 18, scope: !153)
!153 = distinct !DILexicalBlock(scope: !154, file: !2, line: 51, column: 43)
!154 = distinct !DILexicalBlock(scope: !134, file: !2, line: 51, column: 3)
!155 = !{!156, !156, i64 0}
!156 = !{!"long", !81, i64 0}
!157 = !DILocation(line: 52, column: 5, scope: !153)
!158 = !DILocation(line: 53, column: 3, scope: !153)
!159 = !DILocation(line: 51, column: 39, scope: !154)
!160 = !DILocation(line: 51, column: 21, scope: !154)
!161 = distinct !{!161, !151, !162, !97, !98}
!162 = !DILocation(line: 53, column: 3, scope: !134)
!163 = !DILocation(line: 55, column: 3, scope: !122)
!164 = !DILocation(line: 57, column: 3, scope: !122)
!165 = !DISubprogram(name: "malloc", scope: !62, file: !62, line: 672, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DISubroutineType(types: !167)
!167 = !{!23, !116}
!168 = !DISubprogram(name: "pthread_create", scope: !169, file: !169, line: 202, type: !170, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!169 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!170 = !DISubroutineType(types: !171)
!171 = !{!26, !172, !173, !185, !186}
!172 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !128)
!173 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !174)
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !175, size: 64)
!175 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !176)
!176 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !130, line: 62, baseType: !177)
!177 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !130, line: 56, size: 448, elements: !178)
!178 = !{!179, !183}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !177, file: !130, line: 58, baseType: !180, size: 448)
!180 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !181)
!181 = !{!182}
!182 = !DISubrange(count: 56)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !177, file: !130, line: 59, baseType: !184, size: 64)
!184 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!186 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!187 = !DISubprogram(name: "pthread_join", scope: !169, file: !169, line: 219, type: !188, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!188 = !DISubroutineType(types: !189)
!189 = !{!26, !129, !190}
!190 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
