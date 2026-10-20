; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-ptr-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !11 {
entry:
    #dbg_value(ptr %arg, !16, !DIExpression(), !20)
    #dbg_value(ptr %arg, !17, !DIExpression(), !20)
  store i32 4, ptr %arg, align 4, !dbg !21, !tbaa !22
  ret ptr null, !dbg !26
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !27 {
entry:
    #dbg_value(i32 4, !31, !DIExpression(), !42)
  %conv = sext i32 4 to i64, !dbg !43
  %mul = mul i64 %conv, 8, !dbg !44
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !45
    #dbg_value(ptr %call, !32, !DIExpression(), !42)
  %conv1 = sext i32 4 to i64, !dbg !46
  %mul2 = mul i64 %conv1, 4, !dbg !47
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !48
    #dbg_value(ptr %call3, !37, !DIExpression(), !42)
    #dbg_value(i32 0, !38, !DIExpression(), !49)
  br label %for.body, !dbg !50

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !38, !DIExpression(), !49)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !51
  %0 = trunc nuw nsw i64 %indvars.iv to i32, !dbg !54
  %div.udiv = udiv i32 %0, 2, !dbg !54
  %idxprom5 = sext i32 %div.udiv to i64, !dbg !55
  %arrayidx6 = getelementptr inbounds i32, ptr %call3, i64 %idxprom5, !dbg !55
  %call7 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %arrayidx6) #5, !dbg !56
  br label %for.inc, !dbg !57

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !58
    #dbg_value(i64 %indvars.iv.next, !38, !DIExpression(), !49)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !59
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !50, !llvm.loop !60

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !40, !DIExpression(), !64)
  br label %for.body13, !dbg !65

for.cond.cleanup12:                               ; preds = %for.inc17
  br label %for.end19

for.body13:                                       ; preds = %for.end, %for.inc17
  %indvars.iv15 = phi i64 [ 0, %for.end ], [ %indvars.iv.next16, %for.inc17 ]
    #dbg_value(i64 %indvars.iv15, !40, !DIExpression(), !64)
  %arrayidx15 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv15, !dbg !66
  %1 = load i64, ptr %arrayidx15, align 8, !dbg !66, !tbaa !69
  %call16 = call i32 @pthread_join(i64 noundef %1, ptr noundef null), !dbg !71
  br label %for.inc17, !dbg !72

for.inc17:                                        ; preds = %for.body13
  %indvars.iv.next16 = add nuw nsw i64 %indvars.iv15, 1, !dbg !73
    #dbg_value(i64 %indvars.iv.next16, !40, !DIExpression(), !64)
  %exitcond18 = icmp ne i64 %indvars.iv.next16, 4, !dbg !74
  br i1 %exitcond18, label %for.body13, label %for.cond.cleanup12, !dbg !65, !llvm.loop !75

