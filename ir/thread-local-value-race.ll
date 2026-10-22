; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@.str = private unnamed_addr constant [5 x i8] c"cond\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [75 x i8] c"/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-race.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.__VERIFIER_assert = private unnamed_addr constant [28 x i8] c"void __VERIFIER_assert(int)\00", align 1, !dbg !12
@data = dso_local thread_local global i32 0, align 4, !dbg !18
@ptr = dso_local global ptr null, align 8, !dbg !25
@ptr_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !29

; Function Attrs: nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %cond) #0 !dbg !69 {
entry:
    #dbg_value(i32 %cond, !73, !DIExpression(), !74)
  %tobool = icmp ne i32 %cond, 0, !dbg !75
  br i1 %tobool, label %cond.true, label %cond.false, !dbg !75

cond.true:                                        ; preds = %entry
  br label %cond.end, !dbg !75

cond.false:                                       ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 14, ptr noundef @__PRETTY_FUNCTION__.__VERIFIER_assert) #6, !dbg !75
  unreachable, !dbg !75

0:                                                ; No predecessors!
  br label %cond.end, !dbg !75

cond.end:                                         ; preds = %0, %cond.true
  ret void, !dbg !76
}

; Function Attrs: noreturn nounwind
declare !dbg !77 void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !82 {
entry:
    #dbg_value(ptr %arg, !86, !DIExpression(), !87)
  %call = call i32 @pthread_mutex_lock(ptr noundef @ptr_mutex) #7, !dbg !88
  %0 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !89
  store ptr %0, ptr @ptr, align 8, !dbg !90, !tbaa !91
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @ptr_mutex) #7, !dbg !96
  %call2 = call i32 @pthread_mutex_lock(ptr noundef @ptr_mutex) #7, !dbg !97
  %1 = load ptr, ptr @ptr, align 8, !dbg !98, !tbaa !91
  store i32 2, ptr %1, align 4, !dbg !99, !tbaa !100
  %call3 = call i32 @pthread_mutex_unlock(ptr noundef @ptr_mutex) #7, !dbg !102
  br label %while.body, !dbg !103

while.body:                                       ; preds = %entry, %while.body
  %2 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !104
  store i32 1, ptr %2, align 4, !dbg !106, !tbaa !100
  br label %while.body, !dbg !103, !llvm.loop !107
}

; Function Attrs: nounwind
declare !dbg !110 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #3

; Function Attrs: nounwind
declare !dbg !115 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !116 {
entry:
    #dbg_value(i32 4, !120, !DIExpression(), !129)
  %conv = sext i32 4 to i64, !dbg !130
  %mul = mul i64 %conv, 8, !dbg !131
  %call = call noalias ptr @malloc(i64 noundef %mul) #8, !dbg !132
    #dbg_value(ptr %call, !121, !DIExpression(), !129)
    #dbg_value(i32 0, !125, !DIExpression(), !133)
  br label %for.body, !dbg !134

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !125, !DIExpression(), !133)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !135
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #7, !dbg !138
  br label %for.inc, !dbg !139

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !140
    #dbg_value(i64 %indvars.iv.next, !125, !DIExpression(), !133)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !141
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !134, !llvm.loop !142

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !127, !DIExpression(), !145)
  br label %for.body8, !dbg !146

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !127, !DIExpression(), !145)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !147
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !147, !tbaa !150
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !152
  br label %for.inc12, !dbg !153

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !154
    #dbg_value(i64 %indvars.iv.next13, !127, !DIExpression(), !145)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !155
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !146, !llvm.loop !156

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #7, !dbg !158
  ret i32 0, !dbg !159
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !160 noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind
declare !dbg !166 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !183 i32 @pthread_join(i64 noundef, ptr noundef) #5

