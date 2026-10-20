; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-init-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !11 {
entry:
    #dbg_value(ptr %arg, !16, !DIExpression(), !21)
    #dbg_value(ptr %arg, !17, !DIExpression(), !21)
  %0 = load i32, ptr %arg, align 4, !dbg !22, !tbaa !23
    #dbg_value(i32 %0, !20, !DIExpression(), !21)
  ret ptr null, !dbg !27
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !28 {
entry:
    #dbg_value(i32 4, !32, !DIExpression(), !43)
  %conv = sext i32 4 to i64, !dbg !44
  %mul = mul i64 %conv, 8, !dbg !45
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !46
    #dbg_value(ptr %call, !33, !DIExpression(), !43)
  %conv1 = sext i32 4 to i64, !dbg !47
  %call2 = call noalias ptr @calloc(i64 noundef %conv1, i64 noundef 4) #6, !dbg !48
    #dbg_value(ptr %call2, !38, !DIExpression(), !43)
    #dbg_value(i32 0, !39, !DIExpression(), !49)
  br label %for.body, !dbg !50

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !39, !DIExpression(), !49)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !51
  %arrayidx5 = getelementptr inbounds i32, ptr %call2, i64 %indvars.iv, !dbg !54
  %call6 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %arrayidx5) #7, !dbg !55
  %arrayidx8 = getelementptr inbounds i32, ptr %call2, i64 %indvars.iv, !dbg !56
  %0 = trunc nuw nsw i64 %indvars.iv to i32, !dbg !57
  store i32 %0, ptr %arrayidx8, align 4, !dbg !57, !tbaa !23
  br label %for.inc, !dbg !58

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !59
    #dbg_value(i64 %indvars.iv.next, !39, !DIExpression(), !49)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !60
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !50, !llvm.loop !61

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !41, !DIExpression(), !65)
  br label %for.body14, !dbg !66

for.cond.cleanup13:                               ; preds = %for.inc18
  br label %for.end20

for.body14:                                       ; preds = %for.end, %for.inc18
  %indvars.iv18 = phi i64 [ 0, %for.end ], [ %indvars.iv.next19, %for.inc18 ]
    #dbg_value(i64 %indvars.iv18, !41, !DIExpression(), !65)
  %arrayidx16 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv18, !dbg !67
  %1 = load i64, ptr %arrayidx16, align 8, !dbg !67, !tbaa !70
  %call17 = call i32 @pthread_join(i64 noundef %1, ptr noundef null), !dbg !72
  br label %for.inc18, !dbg !73

for.inc18:                                        ; preds = %for.body14
  %indvars.iv.next19 = add nuw nsw i64 %indvars.iv18, 1, !dbg !74
    #dbg_value(i64 %indvars.iv.next19, !41, !DIExpression(), !65)
  %exitcond21 = icmp ne i64 %indvars.iv.next19, 4, !dbg !75
  br i1 %exitcond21, label %for.body14, label %for.cond.cleanup13, !dbg !66, !llvm.loop !76

for.end20:                                        ; preds = %for.cond.cleanup13
  call void @free(ptr noundef %call) #7, !dbg !78
  call void @free(ptr noundef %call2) #7, !dbg !79
  ret i32 0, !dbg !80
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !81 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind allocsize(0,1)
declare !dbg !87 noalias ptr @calloc(i64 noundef, i64 noundef) #2

