; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-struct-race.linked.bc'
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
  %call1 = call noalias ptr @malloc(i64 noundef 4) #4, !dbg !51
    #dbg_value(ptr %call1, !42, !DIExpression(), !47)
    #dbg_value(i32 0, !43, !DIExpression(), !52)
  br label %for.body, !dbg !53

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !43, !DIExpression(), !52)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !54
  %call3 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %call1) #5, !dbg !57
  br label %for.inc, !dbg !58

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !59
    #dbg_value(i64 %indvars.iv.next, !43, !DIExpression(), !52)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !60
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !53, !llvm.loop !61

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !45, !DIExpression(), !65)
  br label %for.body9, !dbg !66

for.cond.cleanup8:                                ; preds = %for.inc13
  br label %for.end15

for.body9:                                        ; preds = %for.end, %for.inc13
  %indvars.iv13 = phi i64 [ 0, %for.end ], [ %indvars.iv.next14, %for.inc13 ]
    #dbg_value(i64 %indvars.iv13, !45, !DIExpression(), !65)
  %arrayidx11 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv13, !dbg !67
  %0 = load i64, ptr %arrayidx11, align 8, !dbg !67, !tbaa !70
  %call12 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !72
  br label %for.inc13, !dbg !73

for.inc13:                                        ; preds = %for.body9
  %indvars.iv.next14 = add nuw nsw i64 %indvars.iv13, 1, !dbg !74
    #dbg_value(i64 %indvars.iv.next14, !45, !DIExpression(), !65)
  %exitcond16 = icmp ne i64 %indvars.iv.next14, 4, !dbg !75
  br i1 %exitcond16, label %for.body9, label %for.cond.cleanup8, !dbg !66, !llvm.loop !76

for.end15:                                        ; preds = %for.cond.cleanup8
  call void @free(ptr noundef %call) #5, !dbg !78
  call void @free(ptr noundef %call1) #5, !dbg !79
  ret i32 0, !dbg !80
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !81 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !87 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !107 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !111 void @free(ptr noundef) #2

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
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-struct-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "a18f6a9eb4583859aa5d356f146f7225")
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
!12 = !DIFile(filename: "per-thread-struct-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "a18f6a9eb4583859aa5d356f146f7225")
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
!42 = !DILocalVariable(name: "t", scope: !32, file: !12, line: 27, type: !18)
!43 = !DILocalVariable(name: "i", scope: !44, file: !12, line: 30, type: !22)
!44 = distinct !DILexicalBlock(scope: !32, file: !12, line: 30, column: 3)
!45 = !DILocalVariable(name: "i", scope: !46, file: !12, line: 35, type: !22)
!46 = distinct !DILexicalBlock(scope: !32, file: !12, line: 35, column: 3)
!47 = !DILocation(line: 0, scope: !32)
!48 = !DILocation(line: 26, column: 28, scope: !32)
!49 = !DILocation(line: 26, column: 42, scope: !32)
!50 = !DILocation(line: 26, column: 21, scope: !32)
!51 = !DILocation(line: 27, column: 22, scope: !32)
!52 = !DILocation(line: 0, scope: !44)
!53 = !DILocation(line: 30, column: 3, scope: !44)
!54 = !DILocation(line: 31, column: 21, scope: !55)
!55 = distinct !DILexicalBlock(scope: !56, file: !12, line: 30, column: 43)
!56 = distinct !DILexicalBlock(scope: !44, file: !12, line: 30, column: 3)
!57 = !DILocation(line: 31, column: 5, scope: !55)
!58 = !DILocation(line: 32, column: 3, scope: !55)
!59 = !DILocation(line: 30, column: 39, scope: !56)
!60 = !DILocation(line: 30, column: 21, scope: !56)
!61 = distinct !{!61, !53, !62, !63, !64}
!62 = !DILocation(line: 32, column: 3, scope: !44)
!63 = !{!"llvm.loop.mustprogress"}
!64 = !{!"llvm.loop.unroll.disable"}
!65 = !DILocation(line: 0, scope: !46)
!66 = !DILocation(line: 35, column: 3, scope: !46)
!67 = !DILocation(line: 36, column: 18, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !12, line: 35, column: 43)
!69 = distinct !DILexicalBlock(scope: !46, file: !12, line: 35, column: 3)
!70 = !{!71, !71, i64 0}
!71 = !{!"long", !29, i64 0}
!72 = !DILocation(line: 36, column: 5, scope: !68)
!73 = !DILocation(line: 37, column: 3, scope: !68)
!74 = !DILocation(line: 35, column: 39, scope: !69)
!75 = !DILocation(line: 35, column: 21, scope: !69)
!76 = distinct !{!76, !66, !77, !63, !64}
!77 = !DILocation(line: 37, column: 3, scope: !46)
!78 = !DILocation(line: 39, column: 3, scope: !32)
!79 = !DILocation(line: 40, column: 3, scope: !32)
!80 = !DILocation(line: 42, column: 3, scope: !32)
!81 = !DISubprogram(name: "malloc", scope: !82, file: !82, line: 672, type: !83, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!83 = !DISubroutineType(types: !84)
!84 = !{!3, !85}
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !86, line: 18, baseType: !41)
!86 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!87 = !DISubprogram(name: "pthread_create", scope: !88, file: !88, line: 202, type: !89, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!88 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!89 = !DISubroutineType(types: !90)
!90 = !{!22, !91, !92, !105, !106}
!91 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !38)
!92 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !93)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !95)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !40, line: 62, baseType: !96)
!96 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !40, line: 56, size: 448, elements: !97)
!97 = !{!98, !103}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !96, file: !40, line: 58, baseType: !99, size: 448)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !100, size: 448, elements: !101)
!100 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!101 = !{!102}
!102 = !DISubrange(count: 56)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !96, file: !40, line: 59, baseType: !104, size: 64)
!104 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!107 = !DISubprogram(name: "pthread_join", scope: !88, file: !88, line: 219, type: !108, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DISubroutineType(types: !109)
!109 = !{!22, !39, !110}
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!111 = !DISubprogram(name: "free", scope: !82, file: !82, line: 687, type: !112, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!112 = !DISubroutineType(types: !113)
!113 = !{null, !3}