for.end19:                                        ; preds = %for.cond.cleanup12
  call void @free(ptr noundef %call) #5, !dbg !77
  call void @free(ptr noundef %call3) #5, !dbg !78
  ret i32 0, !dbg !79
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !80 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !86 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !106 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !110 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!4}
!llvm.module.flags = !{!5, !6, !7, !8, !9, !10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-ptr-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "bec66c0645f1520981a0e394114b6999")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!5 = !{i32 7, !"Dwarf Version", i32 5}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 8, !"PIC Level", i32 2}
!9 = !{i32 7, !"PIE Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 2}
!11 = distinct !DISubprogram(name: "thread", scope: !12, file: !12, line: 13, type: !13, scopeLine: 13, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !15)
!12 = !DIFile(filename: "per-thread-array-ptr-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "bec66c0645f1520981a0e394114b6999")
!13 = !DISubroutineType(types: !14)
!14 = !{!3, !3}
!15 = !{!16, !17}
!16 = !DILocalVariable(name: "arg", arg: 1, scope: !11, file: !12, line: 13, type: !3)
!17 = !DILocalVariable(name: "p", scope: !11, file: !12, line: 14, type: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DILocation(line: 0, scope: !11)
!21 = !DILocation(line: 15, column: 6, scope: !11)
!22 = !{!23, !23, i64 0}
!23 = !{!"int", !24, i64 0}
!24 = !{!"omnipotent char", !25, i64 0}
!25 = !{!"Simple C/C++ TBAA"}
!26 = !DILocation(line: 16, column: 3, scope: !11)
!27 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 19, type: !28, scopeLine: 19, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !30)
!28 = !DISubroutineType(types: !29)
!29 = !{!19}
!30 = !{!31, !32, !37, !38, !40}
!31 = !DILocalVariable(name: "threads_total", scope: !27, file: !12, line: 20, type: !19)
!32 = !DILocalVariable(name: "tids", scope: !27, file: !12, line: 22, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !35, line: 27, baseType: !36)
!35 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!36 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!37 = !DILocalVariable(name: "datas", scope: !27, file: !12, line: 23, type: !18)
!38 = !DILocalVariable(name: "i", scope: !39, file: !12, line: 26, type: !19)
!39 = distinct !DILexicalBlock(scope: !27, file: !12, line: 26, column: 3)
!40 = !DILocalVariable(name: "i", scope: !41, file: !12, line: 31, type: !19)
!41 = distinct !DILexicalBlock(scope: !27, file: !12, line: 31, column: 3)
!42 = !DILocation(line: 0, scope: !27)
!43 = !DILocation(line: 22, column: 28, scope: !27)
!44 = !DILocation(line: 22, column: 42, scope: !27)
!45 = !DILocation(line: 22, column: 21, scope: !27)
!46 = !DILocation(line: 23, column: 23, scope: !27)
!47 = !DILocation(line: 23, column: 37, scope: !27)
!48 = !DILocation(line: 23, column: 16, scope: !27)
!49 = !DILocation(line: 0, scope: !39)
!50 = !DILocation(line: 26, column: 3, scope: !39)
!51 = !DILocation(line: 27, column: 21, scope: !52)
!52 = distinct !DILexicalBlock(scope: !53, file: !12, line: 26, column: 43)
!53 = distinct !DILexicalBlock(scope: !39, file: !12, line: 26, column: 3)
!54 = !DILocation(line: 27, column: 54, scope: !52)
!55 = !DILocation(line: 27, column: 46, scope: !52)
!56 = !DILocation(line: 27, column: 5, scope: !52)
!57 = !DILocation(line: 28, column: 3, scope: !52)
!58 = !DILocation(line: 26, column: 39, scope: !53)
!59 = !DILocation(line: 26, column: 21, scope: !53)
!60 = distinct !{!60, !50, !61, !62, !63}
!61 = !DILocation(line: 28, column: 3, scope: !39)
!62 = !{!"llvm.loop.mustprogress"}
!63 = !{!"llvm.loop.unroll.disable"}
!64 = !DILocation(line: 0, scope: !41)
!65 = !DILocation(line: 31, column: 3, scope: !41)
!66 = !DILocation(line: 32, column: 18, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !12, line: 31, column: 43)
!68 = distinct !DILexicalBlock(scope: !41, file: !12, line: 31, column: 3)
!69 = !{!70, !70, i64 0}
!70 = !{!"long", !24, i64 0}
!71 = !DILocation(line: 32, column: 5, scope: !67)
!72 = !DILocation(line: 33, column: 3, scope: !67)
!73 = !DILocation(line: 31, column: 39, scope: !68)
!74 = !DILocation(line: 31, column: 21, scope: !68)
!75 = distinct !{!75, !65, !76, !62, !63}
!76 = !DILocation(line: 33, column: 3, scope: !41)
!77 = !DILocation(line: 35, column: 3, scope: !27)
!78 = !DILocation(line: 36, column: 3, scope: !27)
!79 = !DILocation(line: 38, column: 3, scope: !27)
!80 = !DISubprogram(name: "malloc", scope: !81, file: !81, line: 672, type: !82, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!81 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!82 = !DISubroutineType(types: !83)
!83 = !{!3, !84}
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !85, line: 18, baseType: !36)
!85 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!86 = !DISubprogram(name: "pthread_create", scope: !87, file: !87, line: 202, type: !88, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!87 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!88 = !DISubroutineType(types: !89)
!89 = !{!19, !90, !91, !104, !105}
!90 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !33)
!91 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !92)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!93 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !35, line: 62, baseType: !95)
!95 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !35, line: 56, size: 448, elements: !96)
!96 = !{!97, !102}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !95, file: !35, line: 58, baseType: !98, size: 448)
!98 = !DICompositeType(tag: DW_TAG_array_type, baseType: !99, size: 448, elements: !100)
!99 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!100 = !{!101}
!101 = !DISubrange(count: 56)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !95, file: !35, line: 59, baseType: !103, size: 64)
!103 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!106 = !DISubprogram(name: "pthread_join", scope: !87, file: !87, line: 219, type: !107, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!107 = !DISubroutineType(types: !108)
!108 = !{!19, !34, !109}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!110 = !DISubprogram(name: "free", scope: !81, file: !81, line: 687, type: !111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DISubroutineType(types: !112)
!112 = !{null, !3}
