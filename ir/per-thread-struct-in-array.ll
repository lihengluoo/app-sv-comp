; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-struct-in-array.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.thread = type { i32 }

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !11 {
entry:
    #dbg_value(ptr %arg, !16, !DIExpression(), !23)
    #dbg_value(ptr %arg, !17, !DIExpression(), !23)
  %data = getelementptr inbounds nuw %struct.thread, ptr %arg, i32 0, i32 0, !dbg !24
  store i32 4, ptr %data, align 4, !dbg !25, !tbaa !26
  ret ptr null, !dbg !31
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !32 {
entry:
    #dbg_value(i32 4, !36, !DIExpression(), !47)
  %conv = sext i32 4 to i64, !dbg !48
  %mul = mul i64 %conv, 8, !dbg !49
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !50
    #dbg_value(ptr %call, !37, !DIExpression(), !47)
  %conv1 = sext i32 4 to i64, !dbg !51
  %mul2 = mul i64 %conv1, 4, !dbg !52
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !53
    #dbg_value(ptr %call3, !42, !DIExpression(), !47)
    #dbg_value(i32 0, !43, !DIExpression(), !54)
  br label %for.body, !dbg !55

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !43, !DIExpression(), !54)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !56
  %arrayidx6 = getelementptr inbounds %struct.thread, ptr %call3, i64 %indvars.iv, !dbg !59
  %call7 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %arrayidx6) #5, !dbg !60
  br label %for.inc, !dbg !61

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !62
    #dbg_value(i64 %indvars.iv.next, !43, !DIExpression(), !54)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !63
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !55, !llvm.loop !64

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !45, !DIExpression(), !68)
  br label %for.body13, !dbg !69

for.cond.cleanup12:                               ; preds = %for.inc17
  br label %for.end19

for.body13:                                       ; preds = %for.end, %for.inc17
  %indvars.iv15 = phi i64 [ 0, %for.end ], [ %indvars.iv.next16, %for.inc17 ]
    #dbg_value(i64 %indvars.iv15, !45, !DIExpression(), !68)
  %arrayidx15 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv15, !dbg !70
  %0 = load i64, ptr %arrayidx15, align 8, !dbg !70, !tbaa !73
  %call16 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !75
  br label %for.inc17, !dbg !76

for.inc17:                                        ; preds = %for.body13
  %indvars.iv.next16 = add nuw nsw i64 %indvars.iv15, 1, !dbg !77
    #dbg_value(i64 %indvars.iv.next16, !45, !DIExpression(), !68)
  %exitcond18 = icmp ne i64 %indvars.iv.next16, 4, !dbg !78
  br i1 %exitcond18, label %for.body13, label %for.cond.cleanup12, !dbg !69, !llvm.loop !79

