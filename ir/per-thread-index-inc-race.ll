; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-index-inc-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@next_j = dso_local global i32 0, align 4, !dbg !0
@datas = dso_local global ptr null, align 8, !dbg !7

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !19 {
entry:
    #dbg_value(ptr %arg, !23, !DIExpression(), !25)
  %0 = load i32, ptr @next_j, align 4, !dbg !26, !tbaa !27
    #dbg_value(i32 %0, !24, !DIExpression(), !25)
  %1 = load i32, ptr @next_j, align 4, !dbg !31, !tbaa !27
  %inc = add nsw i32 %1, 1, !dbg !31
  store i32 %inc, ptr @next_j, align 4, !dbg !31, !tbaa !27
  %2 = load ptr, ptr @datas, align 8, !dbg !32, !tbaa !33
  %idxprom = sext i32 %0 to i64, !dbg !32
  %arrayidx = getelementptr inbounds i32, ptr %2, i64 %idxprom, !dbg !32
  store i32 4, ptr %arrayidx, align 4, !dbg !36, !tbaa !27
  ret ptr null, !dbg !37
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !38 {
entry:
    #dbg_value(i32 4, !42, !DIExpression(), !52)
  %conv = sext i32 4 to i64, !dbg !53
  %mul = mul i64 %conv, 8, !dbg !54
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !55
    #dbg_value(ptr %call, !43, !DIExpression(), !52)
  %conv1 = sext i32 4 to i64, !dbg !56
  %mul2 = mul i64 %conv1, 4, !dbg !57
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !58
  store ptr %call3, ptr @datas, align 8, !dbg !59, !tbaa !33
    #dbg_value(i32 0, !48, !DIExpression(), !60)
  br label %for.body, !dbg !61

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !48, !DIExpression(), !60)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !62
  %call5 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #5, !dbg !65
  br label %for.inc, !dbg !66

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !67
    #dbg_value(i64 %indvars.iv.next, !48, !DIExpression(), !60)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !68
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !61, !llvm.loop !69

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !50, !DIExpression(), !73)
  br label %for.body11, !dbg !74

for.cond.cleanup10:                               ; preds = %for.inc15
  br label %for.end17

for.body11:                                       ; preds = %for.end, %for.inc15
  %indvars.iv13 = phi i64 [ 0, %for.end ], [ %indvars.iv.next14, %for.inc15 ]
    #dbg_value(i64 %indvars.iv13, !50, !DIExpression(), !73)
  %arrayidx13 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv13, !dbg !75
  %0 = load i64, ptr %arrayidx13, align 8, !dbg !75, !tbaa !78
  %call14 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !80
  br label %for.inc15, !dbg !81

for.inc15:                                        ; preds = %for.body11
  %indvars.iv.next14 = add nuw nsw i64 %indvars.iv13, 1, !dbg !82
    #dbg_value(i64 %indvars.iv.next14, !50, !DIExpression(), !73)
  %exitcond16 = icmp ne i64 %indvars.iv.next14, 4, !dbg !83
  br i1 %exitcond16, label %for.body11, label %for.cond.cleanup10, !dbg !74, !llvm.loop !84

