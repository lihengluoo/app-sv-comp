; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/semaphore-posix-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.sem_t = type { i64, [24 x i8] }

@data = dso_local global i32 0, align 4, !dbg !0
@data_sem = dso_local global %union.sem_t zeroinitializer, align 8, !dbg !7

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !29 {
entry:
    #dbg_value(ptr %arg, !33, !DIExpression(), !34)
  %call = call i32 @sem_wait(ptr noundef @data_sem), !dbg !35
  store i32 4, ptr @data, align 4, !dbg !36, !tbaa !37
  %call1 = call i32 @sem_post(ptr noundef @data_sem) #4, !dbg !41
  ret ptr null, !dbg !42
}

declare !dbg !43 i32 @sem_wait(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !48 i32 @sem_post(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !49 {
entry:
  %call = call i32 @sem_init(ptr noundef @data_sem, i32 noundef 0, i32 noundef 1) #4, !dbg !63
    #dbg_value(i32 4, !53, !DIExpression(), !64)
  %conv = sext i32 4 to i64, !dbg !65
  %mul = mul i64 %conv, 8, !dbg !66
  %call1 = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !67
    #dbg_value(ptr %call1, !54, !DIExpression(), !64)
    #dbg_value(i32 0, !59, !DIExpression(), !68)
  br label %for.body, !dbg !69

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !59, !DIExpression(), !68)
  %arrayidx = getelementptr inbounds i64, ptr %call1, i64 %indvars.iv, !dbg !70
  %call3 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !73
  br label %for.inc, !dbg !74

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !75
    #dbg_value(i64 %indvars.iv.next, !59, !DIExpression(), !68)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !76
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !69, !llvm.loop !77

for.end:                                          ; preds = %for.cond.cleanup
  %call4 = call i32 @sem_post(ptr noundef @data_sem) #4, !dbg !81
    #dbg_value(i32 0, !61, !DIExpression(), !82)
  br label %for.body10, !dbg !83

for.cond.cleanup9:                                ; preds = %for.inc14
  br label %for.end16

for.body10:                                       ; preds = %for.end, %for.inc14
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc14 ]
    #dbg_value(i64 %indvars.iv12, !61, !DIExpression(), !82)
  %arrayidx12 = getelementptr inbounds i64, ptr %call1, i64 %indvars.iv12, !dbg !84
  %0 = load i64, ptr %arrayidx12, align 8, !dbg !84, !tbaa !87
  %call13 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !89
  br label %for.inc14, !dbg !90

for.inc14:                                        ; preds = %for.body10
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !91
    #dbg_value(i64 %indvars.iv.next13, !61, !DIExpression(), !82)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !92
  br i1 %exitcond15, label %for.body10, label %for.cond.cleanup9, !dbg !83, !llvm.loop !93

for.end16:                                        ; preds = %for.cond.cleanup9
  call void @free(ptr noundef %call1) #4, !dbg !95
  ret i32 0, !dbg !96
}

; Function Attrs: nounwind
declare !dbg !97 i32 @sem_init(ptr noundef, i32 noundef, i32 noundef) #2