for.end19:                                        ; preds = %for.cond.cleanup12
  call void @free(ptr noundef %call) #5, !dbg !81
  call void @free(ptr noundef %call3) #5, !dbg !82
  ret i32 0, !dbg !83
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !84 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !90 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !110 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !114 void @free(ptr noundef) #2

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
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-struct-in-array.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "ad7043af59e696235c2eb2e1a58978cf")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!5 = !{i32 7, !"Dwarf Version", i32 5}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 8, !"PIC Level", i32 2}
!9 = !{i32 7, !"PIE Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 2}
!11 = distinct !DISubprogram(name: "thread", scope: !12, file: !12, line: 17, type: !13, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !15)
!12 = !DIFile(filename: "per-thread-struct-in-array.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "ad7043af59e696235c2eb2e1a58978cf")
!13 = !DISubroutineType(types: !14)
!14 = !{!3, !3}
!15 = !{!16, !17}
!16 = !DILocalVariable(name: "arg", arg: 1, scope: !11, file: !12, line: 17, type: !3)
!17 = !DILocalVariable(name: "t", scope: !11, file: !12, line: 18, type: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "thread", file: !12, line: 13, size: 32, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !19, file: !12, line: 14, baseType: !22, size: 32)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DILocation(line: 0, scope: !11)
!24 = !DILocation(line: 19, column: 6, scope: !11)
!25 = !DILocation(line: 19, column: 11, scope: !11)
!26 = !{!27, !28, i64 0}
!27 = !{!"thread", !28, i64 0}
!28 = !{!"int", !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C/C++ TBAA"}
!31 = !DILocation(line: 20, column: 3, scope: !11)
!32 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 23, type: !33, scopeLine: 23, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !35)
!33 = !DISubroutineType(types: !34)
!34 = !{!22}
!35 = !{!36, !37, !42, !43, !45}
!36 = !DILocalVariable(name: "threads_total", scope: !32, file: !12, line: 24, type: !22)
!37 = !DILocalVariable(name: "tids", scope: !32, file: !12, line: 26, type: !38)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !40, line: 27, baseType: !41)
!40 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!41 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!42 = !DILocalVariable(name: "ts", scope: !32, file: !12, line: 27, type: !18)
!43 = !DILocalVariable(name: "i", scope: !44, file: !12, line: 30, type: !22)
!44 = distinct !DILexicalBlock(scope: !32, file: !12, line: 30, column: 3)
!45 = !DILocalVariable(name: "i", scope: !46, file: !12, line: 35, type: !22)
!46 = distinct !DILexicalBlock(scope: !32, file: !12, line: 35, column: 3)
!47 = !DILocation(line: 0, scope: !32)
!48 = !DILocation(line: 26, column: 28, scope: !32)
!49 = !DILocation(line: 26, column: 42, scope: !32)
!50 = !DILocation(line: 26, column: 21, scope: !32)
!51 = !DILocation(line: 27, column: 30, scope: !32)
!52 = !DILocation(line: 27, column: 44, scope: !32)
!53 = !DILocation(line: 27, column: 23, scope: !32)
!54 = !DILocation(line: 0, scope: !44)
!55 = !DILocation(line: 30, column: 3, scope: !44)
!56 = !DILocation(line: 31, column: 21, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !12, line: 30, column: 43)
!58 = distinct !DILexicalBlock(scope: !44, file: !12, line: 30, column: 3)
!59 = !DILocation(line: 31, column: 46, scope: !57)
!60 = !DILocation(line: 31, column: 5, scope: !57)
!61 = !DILocation(line: 32, column: 3, scope: !57)
!62 = !DILocation(line: 30, column: 39, scope: !58)
!63 = !DILocation(line: 30, column: 21, scope: !58)
!64 = distinct !{!64, !55, !65, !66, !67}
!65 = !DILocation(line: 32, column: 3, scope: !44)
!66 = !{!"llvm.loop.mustprogress"}
!67 = !{!"llvm.loop.unroll.disable"}
!68 = !DILocation(line: 0, scope: !46)
!69 = !DILocation(line: 35, column: 3, scope: !46)
!70 = !DILocation(line: 36, column: 18, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !12, line: 35, column: 43)
!72 = distinct !DILexicalBlock(scope: !46, file: !12, line: 35, column: 3)
!73 = !{!74, !74, i64 0}
!74 = !{!"long", !29, i64 0}
!75 = !DILocation(line: 36, column: 5, scope: !71)
!76 = !DILocation(line: 37, column: 3, scope: !71)
!77 = !DILocation(line: 35, column: 39, scope: !72)
!78 = !DILocation(line: 35, column: 21, scope: !72)
!79 = distinct !{!79, !69, !80, !66, !67}
!80 = !DILocation(line: 37, column: 3, scope: !46)
!81 = !DILocation(line: 39, column: 3, scope: !32)
!82 = !DILocation(line: 40, column: 3, scope: !32)
!83 = !DILocation(line: 42, column: 3, scope: !32)
!84 = !DISubprogram(name: "malloc", scope: !85, file: !85, line: 672, type: !86, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!85 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!86 = !DISubroutineType(types: !87)
!87 = !{!3, !88}
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !89, line: 18, baseType: !41)
!89 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!90 = !DISubprogram(name: "pthread_create", scope: !91, file: !91, line: 202, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!92 = !DISubroutineType(types: !93)
!93 = !{!22, !94, !95, !108, !109}
!94 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !38)
!95 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !96)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !98)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !40, line: 62, baseType: !99)
!99 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !40, line: 56, size: 448, elements: !100)
!100 = !{!101, !106}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !99, file: !40, line: 58, baseType: !102, size: 448)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !103, size: 448, elements: !104)
!103 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!104 = !{!105}
!105 = !DISubrange(count: 56)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !99, file: !40, line: 59, baseType: !107, size: 64)
!107 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!110 = !DISubprogram(name: "pthread_join", scope: !91, file: !91, line: 219, type: !111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DISubroutineType(types: !112)
!112 = !{!22, !39, !113}
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!114 = !DISubprogram(name: "free", scope: !85, file: !85, line: 687, type: !115, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!115 = !DISubroutineType(types: !116)
!116 = !{null, !3}
