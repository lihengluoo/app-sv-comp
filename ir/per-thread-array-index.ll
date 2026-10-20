; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-index.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@datas = dso_local local_unnamed_addr global ptr null, align 8, !dbg !0

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: write, inaccessiblemem: none) uwtable
define dso_local noalias noundef ptr @thread(ptr noundef %arg) #0 !dbg !18 {
entry:
    #dbg_value(ptr %arg, !22, !DIExpression(), !24)
  %0 = ptrtoint ptr %arg to i64, !dbg !25
    #dbg_value(i64 %0, !23, !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !24)
  %1 = load ptr, ptr @datas, align 8, !dbg !26, !tbaa !27
  %sext = shl i64 %0, 32, !dbg !26
  %2 = ashr exact i64 %sext, 30, !dbg !26
  %arrayidx = getelementptr inbounds i8, ptr %1, i64 %2, !dbg !26
  store i32 4, ptr %arrayidx, align 4, !dbg !32, !tbaa !33
  ret ptr null, !dbg !35
}

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #1 !dbg !36 {
entry:
    #dbg_value(i32 4, !40, !DIExpression(), !50)
  %call = tail call noalias dereferenceable_or_null(32) ptr @malloc(i64 noundef 32) #6, !dbg !51
    #dbg_value(ptr %call, !41, !DIExpression(), !50)
  %call3 = tail call noalias dereferenceable_or_null(16) ptr @malloc(i64 noundef 16) #6, !dbg !52
  store ptr %call3, ptr @datas, align 8, !dbg !53, !tbaa !27
    #dbg_value(i32 0, !46, !DIExpression(), !54)
  br label %for.body, !dbg !55

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
    #dbg_value(i64 %indvars.iv, !46, !DIExpression(), !54)
  %arrayidx = getelementptr inbounds nuw i64, ptr %call, i64 %indvars.iv, !dbg !56
  %0 = inttoptr i64 %indvars.iv to ptr, !dbg !59
  %call6 = tail call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef nonnull @thread, ptr noundef %0) #7, !dbg !60
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !61
    #dbg_value(i64 %indvars.iv.next, !46, !DIExpression(), !54)
  %exitcond.not = icmp eq i64 %indvars.iv.next, 4, !dbg !62
  br i1 %exitcond.not, label %for.body12, label %for.body, !dbg !55, !llvm.loop !63

for.cond.cleanup11:                               ; preds = %for.body12
  tail call void @free(ptr noundef %call) #7, !dbg !67
  %1 = load ptr, ptr @datas, align 8, !dbg !68, !tbaa !27
  tail call void @free(ptr noundef %1) #7, !dbg !69
  ret i32 0, !dbg !70

for.body12:                                       ; preds = %for.body, %for.body12
  %indvars.iv32 = phi i64 [ %indvars.iv.next33, %for.body12 ], [ 0, %for.body ]
    #dbg_value(i64 %indvars.iv32, !48, !DIExpression(), !71)
  %arrayidx14 = getelementptr inbounds nuw i64, ptr %call, i64 %indvars.iv32, !dbg !72
  %2 = load i64, ptr %arrayidx14, align 8, !dbg !72, !tbaa !75
  %call15 = tail call i32 @pthread_join(i64 noundef %2, ptr noundef null) #7, !dbg !77
  %indvars.iv.next33 = add nuw nsw i64 %indvars.iv32, 1, !dbg !78
    #dbg_value(i64 %indvars.iv.next33, !48, !DIExpression(), !71)
  %exitcond35.not = icmp eq i64 %indvars.iv.next33, 4, !dbg !79
  br i1 %exitcond35.not, label %for.cond.cleanup11, label %for.body12, !dbg !80, !llvm.loop !81
}

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare !dbg !83 noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: nounwind
declare !dbg !89 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare !dbg !109 void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