; Function Attrs: nounwind
declare !dbg !187 void @free(ptr noundef) #2

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
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "thread-local-value-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "63675042f7952e08a29d63645b64508f")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 5)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 600, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 75)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 224, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 28)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "data", scope: !20, file: !2, line: 17, type: !28, isLocal: false, isDefinition: true)
!20 = distinct !DICompileUnit(language: DW_LANG_C11, file: !21, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !24, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "63675042f7952e08a29d63645b64508f")
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!24 = !{!0, !7, !12, !18, !25, !29}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "ptr", scope: !20, file: !2, line: 19, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "ptr_mutex", scope: !20, file: !2, line: 20, type: !31, isLocal: false, isDefinition: true)
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
!69 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !2, file: !2, line: 13, type: !70, scopeLine: 13, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{null, !28}
!72 = !{!73}
!73 = !DILocalVariable(name: "cond", arg: 1, scope: !69, file: !2, line: 13, type: !28)
!74 = !DILocation(line: 0, scope: !69)
!75 = !DILocation(line: 14, column: 3, scope: !69)
!76 = !DILocation(line: 15, column: 1, scope: !69)
!77 = !DISubprogram(name: "__assert_fail", scope: !78, file: !78, line: 69, type: !79, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!78 = !DIFile(filename: "/usr/include/assert.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ad96665f12660b113f72d10e62e1dd")
!79 = !DISubroutineType(types: !80)
!80 = !{null, !81, !81, !41, !81}
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!82 = distinct !DISubprogram(name: "thread", scope: !2, file: !2, line: 22, type: !83, scopeLine: 22, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !85)
!83 = !DISubroutineType(types: !84)
!84 = !{!23, !23}
!85 = !{!86}
!86 = !DILocalVariable(name: "arg", arg: 1, scope: !82, file: !2, line: 22, type: !23)
!87 = !DILocation(line: 0, scope: !82)
!88 = !DILocation(line: 23, column: 3, scope: !82)
!89 = !DILocation(line: 24, column: 10, scope: !82)
!90 = !DILocation(line: 24, column: 7, scope: !82)
!91 = !{!92, !92, i64 0}
!92 = !{!"p1 int", !93, i64 0}
!93 = !{!"any pointer", !94, i64 0}
!94 = !{!"omnipotent char", !95, i64 0}
!95 = !{!"Simple C/C++ TBAA"}
!96 = !DILocation(line: 25, column: 3, scope: !82)
!97 = !DILocation(line: 27, column: 3, scope: !82)
!98 = !DILocation(line: 28, column: 4, scope: !82)
!99 = !DILocation(line: 28, column: 8, scope: !82)
!100 = !{!101, !101, i64 0}
!101 = !{!"int", !94, i64 0}
!102 = !DILocation(line: 29, column: 3, scope: !82)
!103 = !DILocation(line: 32, column: 3, scope: !82)
!104 = !DILocation(line: 33, column: 5, scope: !105)
!105 = distinct !DILexicalBlock(scope: !82, file: !2, line: 32, column: 13)
!106 = !DILocation(line: 33, column: 10, scope: !105)
!107 = distinct !{!107, !103, !108, !109}
!108 = !DILocation(line: 34, column: 3, scope: !82)
!109 = !{!"llvm.loop.unroll.disable"}
!110 = !DISubprogram(name: "pthread_mutex_lock", scope: !111, file: !111, line: 794, type: !112, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!112 = !DISubroutineType(types: !113)
!113 = !{!28, !114}
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!115 = !DISubprogram(name: "pthread_mutex_unlock", scope: !111, file: !111, line: 835, type: !112, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!116 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 38, type: !117, scopeLine: 38, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !119)
!117 = !DISubroutineType(types: !118)
!118 = !{!28}
!119 = !{!120, !121, !125, !127}
!120 = !DILocalVariable(name: "threads_total", scope: !116, file: !2, line: 39, type: !28)
!121 = !DILocalVariable(name: "tids", scope: !116, file: !2, line: 41, type: !122)
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !123, size: 64)
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !32, line: 27, baseType: !124)
!124 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!125 = !DILocalVariable(name: "i", scope: !126, file: !2, line: 44, type: !28)
!126 = distinct !DILexicalBlock(scope: !116, file: !2, line: 44, column: 3)
!127 = !DILocalVariable(name: "i", scope: !128, file: !2, line: 49, type: !28)
!128 = distinct !DILexicalBlock(scope: !116, file: !2, line: 49, column: 3)
!129 = !DILocation(line: 0, scope: !116)
!130 = !DILocation(line: 41, column: 28, scope: !116)
!131 = !DILocation(line: 41, column: 42, scope: !116)
!132 = !DILocation(line: 41, column: 21, scope: !116)
!133 = !DILocation(line: 0, scope: !126)
!134 = !DILocation(line: 44, column: 3, scope: !126)
!135 = !DILocation(line: 45, column: 21, scope: !136)
!136 = distinct !DILexicalBlock(scope: !137, file: !2, line: 44, column: 43)
!137 = distinct !DILexicalBlock(scope: !126, file: !2, line: 44, column: 3)
!138 = !DILocation(line: 45, column: 5, scope: !136)
!139 = !DILocation(line: 46, column: 3, scope: !136)
!140 = !DILocation(line: 44, column: 39, scope: !137)
!141 = !DILocation(line: 44, column: 21, scope: !137)
!142 = distinct !{!142, !134, !143, !144, !109}
!143 = !DILocation(line: 46, column: 3, scope: !126)
!144 = !{!"llvm.loop.mustprogress"}
!145 = !DILocation(line: 0, scope: !128)
!146 = !DILocation(line: 49, column: 3, scope: !128)
!147 = !DILocation(line: 50, column: 18, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !2, line: 49, column: 43)
!149 = distinct !DILexicalBlock(scope: !128, file: !2, line: 49, column: 3)
!150 = !{!151, !151, i64 0}
!151 = !{!"long", !94, i64 0}
!152 = !DILocation(line: 50, column: 5, scope: !148)
!153 = !DILocation(line: 51, column: 3, scope: !148)
!154 = !DILocation(line: 49, column: 39, scope: !149)
!155 = !DILocation(line: 49, column: 21, scope: !149)
!156 = distinct !{!156, !146, !157, !144, !109}
!157 = !DILocation(line: 51, column: 3, scope: !128)
!158 = !DILocation(line: 53, column: 3, scope: !116)
!159 = !DILocation(line: 55, column: 3, scope: !116)
!160 = !DISubprogram(name: "malloc", scope: !161, file: !161, line: 672, type: !162, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!161 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!162 = !DISubroutineType(types: !163)
!163 = !{!23, !164}
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !165, line: 18, baseType: !124)
!165 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!166 = !DISubprogram(name: "pthread_create", scope: !111, file: !111, line: 202, type: !167, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!167 = !DISubroutineType(types: !168)
!168 = !{!28, !169, !170, !181, !182}
!169 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !122)
!170 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !171)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !173)
!173 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !32, line: 62, baseType: !174)
!174 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !32, line: 56, size: 448, elements: !175)
!175 = !{!176, !180}
!176 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !174, file: !32, line: 58, baseType: !177, size: 448)
!177 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !178)
!178 = !{!179}
!179 = !DISubrange(count: 56)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !174, file: !32, line: 59, baseType: !61, size: 64)
!181 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!182 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !23)
!183 = !DISubprogram(name: "pthread_join", scope: !111, file: !111, line: 219, type: !184, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!184 = !DISubroutineType(types: !185)
!185 = !{!28, !123, !186}
!186 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!187 = !DISubprogram(name: "free", scope: !161, file: !161, line: 687, type: !188, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!188 = !DISubroutineType(types: !189)
!189 = !{null, !23}