for.end17:                                        ; preds = %for.cond.cleanup10
  call void @free(ptr noundef %call) #5, !dbg !86
  %1 = load ptr, ptr @datas, align 8, !dbg !87, !tbaa !33
  call void @free(ptr noundef %1) #5, !dbg !88
  ret i32 0, !dbg !89
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !90 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !96 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !116 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !120 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "next_j", scope: !2, file: !9, line: 16, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-index-inc-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "d9324586c514b1d10f46001d0ec62e67")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !9, line: 14, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "per-thread-index-inc-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "d9324586c514b1d10f46001d0ec62e67")
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 8, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 2}
!19 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 18, type: !20, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !22)
!20 = !DISubroutineType(types: !21)
!21 = !{!5, !5}
!22 = !{!23, !24}
!23 = !DILocalVariable(name: "arg", arg: 1, scope: !19, file: !9, line: 18, type: !5)
!24 = !DILocalVariable(name: "j", scope: !19, file: !9, line: 19, type: !11)
!25 = !DILocation(line: 0, scope: !19)
!26 = !DILocation(line: 20, column: 7, scope: !19)
!27 = !{!28, !28, i64 0}
!28 = !{!"int", !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C/C++ TBAA"}
!31 = !DILocation(line: 21, column: 9, scope: !19)
!32 = !DILocation(line: 23, column: 3, scope: !19)
!33 = !{!34, !34, i64 0}
!34 = !{!"p1 int", !35, i64 0}
!35 = !{!"any pointer", !29, i64 0}
!36 = !DILocation(line: 23, column: 12, scope: !19)
!37 = !DILocation(line: 24, column: 3, scope: !19)
!38 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 27, type: !39, scopeLine: 27, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!11}
!41 = !{!42, !43, !48, !50}
!42 = !DILocalVariable(name: "threads_total", scope: !38, file: !9, line: 28, type: !11)
!43 = !DILocalVariable(name: "tids", scope: !38, file: !9, line: 30, type: !44)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !46, line: 27, baseType: !47)
!46 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!47 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!48 = !DILocalVariable(name: "i", scope: !49, file: !9, line: 34, type: !11)
!49 = distinct !DILexicalBlock(scope: !38, file: !9, line: 34, column: 3)
!50 = !DILocalVariable(name: "i", scope: !51, file: !9, line: 39, type: !11)
!51 = distinct !DILexicalBlock(scope: !38, file: !9, line: 39, column: 3)
!52 = !DILocation(line: 0, scope: !38)
!53 = !DILocation(line: 30, column: 28, scope: !38)
!54 = !DILocation(line: 30, column: 42, scope: !38)
!55 = !DILocation(line: 30, column: 21, scope: !38)
!56 = !DILocation(line: 31, column: 18, scope: !38)
!57 = !DILocation(line: 31, column: 32, scope: !38)
!58 = !DILocation(line: 31, column: 11, scope: !38)
!59 = !DILocation(line: 31, column: 9, scope: !38)
!60 = !DILocation(line: 0, scope: !49)
!61 = !DILocation(line: 34, column: 3, scope: !49)
!62 = !DILocation(line: 35, column: 21, scope: !63)
!63 = distinct !DILexicalBlock(scope: !64, file: !9, line: 34, column: 43)
!64 = distinct !DILexicalBlock(scope: !49, file: !9, line: 34, column: 3)
!65 = !DILocation(line: 35, column: 5, scope: !63)
!66 = !DILocation(line: 36, column: 3, scope: !63)
!67 = !DILocation(line: 34, column: 39, scope: !64)
!68 = !DILocation(line: 34, column: 21, scope: !64)
!69 = distinct !{!69, !61, !70, !71, !72}
!70 = !DILocation(line: 36, column: 3, scope: !49)
!71 = !{!"llvm.loop.mustprogress"}
!72 = !{!"llvm.loop.unroll.disable"}
!73 = !DILocation(line: 0, scope: !51)
!74 = !DILocation(line: 39, column: 3, scope: !51)
!75 = !DILocation(line: 40, column: 18, scope: !76)
!76 = distinct !DILexicalBlock(scope: !77, file: !9, line: 39, column: 43)
!77 = distinct !DILexicalBlock(scope: !51, file: !9, line: 39, column: 3)
!78 = !{!79, !79, i64 0}
!79 = !{!"long", !29, i64 0}
!80 = !DILocation(line: 40, column: 5, scope: !76)
!81 = !DILocation(line: 41, column: 3, scope: !76)
!82 = !DILocation(line: 39, column: 39, scope: !77)
!83 = !DILocation(line: 39, column: 21, scope: !77)
!84 = distinct !{!84, !74, !85, !71, !72}
!85 = !DILocation(line: 41, column: 3, scope: !51)
!86 = !DILocation(line: 43, column: 3, scope: !38)
!87 = !DILocation(line: 44, column: 8, scope: !38)
!88 = !DILocation(line: 44, column: 3, scope: !38)
!89 = !DILocation(line: 46, column: 3, scope: !38)
!90 = !DISubprogram(name: "malloc", scope: !91, file: !91, line: 672, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!92 = !DISubroutineType(types: !93)
!93 = !{!5, !94}
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !95, line: 18, baseType: !47)
!95 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!96 = !DISubprogram(name: "pthread_create", scope: !97, file: !97, line: 202, type: !98, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!97 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!98 = !DISubroutineType(types: !99)
!99 = !{!11, !100, !101, !114, !115}
!100 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !44)
!101 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !102)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !104)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !46, line: 62, baseType: !105)
!105 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !46, line: 56, size: 448, elements: !106)
!106 = !{!107, !112}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !105, file: !46, line: 58, baseType: !108, size: 448)
!108 = !DICompositeType(tag: DW_TAG_array_type, baseType: !109, size: 448, elements: !110)
!109 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!110 = !{!111}
!111 = !DISubrange(count: 56)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !105, file: !46, line: 59, baseType: !113, size: 64)
!113 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!116 = !DISubprogram(name: "pthread_join", scope: !97, file: !97, line: 219, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DISubroutineType(types: !118)
!118 = !{!11, !45, !119}
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!120 = !DISubprogram(name: "free", scope: !91, file: !91, line: 687, type: !121, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DISubroutineType(types: !122)
!122 = !{null, !5}
