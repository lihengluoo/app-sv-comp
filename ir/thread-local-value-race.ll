; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [75 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-race.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1, !dbg !12
@data = dso_local thread_local global i32 0, align 4, !dbg !18
@ptr = dso_local global ptr null, align 8, !dbg !25
@ptr_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !29

; Function Attrs: nounwind uwtable
define dso_local void @reach_error() #0 !dbg !69 {
entry:
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.reach_error) #6, !dbg !72
  unreachable, !dbg !72
}

; Function Attrs: noreturn nounwind
declare !dbg !73 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !78 {
entry:
    #dbg_value(i32 %cond, !82, !DIExpression(), !86)
  %tobool = icmp ne i32 %cond, 0, !dbg !87
  br i1 %tobool, label %if.end, label %if.then, !dbg !88

if.then:                                          ; preds = %entry
  br label %ERROR, !dbg !89

ERROR:                                            ; preds = %if.then
    #dbg_label(!83, !90)
  call void @reach_error(), !dbg !91
  call void @abort() #6, !dbg !93
  unreachable, !dbg !93

if.end:                                           ; preds = %entry
  ret void, !dbg !94
}

; Function Attrs: noreturn nounwind
declare !dbg !95 void @abort() #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !97 {
entry:
    #dbg_value(ptr %arg, !101, !DIExpression(), !102)
  %call = call i32 @pthread_mutex_lock(ptr noundef @ptr_mutex) #7, !dbg !103
  %0 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !104
  store ptr %0, ptr @ptr, align 8, !dbg !105, !tbaa !106
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @ptr_mutex) #7, !dbg !111
  %call2 = call i32 @pthread_mutex_lock(ptr noundef @ptr_mutex) #7, !dbg !112
  %1 = load ptr, ptr @ptr, align 8, !dbg !113, !tbaa !106
  store i32 2, ptr %1, align 4, !dbg !114, !tbaa !115
  %call3 = call i32 @pthread_mutex_unlock(ptr noundef @ptr_mutex) #7, !dbg !117
  br label %while.body, !dbg !118

while.body:                                       ; preds = %entry, %while.body
  %2 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !119
  store i32 1, ptr %2, align 4, !dbg !121, !tbaa !115
  br label %while.body, !dbg !118, !llvm.loop !122
}

; Function Attrs: nounwind
declare !dbg !125 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #3

; Function Attrs: nounwind
declare !dbg !130 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !131 {
entry:
    #dbg_value(i32 4, !135, !DIExpression(), !144)
  %conv = sext i32 4 to i64, !dbg !145
  %mul = mul i64 %conv, 8, !dbg !146
  %call = call noalias ptr @malloc(i64 noundef %mul) #8, !dbg !147
    #dbg_value(ptr %call, !136, !DIExpression(), !144)
    #dbg_value(i32 0, !140, !DIExpression(), !148)
  br label %for.body, !dbg !149

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !140, !DIExpression(), !148)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !150
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #7, !dbg !153
  br label %for.inc, !dbg !154

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !155
    #dbg_value(i64 %indvars.iv.next, !140, !DIExpression(), !148)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !156
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !149, !llvm.loop !157

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !142, !DIExpression(), !160)
  br label %for.body8, !dbg !161

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !142, !DIExpression(), !160)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !162
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !162, !tbaa !165
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !167
  br label %for.inc12, !dbg !168

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !169
    #dbg_value(i64 %indvars.iv.next13, !142, !DIExpression(), !160)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !170
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !161, !llvm.loop !171

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #7, !dbg !173
  ret i32 0, !dbg !174
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !175 noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind
declare !dbg !180 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !197 i32 @pthread_join(i64 noundef, ptr noundef) #5

