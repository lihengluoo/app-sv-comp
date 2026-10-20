; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [70 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1, !dbg !12
@data = dso_local thread_local global i32 0, align 4, !dbg !18

; Function Attrs: nounwind uwtable
define dso_local void @reach_error() #0 !dbg !33 {
entry:
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.reach_error) #6, !dbg !36
  unreachable, !dbg !36
}

; Function Attrs: noreturn nounwind
declare !dbg !37 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !43 {
entry:
    #dbg_value(i32 %cond, !47, !DIExpression(), !51)
  %tobool = icmp ne i32 %cond, 0, !dbg !52
  br i1 %tobool, label %if.end, label %if.then, !dbg !53

if.then:                                          ; preds = %entry
  br label %ERROR, !dbg !54

ERROR:                                            ; preds = %if.then
    #dbg_label(!48, !55)
  call void @reach_error(), !dbg !56
  call void @abort() #6, !dbg !58
  unreachable, !dbg !58

if.end:                                           ; preds = %entry
  ret void, !dbg !59
}

; Function Attrs: noreturn nounwind
declare !dbg !60 void @abort() #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !62 {
entry:
    #dbg_value(ptr %arg, !66, !DIExpression(), !67)
  %0 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !68
  %1 = load i32, ptr %0, align 4, !dbg !68, !tbaa !69
  %cmp = icmp eq i32 %1, 0, !dbg !73
  %conv = zext i1 %cmp to i32, !dbg !73
  call void @__VERIFIER_assert(i32 noundef %conv), !dbg !74
  %2 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !75
  store i32 1, ptr %2, align 4, !dbg !76, !tbaa !69
  %3 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !77
  %4 = load i32, ptr %3, align 4, !dbg !77, !tbaa !69
  %cmp1 = icmp eq i32 %4, 1, !dbg !78
  %conv2 = zext i1 %cmp1 to i32, !dbg !78
  call void @__VERIFIER_assert(i32 noundef %conv2), !dbg !79
  %5 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !80
  %6 = load i32, ptr %5, align 4, !dbg !80, !tbaa !69
  %cmp3 = icmp ne i32 %6, 0, !dbg !81
  %conv4 = zext i1 %cmp3 to i32, !dbg !81
  call void @__VERIFIER_assert(i32 noundef %conv4), !dbg !82
  ret ptr null, !dbg !83
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !84 {
entry:
    #dbg_value(i32 4, !88, !DIExpression(), !98)
  %conv = sext i32 4 to i64, !dbg !99
  %mul = mul i64 %conv, 8, !dbg !100
  %call = call noalias ptr @malloc(i64 noundef %mul) #7, !dbg !101
    #dbg_value(ptr %call, !89, !DIExpression(), !98)
    #dbg_value(i32 0, !94, !DIExpression(), !102)
  br label %for.body, !dbg !103

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !94, !DIExpression(), !102)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !104
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #8, !dbg !107
  br label %for.inc, !dbg !108

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !109
    #dbg_value(i64 %indvars.iv.next, !94, !DIExpression(), !102)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !110
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !103, !llvm.loop !111

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !96, !DIExpression(), !115)
  br label %for.body8, !dbg !116

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !96, !DIExpression(), !115)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !117
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !117, !tbaa !120
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !122
  br label %for.inc12, !dbg !123

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !124
    #dbg_value(i64 %indvars.iv.next13, !96, !DIExpression(), !115)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !125
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !116, !llvm.loop !126

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #8, !dbg !128
  ret i32 0, !dbg !129
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !130 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !135 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #4

declare !dbg !154 i32 @pthread_join(i64 noundef, ptr noundef) #5