; Function Attrs: nounwind
declare !dbg !90 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare !dbg !110 i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: nounwind
declare !dbg !114 void @free(ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0,1) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind allocsize(0) }
attributes #6 = { nounwind allocsize(0,1) }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!4}
!llvm.module.flags = !{!5, !6, !7, !8, !9, !10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-init-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "ff6bfc410688202c03af5068ff2d56a9")
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
!12 = !DIFile(filename: "per-thread-array-init-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "ff6bfc410688202c03af5068ff2d56a9")
!13 = !DISubroutineType(types: !14)
!14 = !{!3, !3}
!15 = !{!16, !17, !20}
!16 = !DILocalVariable(name: "arg", arg: 1, scope: !11, file: !12, line: 13, type: !3)
!17 = !DILocalVariable(name: "p", scope: !11, file: !12, line: 14, type: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DILocalVariable(name: "i", scope: !11, file: !12, line: 15, type: !19)
!21 = !DILocation(line: 0, scope: !11)
!22 = !DILocation(line: 15, column: 11, scope: !11)
!23 = !{!24, !24, i64 0}
!24 = !{!"int", !25, i64 0}
!25 = !{!"omnipotent char", !26, i64 0}
!26 = !{!"Simple C/C++ TBAA"}
!27 = !DILocation(line: 16, column: 3, scope: !11)
!28 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 19, type: !29, scopeLine: 19, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !31)
!29 = !DISubroutineType(types: !30)
!30 = !{!19}
!31 = !{!32, !33, !38, !39, !41}
!32 = !DILocalVariable(name: "threads_total", scope: !28, file: !12, line: 20, type: !19)
!33 = !DILocalVariable(name: "tids", scope: !28, file: !12, line: 22, type: !34)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !36, line: 27, baseType: !37)
!36 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!37 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!38 = !DILocalVariable(name: "is", scope: !28, file: !12, line: 23, type: !18)
!39 = !DILocalVariable(name: "i", scope: !40, file: !12, line: 26, type: !19)
!40 = distinct !DILexicalBlock(scope: !28, file: !12, line: 26, column: 3)
!41 = !DILocalVariable(name: "i", scope: !42, file: !12, line: 32, type: !19)
!42 = distinct !DILexicalBlock(scope: !28, file: !12, line: 32, column: 3)
!43 = !DILocation(line: 0, scope: !28)
!44 = !DILocation(line: 22, column: 28, scope: !28)
!45 = !DILocation(line: 22, column: 42, scope: !28)
!46 = !DILocation(line: 22, column: 21, scope: !28)
!47 = !DILocation(line: 23, column: 20, scope: !28)
!48 = !DILocation(line: 23, column: 13, scope: !28)
!49 = !DILocation(line: 0, scope: !40)
!50 = !DILocation(line: 26, column: 3, scope: !40)
!51 = !DILocation(line: 27, column: 21, scope: !52)
!52 = distinct !DILexicalBlock(scope: !53, file: !12, line: 26, column: 43)
!53 = distinct !DILexicalBlock(scope: !40, file: !12, line: 26, column: 3)
!54 = !DILocation(line: 27, column: 46, scope: !52)
!55 = !DILocation(line: 27, column: 5, scope: !52)
!56 = !DILocation(line: 28, column: 5, scope: !52)
!57 = !DILocation(line: 28, column: 11, scope: !52)
!58 = !DILocation(line: 29, column: 3, scope: !52)
!59 = !DILocation(line: 26, column: 39, scope: !53)
!60 = !DILocation(line: 26, column: 21, scope: !53)
!61 = distinct !{!61, !50, !62, !63, !64}
!62 = !DILocation(line: 29, column: 3, scope: !40)
!63 = !{!"llvm.loop.mustprogress"}
!64 = !{!"llvm.loop.unroll.disable"}
!65 = !DILocation(line: 0, scope: !42)
!66 = !DILocation(line: 32, column: 3, scope: !42)
!67 = !DILocation(line: 33, column: 18, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !12, line: 32, column: 43)
!69 = distinct !DILexicalBlock(scope: !42, file: !12, line: 32, column: 3)
!70 = !{!71, !71, i64 0}
!71 = !{!"long", !25, i64 0}
!72 = !DILocation(line: 33, column: 5, scope: !68)
!73 = !DILocation(line: 34, column: 3, scope: !68)
!74 = !DILocation(line: 32, column: 39, scope: !69)
!75 = !DILocation(line: 32, column: 21, scope: !69)
!76 = distinct !{!76, !66, !77, !63, !64}
!77 = !DILocation(line: 34, column: 3, scope: !42)
!78 = !DILocation(line: 36, column: 3, scope: !28)
!79 = !DILocation(line: 37, column: 3, scope: !28)
!80 = !DILocation(line: 39, column: 3, scope: !28)
!81 = !DISubprogram(name: "malloc", scope: !82, file: !82, line: 672, type: !83, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!83 = !DISubroutineType(types: !84)
!84 = !{!3, !85}
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !86, line: 18, baseType: !37)
!86 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!87 = !DISubprogram(name: "calloc", scope: !82, file: !82, line: 675, type: !88, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!88 = !DISubroutineType(types: !89)
!89 = !{!3, !85, !85}
!90 = !DISubprogram(name: "pthread_create", scope: !91, file: !91, line: 202, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!92 = !DISubroutineType(types: !93)
!93 = !{!19, !94, !95, !108, !109}
!94 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !34)
!95 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !96)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !98)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !36, line: 62, baseType: !99)
!99 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !36, line: 56, size: 448, elements: !100)
!100 = !{!101, !106}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !99, file: !36, line: 58, baseType: !102, size: 448)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !103, size: 448, elements: !104)
!103 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!104 = !{!105}
!105 = !DISubrange(count: 56)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !99, file: !36, line: 59, baseType: !107, size: 64)
!107 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!110 = !DISubprogram(name: "pthread_join", scope: !91, file: !91, line: 219, type: !111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DISubroutineType(types: !112)
!112 = !{!19, !35, !113}
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!114 = !DISubprogram(name: "free", scope: !82, file: !82, line: 687, type: !115, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!115 = !DISubroutineType(types: !116)
!116 = !{null, !3}