; Function Attrs: nounwind
declare !dbg !201 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!20}
!llvm.ident = !{!62}
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-value-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "c2b163357a41e844a309f599913bc57b")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 16, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 2)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 600, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 75)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 13, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 152, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 19)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "data", scope: !20, file: !2, line: 21, type: !28, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "c2b163357a41e844a309f599913bc57b")
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!24 = !{!0, !7, !12, !18, !25, !29}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "ptr", scope: !20, file: !2, line: 23, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "ptr_mutex", scope: !20, file: !2, line: 24, type: !31, isLocal: false, isDefinition: true)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !32, line: 72, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!33 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !32, line: 67, size: 320, elements: !34)
!34 = !{!35, !56, !60}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !33, file: !32, line: 69, baseType: !36, size: 320)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !37, line: 22, size: 320, elements: !38)
!37 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!38 = !{!39, !40, !42, !43, !44, !45, !47, !48}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !36, file: !37, line: 24, baseType: !28, size: 32)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !36, file: !37, line: 25, baseType: !41, size: 32, offset: 32)
!41 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !36, file: !37, line: 26, baseType: !28, size: 32, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !36, file: !37, line: 28, baseType: !41, size: 32, offset: 96)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !36, file: !37, line: 32, baseType: !28, size: 32, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !36, file: !37, line: 34, baseType: !46, size: 16, offset: 160)
!46 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !36, file: !37, line: 35, baseType: !46, size: 16, offset: 176)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !36, file: !37, line: 36, baseType: !49, size: 128, offset: 192)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !50, line: 55, baseType: !51)
!50 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !50, line: 51, size: 128, elements: !52)
!52 = !{!53, !55}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !51, file: !50, line: 53, baseType: !54, size: 64)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !51, file: !50, line: 54, baseType: !54, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !33, file: !32, line: 70, baseType: !57, size: 320)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 320, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 40)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !33, file: !32, line: 71, baseType: !61, size: 64)
!61 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!62 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 8, !"PIC Level", i32 2}
!67 = !{i32 7, !"PIE Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 2}
!69 = distinct !DISubprogram(name: "reach_error", scope: !2, file: !2, line: 13, type: !70, scopeLine: 13, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20)
!70 = !DISubroutineType(types: !71)
!71 = !{null}
!72 = !DILocation(line: 13, column: 22, scope: !69)
!73 = !DISubprogram(name: "__assert_fail", scope: !74, file: !74, line: 69, type: !75, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!74 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!75 = !DISubroutineType(types: !76)
!76 = !{null, !77, !77, !41, !77}
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!78 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 14, type: !79, scopeLine: 14, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !81)
!79 = !DISubroutineType(types: !80)
!80 = !{null, !28}
!81 = !{!82, !83}
!82 = !DILocalVariable(name: "cond", arg: 1, scope: !78, file: !2, line: 14, type: !28)
!83 = !DILabel(scope: !84, name: "ERROR", file: !2, line: 16, column: 5)
!84 = distinct !DILexicalBlock(scope: !85, file: !2, line: 15, column: 16)
!85 = distinct !DILexicalBlock(scope: !78, file: !2, line: 15, column: 7)
!86 = !DILocation(line: 0, scope: !78)
!87 = !DILocation(line: 15, column: 8, scope: !85)
!88 = !DILocation(line: 15, column: 7, scope: !85)
!89 = !DILocation(line: 15, column: 16, scope: !85)
!90 = !DILocation(line: 16, column: 5, scope: !84)
!91 = !DILocation(line: 16, column: 13, scope: !92)
!92 = distinct !DILexicalBlock(scope: !84, file: !2, line: 16, column: 12)
!93 = !DILocation(line: 16, column: 27, scope: !92)
!94 = !DILocation(line: 18, column: 3, scope: !78)
!95 = !DISubprogram(name: "abort", scope: !96, file: !96, line: 730, type: !70, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!96 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!97 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 26, type: !98, scopeLine: 26, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !100)
!98 = !DISubroutineType(types: !99)
!99 = !{!23, !23}
!100 = !{!101}
!101 = !DILocalVariable(name: "arg", arg: 1, scope: !97, file: !2, line: 26, type: !23)
!102 = !DILocation(line: 0, scope: !97)
!103 = !DILocation(line: 27, column: 3, scope: !97)
!104 = !DILocation(line: 28, column: 10, scope: !97)
!105 = !DILocation(line: 28, column: 7, scope: !97)
!106 = !{!107, !107, i64 0}
!107 = !{!"p1 int", !108, i64 0}
!108 = !{!"any pointer", !109, i64 0}
!109 = !{!"omnipotent char", !110, i64 0}
!110 = !{!"Simple C/C++ TBAA"}
!111 = !DILocation(line: 29, column: 3, scope: !97)
!112 = !DILocation(line: 31, column: 3, scope: !97)
!113 = !DILocation(line: 32, column: 4, scope: !97)
!114 = !DILocation(line: 32, column: 8, scope: !97)
!115 = !{!116, !116, i64 0}
!116 = !{!"int", !109, i64 0}
!117 = !DILocation(line: 33, column: 3, scope: !97)
!118 = !DILocation(line: 36, column: 3, scope: !97)
!119 = !DILocation(line: 37, column: 5, scope: !120)
!120 = distinct !DILexicalBlock(scope: !97, file: !2, line: 36, column: 13)
!121 = !DILocation(line: 37, column: 10, scope: !120)
!122 = distinct !{!122, !118, !123, !124}
!123 = !DILocation(line: 38, column: 3, scope: !97)
!124 = !{!"llvm.loop.unroll.disable"}
!125 = !DISubprogram(name: "pthread_mutex_lock", scope: !126, file: !126, line: 794, type: !127, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!126 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!127 = !DISubroutineType(types: !128)
!128 = !{!28, !129}
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!130 = !DISubprogram(name: "pthread_mutex_unlock", scope: !126, file: !126, line: 835, type: !127, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!131 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 42, type: !132, scopeLine: 42, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !134)
!132 = !DISubroutineType(types: !133)
!133 = !{!28}
!134 = !{!135, !136, !140, !142}
!135 = !DILocalVariable(name: "threads_total", scope: !131, file: !2, line: 43, type: !28)
!136 = !DILocalVariable(name: "tids", scope: !131, file: !2, line: 45, type: !137)
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !138, size: 64)
!138 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !32, line: 27, baseType: !139)
!139 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!140 = !DILocalVariable(name: "i", scope: !141, file: !2, line: 48, type: !28)
!141 = distinct !DILexicalBlock(scope: !131, file: !2, line: 48, column: 3)
!142 = !DILocalVariable(name: "i", scope: !143, file: !2, line: 53, type: !28)
!143 = distinct !DILexicalBlock(scope: !131, file: !2, line: 53, column: 3)
!144 = !DILocation(line: 0, scope: !131)
!145 = !DILocation(line: 45, column: 28, scope: !131)
!146 = !DILocation(line: 45, column: 42, scope: !131)
!147 = !DILocation(line: 45, column: 21, scope: !131)
!148 = !DILocation(line: 0, scope: !141)
!149 = !DILocation(line: 48, column: 3, scope: !141)
!150 = !DILocation(line: 49, column: 21, scope: !151)
!151 = distinct !DILexicalBlock(scope: !152, file: !2, line: 48, column: 43)
!152 = distinct !DILexicalBlock(scope: !141, file: !2, line: 48, column: 3)
!153 = !DILocation(line: 49, column: 5, scope: !151)
!154 = !DILocation(line: 50, column: 3, scope: !151)
!155 = !DILocation(line: 48, column: 39, scope: !152)
!156 = !DILocation(line: 48, column: 21, scope: !152)
!157 = distinct !{!157, !149, !158, !159, !124}
!158 = !DILocation(line: 50, column: 3, scope: !141)
!159 = !{!"llvm.loop.mustprogress"}
!160 = !DILocation(line: 0, scope: !143)
!161 = !DILocation(line: 53, column: 3, scope: !143)
!162 = !DILocation(line: 54, column: 18, scope: !163)
!163 = distinct !DILexicalBlock(scope: !164, file: !2, line: 53, column: 43)
!164 = distinct !DILexicalBlock(scope: !143, file: !2, line: 53, column: 3)
!165 = !{!166, !166, i64 0}
!166 = !{!"long", !109, i64 0}
!167 = !DILocation(line: 54, column: 5, scope: !163)
!168 = !DILocation(line: 55, column: 3, scope: !163)
!169 = !DILocation(line: 53, column: 39, scope: !164)
!170 = !DILocation(line: 53, column: 21, scope: !164)
!171 = distinct !{!171, !161, !172, !159, !124}
!172 = !DILocation(line: 55, column: 3, scope: !143)
!173 = !DILocation(line: 57, column: 3, scope: !131)
!174 = !DILocation(line: 59, column: 3, scope: !131)
!175 = !DISubprogram(name: "malloc", scope: !96, file: !96, line: 672, type: !176, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!176 = !DISubroutineType(types: !177)
!177 = !{!23, !178}
!178 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !179, line: 18, baseType: !139)
!179 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!180 = !DISubprogram(name: "pthread_create", scope: !126, file: !126, line: 202, type: !181, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!181 = !DISubroutineType(types: !182)
!182 = !{!28, !183, !184, !195, !196}
!183 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !137)
!184 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !185)
!185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !186, size: 64)
!186 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !187)
!187 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !32, line: 62, baseType: !188)
!188 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !32, line: 56, size: 448, elements: !189)
!189 = !{!190, !194}
!190 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !188, file: !32, line: 58, baseType: !191, size: 448)
!191 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !192)
!192 = !{!193}
!193 = !DISubrange(count: 56)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !188, file: !32, line: 59, baseType: !61, size: 64)
!195 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!197 = !DISubprogram(name: "pthread_join", scope: !126, file: !126, line: 219, type: !198, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!198 = !DISubroutineType(types: !199)
!199 = !{!28, !138, !200}
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!201 = !DISubprogram(name: "free", scope: !96, file: !96, line: 687, type: !202, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!202 = !DISubroutineType(types: !203)
!203 = !{null, !23}
