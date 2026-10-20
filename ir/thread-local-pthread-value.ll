; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-pthread-value.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-pthread-value.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1, !dbg !12
@key = dso_local global i32 0, align 4, !dbg !18

; Function Attrs: nounwind uwtable
define dso_local void @reach_error() #0 !dbg !35 {
entry:
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.reach_error) #6, !dbg !38
  unreachable, !dbg !38
}

; Function Attrs: noreturn nounwind
declare !dbg !39 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !44 {
entry:
    #dbg_value(i32 %cond, !49, !DIExpression(), !53)
  %tobool = icmp ne i32 %cond, 0, !dbg !54
  br i1 %tobool, label %if.end, label %if.then, !dbg !55

if.then:                                          ; preds = %entry
  br label %ERROR, !dbg !56

ERROR:                                            ; preds = %if.then
    #dbg_label(!50, !57)
  call void @reach_error(), !dbg !58
  call void @abort() #6, !dbg !60
  unreachable, !dbg !60

if.end:                                           ; preds = %entry
  ret void, !dbg !61
}

; Function Attrs: noreturn nounwind
declare !dbg !62 void @abort() #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !64 {
entry:
  %x = alloca i32, align 4
  %y = alloca i32, align 4
    #dbg_value(ptr %arg, !68, !DIExpression(), !71)
  call void @llvm.lifetime.start.p0(i64 4, ptr %x) #7, !dbg !72
    #dbg_declare(ptr %x, !69, !DIExpression(), !73)
  call void @llvm.lifetime.start.p0(i64 4, ptr %y) #7, !dbg !72
    #dbg_declare(ptr %y, !70, !DIExpression(), !74)
  %0 = load i32, ptr @key, align 4, !dbg !75, !tbaa !76
  %call = call i32 @pthread_setspecific(i32 noundef %0, ptr noundef %x) #7, !dbg !80
  %1 = load i32, ptr @key, align 4, !dbg !81, !tbaa !76
  %call1 = call ptr @pthread_getspecific(i32 noundef %1) #7, !dbg !82
  %cmp = icmp eq ptr %call1, %x, !dbg !83
  %conv = zext i1 %cmp to i32, !dbg !83
  call void @__VERIFIER_assert(i32 noundef %conv), !dbg !84
  %2 = load i32, ptr @key, align 4, !dbg !85, !tbaa !76
  %call2 = call i32 @pthread_setspecific(i32 noundef %2, ptr noundef %y) #7, !dbg !86
  %3 = load i32, ptr @key, align 4, !dbg !87, !tbaa !76
  %call3 = call ptr @pthread_getspecific(i32 noundef %3) #7, !dbg !88
  %cmp4 = icmp eq ptr %call3, %y, !dbg !89
  %conv5 = zext i1 %cmp4 to i32, !dbg !89
  call void @__VERIFIER_assert(i32 noundef %conv5), !dbg !90
  %4 = load i32, ptr @key, align 4, !dbg !91, !tbaa !76
  %call6 = call ptr @pthread_getspecific(i32 noundef %4) #7, !dbg !92
  %cmp7 = icmp ne ptr %call6, %x, !dbg !93
  %conv8 = zext i1 %cmp7 to i32, !dbg !93
  call void @__VERIFIER_assert(i32 noundef %conv8), !dbg !94
  call void @llvm.lifetime.end.p0(i64 4, ptr %y) #7, !dbg !95
  call void @llvm.lifetime.end.p0(i64 4, ptr %x) #7, !dbg !95
  ret ptr null, !dbg !96
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !97 i32 @pthread_setspecific(i32 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !103 ptr @pthread_getspecific(i32 noundef) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !106 {
entry:
  %call = call i32 @pthread_key_create(ptr noundef @key, ptr noundef null) #7, !dbg !119
    #dbg_value(i32 4, !110, !DIExpression(), !120)
  %conv = sext i32 4 to i64, !dbg !121
  %mul = mul i64 %conv, 8, !dbg !122
  %call1 = call noalias ptr @malloc(i64 noundef %mul) #8, !dbg !123
    #dbg_value(ptr %call1, !111, !DIExpression(), !120)
    #dbg_value(i32 0, !115, !DIExpression(), !124)
  br label %for.body, !dbg !125

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !115, !DIExpression(), !124)
  %arrayidx = getelementptr inbounds i64, ptr %call1, i64 %indvars.iv, !dbg !126
  %call3 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #7, !dbg !129
  br label %for.inc, !dbg !130

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !131
    #dbg_value(i64 %indvars.iv.next, !115, !DIExpression(), !124)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !132
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !125, !llvm.loop !133

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !117, !DIExpression(), !137)
  br label %for.body9, !dbg !138

