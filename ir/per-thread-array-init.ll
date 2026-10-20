; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-init.linked.bc'
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
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !46
    #dbg_value(ptr %call, !33, !DIExpression(), !43)
  %conv1 = sext i32 4 to i64, !dbg !47
  %mul2 = mul i64 %conv1, 4, !dbg !48
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !49
    #dbg_value(ptr %call3, !38, !DIExpression(), !43)
    #dbg_value(i32 0, !39, !DIExpression(), !50)
  br label %for.body, !dbg !51

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !39, !DIExpression(), !50)
  %arrayidx = getelementptr inbounds i32, ptr %call3, i64 %indvars.iv, !dbg !52
  %0 = trunc nuw nsw i64 %indvars.iv to i32, !dbg !55
  store i32 %0, ptr %arrayidx, align 4, !dbg !55, !tbaa !23
  %arrayidx6 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !56
  %arrayidx8 = getelementptr inbounds i32, ptr %call3, i64 %indvars.iv, !dbg !57
  %call9 = call i32 @pthread_create(ptr noundef %arrayidx6, ptr noundef null, ptr noundef @thread, ptr noundef %arrayidx8) #5, !dbg !58
  br label %for.inc, !dbg !59

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !60
    #dbg_value(i64 %indvars.iv.next, !39, !DIExpression(), !50)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !61
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !51, !llvm.loop !62

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !41, !DIExpression(), !66)
  br label %for.body15, !dbg !67

for.cond.cleanup14:                               ; preds = %for.inc19
  br label %for.end21

for.body15:                                       ; preds = %for.end, %for.inc19
  %indvars.iv18 = phi i64 [ 0, %for.end ], [ %indvars.iv.next19, %for.inc19 ]
    #dbg_value(i64 %indvars.iv18, !41, !DIExpression(), !66)
  %arrayidx17 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv18, !dbg !68
  %1 = load i64, ptr %arrayidx17, align 8, !dbg !68, !tbaa !71
  %call18 = call i32 @pthread_join(i64 noundef %1, ptr noundef null), !dbg !73
  br label %for.inc19, !dbg !74

for.inc19:                                        ; preds = %for.body15
  %indvars.iv.next19 = add nuw nsw i64 %indvars.iv18, 1, !dbg !75
    #dbg_value(i64 %indvars.iv.next19, !41, !DIExpression(), !66)
  %exitcond21 = icmp ne i64 %indvars.iv.next19, 4, !dbg !76
  br i1 %exitcond21, label %for.body15, label %for.cond.cleanup14, !dbg !67, !llvm.loop !77

for.end21:                                        ; preds = %for.cond.cleanup14
  call void @free(ptr noundef %call) #5, !dbg !79
  call void @free(ptr noundef %call3) #5, !dbg !80
  ret i32 0, !dbg !81
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !82 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !88 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !108 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !112 void @free(ptr noundef) #2

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
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-init.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "6bc493cf0d32481c25a7b206e43c54e3")
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
!12 = !DIFile(filename: "per-thread-array-init.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "6bc493cf0d32481c25a7b206e43c54e3")
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
!48 = !DILocation(line: 23, column: 34, scope: !28)
!49 = !DILocation(line: 23, column: 13, scope: !28)
!50 = !DILocation(line: 0, scope: !40)
!51 = !DILocation(line: 26, column: 3, scope: !40)
!52 = !DILocation(line: 27, column: 5, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !12, line: 26, column: 43)
!54 = distinct !DILexicalBlock(scope: !40, file: !12, line: 26, column: 3)
!55 = !DILocation(line: 27, column: 11, scope: !53)
!56 = !DILocation(line: 28, column: 21, scope: !53)
!57 = !DILocation(line: 28, column: 46, scope: !53)
!58 = !DILocation(line: 28, column: 5, scope: !53)
!59 = !DILocation(line: 29, column: 3, scope: !53)
!60 = !DILocation(line: 26, column: 39, scope: !54)
!61 = !DILocation(line: 26, column: 21, scope: !54)
!62 = distinct !{!62, !51, !63, !64, !65}
!63 = !DILocation(line: 29, column: 3, scope: !40)
!64 = !{!"llvm.loop.mustprogress"}
!65 = !{!"llvm.loop.unroll.disable"}
!66 = !DILocation(line: 0, scope: !42)
!67 = !DILocation(line: 32, column: 3, scope: !42)
!68 = !DILocation(line: 33, column: 18, scope: !69)
!69 = distinct !DILexicalBlock(scope: !70, file: !12, line: 32, column: 43)
!70 = distinct !DILexicalBlock(scope: !42, file: !12, line: 32, column: 3)
!71 = !{!72, !72, i64 0}
!72 = !{!"long", !25, i64 0}
!73 = !DILocation(line: 33, column: 5, scope: !69)
!74 = !DILocation(line: 34, column: 3, scope: !69)
!75 = !DILocation(line: 32, column: 39, scope: !70)
!76 = !DILocation(line: 32, column: 21, scope: !70)
!77 = distinct !{!77, !67, !78, !64, !65}
!78 = !DILocation(line: 34, column: 3, scope: !42)
!79 = !DILocation(line: 36, column: 3, scope: !28)
!80 = !DILocation(line: 37, column: 3, scope: !28)
!81 = !DILocation(line: 39, column: 3, scope: !28)
!82 = !DISubprogram(name: "malloc", scope: !83, file: !83, line: 672, type: !84, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!83 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!84 = !DISubroutineType(types: !85)
!85 = !{!3, !86}
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !87, line: 18, baseType: !37)
!87 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!88 = !DISubprogram(name: "pthread_create", scope: !89, file: !89, line: 202, type: !90, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!89 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!90 = !DISubroutineType(types: !91)
!91 = !{!19, !92, !93, !106, !107}
!92 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !34)
!93 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !94)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !96)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !36, line: 62, baseType: !97)
!97 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !36, line: 56, size: 448, elements: !98)
!98 = !{!99, !104}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !97, file: !36, line: 58, baseType: !100, size: 448)
!100 = !DICompositeType(tag: DW_TAG_array_type, baseType: !101, size: 448, elements: !102)
!101 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!102 = !{!103}
!103 = !DISubrange(count: 56)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !97, file: !36, line: 59, baseType: !105, size: 64)
!105 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!108 = !DISubprogram(name: "pthread_join", scope: !89, file: !89, line: 219, type: !109, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!109 = !DISubroutineType(types: !110)
!110 = !{!19, !35, !111}
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!112 = !DISubprogram(name: "free", scope: !83, file: !83, line: 687, type: !113, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !3}