; Function Attrs: nounwind allocsize(0)
declare !dbg !101 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !107 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !125 i32 @pthread_join(i64 noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !129 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!22}
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 14, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/semaphore-posix-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "2d368dc7af41d57134bd4e77ab8748dd")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "data_sem", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "semaphore-posix-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "2d368dc7af41d57134bd4e77ab8748dd")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "sem_t", file: !11, line: 39, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/semaphore.h", directory: "", checksumkind: CSK_MD5, checksum: "43d2f41854b7ddd5eeee8588673fb7ef")
!12 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 35, size: 256, elements: !13)
!13 = !{!14, !19}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !12, file: !11, line: 37, baseType: !15, size: 256)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 256, elements: !17)
!16 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!17 = !{!18}
!18 = !DISubrange(count: 32)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !12, file: !11, line: 38, baseType: !20, size: 64)
!20 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!23 = !{i32 7, !"Dwarf Version", i32 5}
!24 = !{i32 2, !"Debug Info Version", i32 3}
!25 = !{i32 1, !"wchar_size", i32 4}
!26 = !{i32 8, !"PIC Level", i32 2}
!27 = !{i32 7, !"PIE Level", i32 2}
!28 = !{i32 7, !"uwtable", i32 2}
!29 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 17, type: !30, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !32)
!30 = !DISubroutineType(types: !31)
!31 = !{!5, !5}
!32 = !{!33}
!33 = !DILocalVariable(name: "arg", arg: 1, scope: !29, file: !9, line: 17, type: !5)
!34 = !DILocation(line: 0, scope: !29)
!35 = !DILocation(line: 18, column: 3, scope: !29)
!36 = !DILocation(line: 19, column: 8, scope: !29)
!37 = !{!38, !38, i64 0}
!38 = !{!"int", !39, i64 0}
!39 = !{!"omnipotent char", !40, i64 0}
!40 = !{!"Simple C/C++ TBAA"}
!41 = !DILocation(line: 20, column: 3, scope: !29)
!42 = !DILocation(line: 21, column: 3, scope: !29)
!43 = !DISubprogram(name: "sem_wait", scope: !44, file: !44, line: 55, type: !45, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!44 = !DIFile(filename: "/usr/include/semaphore.h", directory: "", checksumkind: CSK_MD5, checksum: "0070fd7047f47c8d6b63b0dfc34dec19")
!45 = !DISubroutineType(types: !46)
!46 = !{!21, !47}
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!48 = !DISubprogram(name: "sem_post", scope: !44, file: !44, line: 103, type: !45, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!49 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 24, type: !50, scopeLine: 24, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{!21}
!52 = !{!53, !54, !59, !61}
!53 = !DILocalVariable(name: "threads_total", scope: !49, file: !9, line: 27, type: !21)
!54 = !DILocalVariable(name: "tids", scope: !49, file: !9, line: 29, type: !55)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !57, line: 27, baseType: !58)
!57 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!58 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!59 = !DILocalVariable(name: "i", scope: !60, file: !9, line: 32, type: !21)
!60 = distinct !DILexicalBlock(scope: !49, file: !9, line: 32, column: 3)
!61 = !DILocalVariable(name: "i", scope: !62, file: !9, line: 39, type: !21)
!62 = distinct !DILexicalBlock(scope: !49, file: !9, line: 39, column: 3)
!63 = !DILocation(line: 25, column: 3, scope: !49)
!64 = !DILocation(line: 0, scope: !49)
!65 = !DILocation(line: 29, column: 28, scope: !49)
!66 = !DILocation(line: 29, column: 42, scope: !49)
!67 = !DILocation(line: 29, column: 21, scope: !49)
!68 = !DILocation(line: 0, scope: !60)
!69 = !DILocation(line: 32, column: 3, scope: !60)
!70 = !DILocation(line: 33, column: 21, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !9, line: 32, column: 43)
!72 = distinct !DILexicalBlock(scope: !60, file: !9, line: 32, column: 3)
!73 = !DILocation(line: 33, column: 5, scope: !71)
!74 = !DILocation(line: 34, column: 3, scope: !71)
!75 = !DILocation(line: 32, column: 39, scope: !72)
!76 = !DILocation(line: 32, column: 21, scope: !72)
!77 = distinct !{!77, !69, !78, !79, !80}
!78 = !DILocation(line: 34, column: 3, scope: !60)
!79 = !{!"llvm.loop.mustprogress"}
!80 = !{!"llvm.loop.unroll.disable"}
!81 = !DILocation(line: 36, column: 3, scope: !49)
!82 = !DILocation(line: 0, scope: !62)
!83 = !DILocation(line: 39, column: 3, scope: !62)
!84 = !DILocation(line: 40, column: 18, scope: !85)
!85 = distinct !DILexicalBlock(scope: !86, file: !9, line: 39, column: 43)
!86 = distinct !DILexicalBlock(scope: !62, file: !9, line: 39, column: 3)
!87 = !{!88, !88, i64 0}
!88 = !{!"long", !39, i64 0}
!89 = !DILocation(line: 40, column: 5, scope: !85)
!90 = !DILocation(line: 41, column: 3, scope: !85)
!91 = !DILocation(line: 39, column: 39, scope: !86)
!92 = !DILocation(line: 39, column: 21, scope: !86)
!93 = distinct !{!93, !83, !94, !79, !80}
!94 = !DILocation(line: 41, column: 3, scope: !62)
!95 = !DILocation(line: 43, column: 3, scope: !49)
!96 = !DILocation(line: 45, column: 3, scope: !49)
!97 = !DISubprogram(name: "sem_init", scope: !44, file: !44, line: 35, type: !98, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!98 = !DISubroutineType(types: !99)
!99 = !{!21, !47, !21, !100}
!100 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!101 = !DISubprogram(name: "malloc", scope: !102, file: !102, line: 672, type: !103, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!102 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!103 = !DISubroutineType(types: !104)
!104 = !{!5, !105}
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !106, line: 18, baseType: !58)
!106 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!107 = !DISubprogram(name: "pthread_create", scope: !108, file: !108, line: 202, type: !109, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!109 = !DISubroutineType(types: !110)
!110 = !{!21, !111, !112, !123, !124}
!111 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !55)
!112 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !113)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !115)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !57, line: 62, baseType: !116)
!116 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !57, line: 56, size: 448, elements: !117)
!117 = !{!118, !122}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !116, file: !57, line: 58, baseType: !119, size: 448)
!119 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 448, elements: !120)
!120 = !{!121}
!121 = !DISubrange(count: 56)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !116, file: !57, line: 59, baseType: !20, size: 64)
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!125 = !DISubprogram(name: "pthread_join", scope: !108, file: !108, line: 219, type: !126, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!126 = !DISubroutineType(types: !127)
!127 = !{!21, !56, !128}
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!129 = !DISubprogram(name: "free", scope: !102, file: !102, line: 687, type: !130, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!130 = !DISubroutineType(types: !131)
!131 = !{null, !5}