; Function Attrs: nounwind
declare !dbg !158 void @free(ptr noundef) #4

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
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-value.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "9fe45be10575fb9515d857ff33fb5c4d")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 16, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 2)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 560, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 70)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 152, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 19)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "data", scope: !20, file: !2, line: 21, type: !25, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "9fe45be10575fb9515d857ff33fb5c4d")
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
!33 = distinct !DISubprogram(name: "reach_error", scope: !2, file: !2, line: 13, type: !34, scopeLine: 13, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!34 = !DISubroutineType(types: !35)
!35 = !{null}
!36 = !DILocation(line: 13, column: 22, scope: !33)
!37 = !DISubprogram(name: "__assert_fail", scope: !38, file: !38, line: 69, type: !39, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!38 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!39 = !DISubroutineType(types: !40)
!40 = !{null, !41, !41, !42, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!42 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!43 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 14, type: !44, scopeLine: 14, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !46)
!44 = !DISubroutineType(types: !45)
!45 = !{null, !25}
!46 = !{!47, !48}
!47 = !DILocalVariable(name: "cond", arg: 1, scope: !43, file: !2, line: 14, type: !25)
!48 = !DILabel(scope: !49, name: "ERROR", file: !2, line: 16, column: 5)
!49 = distinct !DILexicalBlock(scope: !50, file: !2, line: 15, column: 16)
!50 = distinct !DILexicalBlock(scope: !43, file: !2, line: 15, column: 7)
!51 = !DILocation(line: 0, scope: !43)
!52 = !DILocation(line: 15, column: 8, scope: !50)
!53 = !DILocation(line: 15, column: 7, scope: !50)
!54 = !DILocation(line: 15, column: 16, scope: !50)
!55 = !DILocation(line: 16, column: 5, scope: !49)
!56 = !DILocation(line: 16, column: 13, scope: !57)
!57 = distinct !DILexicalBlock(scope: !49, file: !2, line: 16, column: 12)
!58 = !DILocation(line: 16, column: 27, scope: !57)
!59 = !DILocation(line: 18, column: 3, scope: !43)
!60 = !DISubprogram(name: "abort", scope: !61, file: !61, line: 730, type: !34, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!61 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!62 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 23, type: !63, scopeLine: 23, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !65)
!63 = !DISubroutineType(types: !64)
!64 = !{!23, !23}
!65 = !{!66}
!66 = !DILocalVariable(name: "arg", arg: 1, scope: !62, file: !2, line: 23, type: !23)
!67 = !DILocation(line: 0, scope: !62)
!68 = !DILocation(line: 24, column: 21, scope: !62)
!69 = !{!70, !70, i64 0}
!70 = !{!"int", !71, i64 0}
!71 = !{!"omnipotent char", !72, i64 0}
!72 = !{!"Simple C/C++ TBAA"}
!73 = !DILocation(line: 24, column: 26, scope: !62)
!74 = !DILocation(line: 24, column: 3, scope: !62)
!75 = !DILocation(line: 25, column: 3, scope: !62)
!76 = !DILocation(line: 25, column: 8, scope: !62)
!77 = !DILocation(line: 26, column: 21, scope: !62)
!78 = !DILocation(line: 26, column: 26, scope: !62)
!79 = !DILocation(line: 26, column: 3, scope: !62)
!80 = !DILocation(line: 27, column: 21, scope: !62)
!81 = !DILocation(line: 27, column: 26, scope: !62)
!82 = !DILocation(line: 27, column: 3, scope: !62)
!83 = !DILocation(line: 28, column: 3, scope: !62)
!84 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 31, type: !85, scopeLine: 31, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !87)
!85 = !DISubroutineType(types: !86)
!86 = !{!25}
!87 = !{!88, !89, !94, !96}
!88 = !DILocalVariable(name: "threads_total", scope: !84, file: !2, line: 32, type: !25)
!89 = !DILocalVariable(name: "tids", scope: !84, file: !2, line: 34, type: !90)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !92, line: 27, baseType: !93)
!92 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!93 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!94 = !DILocalVariable(name: "i", scope: !95, file: !2, line: 37, type: !25)
!95 = distinct !DILexicalBlock(scope: !84, file: !2, line: 37, column: 3)
!96 = !DILocalVariable(name: "i", scope: !97, file: !2, line: 42, type: !25)
!97 = distinct !DILexicalBlock(scope: !84, file: !2, line: 42, column: 3)
!98 = !DILocation(line: 0, scope: !84)
!99 = !DILocation(line: 34, column: 28, scope: !84)
!100 = !DILocation(line: 34, column: 42, scope: !84)
!101 = !DILocation(line: 34, column: 21, scope: !84)
!102 = !DILocation(line: 0, scope: !95)
!103 = !DILocation(line: 37, column: 3, scope: !95)
!104 = !DILocation(line: 38, column: 21, scope: !105)
!105 = distinct !DILexicalBlock(scope: !106, file: !2, line: 37, column: 43)
!106 = distinct !DILexicalBlock(scope: !95, file: !2, line: 37, column: 3)
!107 = !DILocation(line: 38, column: 5, scope: !105)
!108 = !DILocation(line: 39, column: 3, scope: !105)
!109 = !DILocation(line: 37, column: 39, scope: !106)
!110 = !DILocation(line: 37, column: 21, scope: !106)
!111 = distinct !{!111, !103, !112, !113, !114}
!112 = !DILocation(line: 39, column: 3, scope: !95)
!113 = !{!"llvm.loop.mustprogress"}
!114 = !{!"llvm.loop.unroll.disable"}
!115 = !DILocation(line: 0, scope: !97)
!116 = !DILocation(line: 42, column: 3, scope: !97)
!117 = !DILocation(line: 43, column: 18, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !2, line: 42, column: 43)
!119 = distinct !DILexicalBlock(scope: !97, file: !2, line: 42, column: 3)
!120 = !{!121, !121, i64 0}
!121 = !{!"long", !71, i64 0}
!122 = !DILocation(line: 43, column: 5, scope: !118)
!123 = !DILocation(line: 44, column: 3, scope: !118)
!124 = !DILocation(line: 42, column: 39, scope: !119)
!125 = !DILocation(line: 42, column: 21, scope: !119)
!126 = distinct !{!126, !116, !127, !113, !114}
!127 = !DILocation(line: 44, column: 3, scope: !97)
!128 = !DILocation(line: 46, column: 3, scope: !84)
!129 = !DILocation(line: 48, column: 3, scope: !84)
!130 = !DISubprogram(name: "malloc", scope: !61, file: !61, line: 672, type: !131, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!131 = !DISubroutineType(types: !132)
!132 = !{!23, !133}
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !134, line: 18, baseType: !93)
!134 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!135 = !DISubprogram(name: "pthread_create", scope: !136, file: !136, line: 202, type: !137, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!136 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!137 = !DISubroutineType(types: !138)
!138 = !{!25, !139, !140, !152, !153}
!139 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !90)
!140 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !141)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !143)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !92, line: 62, baseType: !144)
!144 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !92, line: 56, size: 448, elements: !145)
!145 = !{!146, !150}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !144, file: !92, line: 58, baseType: !147, size: 448)
!147 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !148)
!148 = !{!149}
!149 = !DISubrange(count: 56)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !144, file: !92, line: 59, baseType: !151, size: 64)
!151 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!154 = !DISubprogram(name: "pthread_join", scope: !136, file: !136, line: 219, type: !155, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DISubroutineType(types: !156)
!156 = !{!25, !91, !157}
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!158 = !DISubprogram(name: "free", scope: !61, file: !61, line: 687, type: !159, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!159 = !DISubroutineType(types: !160)
!160 = !{null, !23}