for.cond.cleanup8:                                ; preds = %for.inc13
  br label %for.end15

for.body9:                                        ; preds = %for.end, %for.inc13
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc13 ]
    #dbg_value(i64 %indvars.iv12, !117, !DIExpression(), !137)
  %arrayidx11 = getelementptr inbounds i64, ptr %call1, i64 %indvars.iv12, !dbg !139
  %0 = load i64, ptr %arrayidx11, align 8, !dbg !139, !tbaa !142
  %call12 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !144
  br label %for.inc13, !dbg !145

for.inc13:                                        ; preds = %for.body9
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !146
    #dbg_value(i64 %indvars.iv.next13, !117, !DIExpression(), !137)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !147
  br i1 %exitcond15, label %for.body9, label %for.cond.cleanup8, !dbg !138, !llvm.loop !148

for.end15:                                        ; preds = %for.cond.cleanup8
  call void @free(ptr noundef %call1) #7, !dbg !150
  ret i32 0, !dbg !151
}

; Function Attrs: nounwind
declare !dbg !152 i32 @pthread_key_create(ptr noundef, ptr noundef) #3

; Function Attrs: nounwind allocsize(0)
declare !dbg !159 noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind
declare !dbg !164 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare !dbg !182 i32 @pthread_join(i64 noundef, ptr noundef) #5