declare !dbg !112 i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #5

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: write, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind allocsize(0) }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13, !14, !15, !16, !17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !8, line: 12, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-index.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "c9f69c4c27b8eb790dbaf635b455649f")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0}
!8 = !DIFile(filename: "per-thread-array-index.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "c9f69c4c27b8eb790dbaf635b455649f")
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!10 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!11 = !{i32 7, !"Dwarf Version", i32 5}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{i32 8, !"PIC Level", i32 2}
!15 = !{i32 7, !"PIE Level", i32 2}
!16 = !{i32 7, !"uwtable", i32 2}
!17 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!18 = distinct !DISubprogram(name: "thread", scope: !8, file: !8, line: 14, type: !19, scopeLine: 14, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !21)
!19 = !DISubroutineType(types: !20)
!20 = !{!6, !6}
!21 = !{!22, !23}
!22 = !DILocalVariable(name: "arg", arg: 1, scope: !18, file: !8, line: 14, type: !6)
!23 = !DILocalVariable(name: "i", scope: !18, file: !8, line: 15, type: !5)
!24 = !DILocation(line: 0, scope: !18)
!25 = !DILocation(line: 15, column: 11, scope: !18)
!26 = !DILocation(line: 16, column: 3, scope: !18)
!27 = !{!28, !28, i64 0}
!28 = !{!"p1 int", !29, i64 0}
!29 = !{!"any pointer", !30, i64 0}
!30 = !{!"omnipotent char", !31, i64 0}
!31 = !{!"Simple C/C++ TBAA"}
!32 = !DILocation(line: 16, column: 12, scope: !18)
!33 = !{!34, !34, i64 0}
!34 = !{!"int", !30, i64 0}
!35 = !DILocation(line: 17, column: 3, scope: !18)
!36 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 20, type: !37, scopeLine: 20, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !39)
!37 = !DISubroutineType(types: !38)
!38 = !{!5}
!39 = !{!40, !41, !46, !48}
!40 = !DILocalVariable(name: "threads_total", scope: !36, file: !8, line: 21, type: !5)
!41 = !DILocalVariable(name: "tids", scope: !36, file: !8, line: 23, type: !42)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !44, line: 27, baseType: !45)
!44 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!45 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!46 = !DILocalVariable(name: "i", scope: !47, file: !8, line: 27, type: !5)
!47 = distinct !DILexicalBlock(scope: !36, file: !8, line: 27, column: 3)
!48 = !DILocalVariable(name: "i", scope: !49, file: !8, line: 32, type: !5)
!49 = distinct !DILexicalBlock(scope: !36, file: !8, line: 32, column: 3)
!50 = !DILocation(line: 0, scope: !36)
!51 = !DILocation(line: 23, column: 21, scope: !36)
!52 = !DILocation(line: 24, column: 11, scope: !36)
!53 = !DILocation(line: 24, column: 9, scope: !36)
!54 = !DILocation(line: 0, scope: !47)
!55 = !DILocation(line: 27, column: 3, scope: !47)
!56 = !DILocation(line: 28, column: 21, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !8, line: 27, column: 43)
!58 = distinct !DILexicalBlock(scope: !47, file: !8, line: 27, column: 3)
!59 = !DILocation(line: 28, column: 45, scope: !57)
!60 = !DILocation(line: 28, column: 5, scope: !57)
!61 = !DILocation(line: 27, column: 39, scope: !58)
!62 = !DILocation(line: 27, column: 21, scope: !58)
!63 = distinct !{!63, !55, !64, !65, !66}
!64 = !DILocation(line: 29, column: 3, scope: !47)
!65 = !{!"llvm.loop.mustprogress"}
!66 = !{!"llvm.loop.unroll.disable"}
!67 = !DILocation(line: 36, column: 3, scope: !36)
!68 = !DILocation(line: 37, column: 8, scope: !36)
!69 = !DILocation(line: 37, column: 3, scope: !36)
!70 = !DILocation(line: 39, column: 3, scope: !36)
!71 = !DILocation(line: 0, scope: !49)
!72 = !DILocation(line: 33, column: 18, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !8, line: 32, column: 43)
!74 = distinct !DILexicalBlock(scope: !49, file: !8, line: 32, column: 3)
!75 = !{!76, !76, i64 0}
!76 = !{!"long", !30, i64 0}
!77 = !DILocation(line: 33, column: 5, scope: !73)
!78 = !DILocation(line: 32, column: 39, scope: !74)
!79 = !DILocation(line: 32, column: 21, scope: !74)
!80 = !DILocation(line: 32, column: 3, scope: !49)
!81 = distinct !{!81, !80, !82, !65, !66}
!82 = !DILocation(line: 34, column: 3, scope: !49)
!83 = !DISubprogram(name: "malloc", scope: !84, file: !84, line: 672, type: !85, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!84 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!85 = !DISubroutineType(types: !86)
!86 = !{!6, !87}
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !88, line: 18, baseType: !45)
!88 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!89 = !DISubprogram(name: "pthread_create", scope: !90, file: !90, line: 202, type: !91, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!90 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!91 = !DISubroutineType(types: !92)
!92 = !{!5, !93, !94, !107, !108}
!93 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !42)
!94 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !95)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !97)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !44, line: 62, baseType: !98)
!98 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !44, line: 56, size: 448, elements: !99)
!99 = !{!100, !105}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !98, file: !44, line: 58, baseType: !101, size: 448)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !102, size: 448, elements: !103)
!102 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!103 = !{!104}
!104 = !DISubrange(count: 56)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !98, file: !44, line: 59, baseType: !106, size: 64)
!106 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!109 = !DISubprogram(name: "free", scope: !84, file: !84, line: 687, type: !110, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!110 = !DISubroutineType(types: !111)
!111 = !{null, !6}
!112 = !DISubprogram(name: "pthread_join", scope: !90, file: !90, line: 219, type: !113, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DISubroutineType(types: !114)
!114 = !{!5, !43, !115}
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