; Function Attrs: nounwind
declare !dbg !186 void @free(ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!20}
!llvm.ident = !{!28}
!llvm.module.flags = !{!29, !30, !31, !32, !33, !34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-pthread-value.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "5531a3a8ed2a300b2f8f9fc377f93070")
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
!19 = distinct !DIGlobalVariable(name: "key", scope: !20, file: !2, line: 21, type: !25, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-pthread-value.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "5531a3a8ed2a300b2f8f9fc377f93070")
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!24 = !{!0, !7, !12, !18}
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !26, line: 49, baseType: !27)
!26 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!27 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!28 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!29 = !{i32 7, !"Dwarf Version", i32 5}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{i32 1, !"wchar_size", i32 4}
!32 = !{i32 8, !"PIC Level", i32 2}
!33 = !{i32 7, !"PIE Level", i32 2}
!34 = !{i32 7, !"uwtable", i32 2}
!35 = distinct !DISubprogram(name: "reach_error", scope: !2, file: !2, line: 13, type: !36, scopeLine: 13, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!36 = !DISubroutineType(types: !37)
!37 = !{null}
!38 = !DILocation(line: 13, column: 22, scope: !35)
!39 = !DISubprogram(name: "__assert_fail", scope: !40, file: !40, line: 69, type: !41, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!40 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!41 = !DISubroutineType(types: !42)
!42 = !{null, !43, !43, !27, !43}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!44 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 14, type: !45, scopeLine: 14, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !48)
!45 = !DISubroutineType(types: !46)
!46 = !{null, !47}
!47 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!48 = !{!49, !50}
!49 = !DILocalVariable(name: "cond", arg: 1, scope: !44, file: !2, line: 14, type: !47)
!50 = !DILabel(scope: !51, name: "ERROR", file: !2, line: 16, column: 5)
!51 = distinct !DILexicalBlock(scope: !52, file: !2, line: 15, column: 16)
!52 = distinct !DILexicalBlock(scope: !44, file: !2, line: 15, column: 7)
!53 = !DILocation(line: 0, scope: !44)
!54 = !DILocation(line: 15, column: 8, scope: !52)
!55 = !DILocation(line: 15, column: 7, scope: !52)
!56 = !DILocation(line: 15, column: 16, scope: !52)
!57 = !DILocation(line: 16, column: 5, scope: !51)
!58 = !DILocation(line: 16, column: 13, scope: !59)
!59 = distinct !DILexicalBlock(scope: !51, file: !2, line: 16, column: 12)
!60 = !DILocation(line: 16, column: 27, scope: !59)
!61 = !DILocation(line: 18, column: 3, scope: !44)
!62 = !DISubprogram(name: "abort", scope: !63, file: !63, line: 730, type: !36, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!63 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!64 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 23, type: !65, scopeLine: 23, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{!23, !23}
!67 = !{!68, !69, !70}
!68 = !DILocalVariable(name: "arg", arg: 1, scope: !64, file: !2, line: 23, type: !23)
!69 = !DILocalVariable(name: "x", scope: !64, file: !2, line: 24, type: !47)
!70 = !DILocalVariable(name: "y", scope: !64, file: !2, line: 24, type: !47)
!71 = !DILocation(line: 0, scope: !64)
!72 = !DILocation(line: 24, column: 3, scope: !64)
!73 = !DILocation(line: 24, column: 7, scope: !64)
!74 = !DILocation(line: 24, column: 10, scope: !64)
!75 = !DILocation(line: 25, column: 23, scope: !64)
!76 = !{!77, !77, i64 0}
!77 = !{!"int", !78, i64 0}
!78 = !{!"omnipotent char", !79, i64 0}
!79 = !{!"Simple C/C++ TBAA"}
!80 = !DILocation(line: 25, column: 3, scope: !64)
!81 = !DILocation(line: 26, column: 41, scope: !64)
!82 = !DILocation(line: 26, column: 21, scope: !64)
!83 = !DILocation(line: 26, column: 46, scope: !64)
!84 = !DILocation(line: 26, column: 3, scope: !64)
!85 = !DILocation(line: 27, column: 23, scope: !64)
!86 = !DILocation(line: 27, column: 3, scope: !64)
!87 = !DILocation(line: 28, column: 41, scope: !64)
!88 = !DILocation(line: 28, column: 21, scope: !64)
!89 = !DILocation(line: 28, column: 46, scope: !64)
!90 = !DILocation(line: 28, column: 3, scope: !64)
!91 = !DILocation(line: 29, column: 41, scope: !64)
!92 = !DILocation(line: 29, column: 21, scope: !64)
!93 = !DILocation(line: 29, column: 46, scope: !64)
!94 = !DILocation(line: 29, column: 3, scope: !64)
!95 = !DILocation(line: 31, column: 1, scope: !64)
!96 = !DILocation(line: 30, column: 3, scope: !64)
!97 = !DISubprogram(name: "pthread_setspecific", scope: !98, file: !98, line: 1308, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!98 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!99 = !DISubroutineType(types: !100)
!100 = !{!47, !25, !101}
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!103 = !DISubprogram(name: "pthread_getspecific", scope: !98, file: !98, line: 1305, type: !104, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!104 = !DISubroutineType(types: !105)
!105 = !{!23, !25}
!106 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 33, type: !107, scopeLine: 33, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !109)
!107 = !DISubroutineType(types: !108)
!108 = !{!47}
!109 = !{!110, !111, !115, !117}
!110 = !DILocalVariable(name: "threads_total", scope: !106, file: !2, line: 36, type: !47)
!111 = !DILocalVariable(name: "tids", scope: !106, file: !2, line: 38, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !26, line: 27, baseType: !114)
!114 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!115 = !DILocalVariable(name: "i", scope: !116, file: !2, line: 41, type: !47)
!116 = distinct !DILexicalBlock(scope: !106, file: !2, line: 41, column: 3)
!117 = !DILocalVariable(name: "i", scope: !118, file: !2, line: 46, type: !47)
!118 = distinct !DILexicalBlock(scope: !106, file: !2, line: 46, column: 3)
!119 = !DILocation(line: 34, column: 3, scope: !106)
!120 = !DILocation(line: 0, scope: !106)
!121 = !DILocation(line: 38, column: 28, scope: !106)
!122 = !DILocation(line: 38, column: 42, scope: !106)
!123 = !DILocation(line: 38, column: 21, scope: !106)
!124 = !DILocation(line: 0, scope: !116)
!125 = !DILocation(line: 41, column: 3, scope: !116)
!126 = !DILocation(line: 42, column: 21, scope: !127)
!127 = distinct !DILexicalBlock(scope: !128, file: !2, line: 41, column: 43)
!128 = distinct !DILexicalBlock(scope: !116, file: !2, line: 41, column: 3)
!129 = !DILocation(line: 42, column: 5, scope: !127)
!130 = !DILocation(line: 43, column: 3, scope: !127)
!131 = !DILocation(line: 41, column: 39, scope: !128)
!132 = !DILocation(line: 41, column: 21, scope: !128)
!133 = distinct !{!133, !125, !134, !135, !136}
!134 = !DILocation(line: 43, column: 3, scope: !116)
!135 = !{!"llvm.loop.mustprogress"}
!136 = !{!"llvm.loop.unroll.disable"}
!137 = !DILocation(line: 0, scope: !118)
!138 = !DILocation(line: 46, column: 3, scope: !118)
!139 = !DILocation(line: 47, column: 18, scope: !140)
!140 = distinct !DILexicalBlock(scope: !141, file: !2, line: 46, column: 43)
!141 = distinct !DILexicalBlock(scope: !118, file: !2, line: 46, column: 3)
!142 = !{!143, !143, i64 0}
!143 = !{!"long", !78, i64 0}
!144 = !DILocation(line: 47, column: 5, scope: !140)
!145 = !DILocation(line: 48, column: 3, scope: !140)
!146 = !DILocation(line: 46, column: 39, scope: !141)
!147 = !DILocation(line: 46, column: 21, scope: !141)
!148 = distinct !{!148, !138, !149, !135, !136}
!149 = !DILocation(line: 48, column: 3, scope: !118)
!150 = !DILocation(line: 50, column: 3, scope: !106)
!151 = !DILocation(line: 52, column: 3, scope: !106)
!152 = !DISubprogram(name: "pthread_key_create", scope: !98, file: !98, line: 1297, type: !153, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DISubroutineType(types: !154)
!154 = !{!47, !155, !156}
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!156 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!157 = !DISubroutineType(types: !158)
!158 = !{null, !23}
!159 = !DISubprogram(name: "malloc", scope: !63, file: !63, line: 672, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!160 = !DISubroutineType(types: !161)
!161 = !{!23, !162}
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !163, line: 18, baseType: !114)
!163 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!164 = !DISubprogram(name: "pthread_create", scope: !98, file: !98, line: 202, type: !165, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!165 = !DISubroutineType(types: !166)
!166 = !{!47, !167, !168, !180, !181}
!167 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !112)
!168 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !169)
!169 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !170, size: 64)
!170 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !171)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !26, line: 62, baseType: !172)
!172 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !26, line: 56, size: 448, elements: !173)
!173 = !{!174, !178}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !172, file: !26, line: 58, baseType: !175, size: 448)
!175 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !176)
!176 = !{!177}
!177 = !DISubrange(count: 56)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !172, file: !26, line: 59, baseType: !179, size: 64)
!179 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!181 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!182 = !DISubprogram(name: "pthread_join", scope: !98, file: !98, line: 219, type: !183, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!183 = !DISubroutineType(types: !184)
!184 = !{!47, !113, !185}
!185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!186 = !DISubprogram(name: "free", scope: !63, file: !63, line: 687, type: !157, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
