; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-array-index-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@datas = dso_local local_unnamed_addr global ptr null, align 8, !dbg !0

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: write, inaccessiblemem: none) uwtable
define dso_local noalias noundef ptr @thread(ptr noundef %arg) #0 !dbg !18 {
entry:
    #dbg_value(ptr %arg, !22, !DIExpression(), !24)
  %0 = ptrtoint ptr %arg to i64, !dbg !25
  %1 = trunc i64 %0 to i32, !dbg !25
    #dbg_value(i32 %1, !23, !DIExpression(), !24)
  %div = sdiv i32 %1, 2, !dbg !26
    #dbg_value(i32 %div, !23, !DIExpression(), !24)
  %2 = load ptr, ptr @datas, align 8, !dbg !27, !tbaa !28
  %idxprom = sext i32 %div to i64, !dbg !27
  %arrayidx = getelementptr inbounds i32, ptr %2, i64 %idxprom, !dbg !27
  store i32 4, ptr %arrayidx, align 4, !dbg !33, !tbaa !34
  ret ptr null, !dbg !36
}

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #1 !dbg !37 {
entry:
    #dbg_value(i32 4, !41, !DIExpression(), !51)
  %call = tail call noalias dereferenceable_or_null(32) ptr @malloc(i64 noundef 32) #6, !dbg !52
    #dbg_value(ptr %call, !42, !DIExpression(), !51)
  %call3 = tail call noalias dereferenceable_or_null(16) ptr @malloc(i64 noundef 16) #6, !dbg !53
  store ptr %call3, ptr @datas, align 8, !dbg !54, !tbaa !28
    #dbg_value(i32 0, !47, !DIExpression(), !55)
  br label %for.body, !dbg !56

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
    #dbg_value(i64 %indvars.iv, !47, !DIExpression(), !55)
  %arrayidx = getelementptr inbounds nuw i64, ptr %call, i64 %indvars.iv, !dbg !57
  %0 = inttoptr i64 %indvars.iv to ptr, !dbg !60
  %call6 = tail call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef nonnull @thread, ptr noundef %0) #7, !dbg !61
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !62
    #dbg_value(i64 %indvars.iv.next, !47, !DIExpression(), !55)
  %exitcond.not = icmp eq i64 %indvars.iv.next, 4, !dbg !63
  br i1 %exitcond.not, label %for.body12, label %for.body, !dbg !56, !llvm.loop !64

for.cond.cleanup11:                               ; preds = %for.body12
  tail call void @free(ptr noundef %call) #7, !dbg !68
  %1 = load ptr, ptr @datas, align 8, !dbg !69, !tbaa !28
  tail call void @free(ptr noundef %1) #7, !dbg !70
  ret i32 0, !dbg !71

for.body12:                                       ; preds = %for.body, %for.body12
  %indvars.iv32 = phi i64 [ %indvars.iv.next33, %for.body12 ], [ 0, %for.body ]
    #dbg_value(i64 %indvars.iv32, !49, !DIExpression(), !72)
  %arrayidx14 = getelementptr inbounds nuw i64, ptr %call, i64 %indvars.iv32, !dbg !73
  %2 = load i64, ptr %arrayidx14, align 8, !dbg !73, !tbaa !76
  %call15 = tail call i32 @pthread_join(i64 noundef %2, ptr noundef null) #7, !dbg !78
  %indvars.iv.next33 = add nuw nsw i64 %indvars.iv32, 1, !dbg !79
    #dbg_value(i64 %indvars.iv.next33, !49, !DIExpression(), !72)
  %exitcond35.not = icmp eq i64 %indvars.iv.next33, 4, !dbg !80
  br i1 %exitcond35.not, label %for.cond.cleanup11, label %for.body12, !dbg !81, !llvm.loop !82
}

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare !dbg !84 noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: nounwind
declare !dbg !90 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare !dbg !110 void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

declare !dbg !113 i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #5

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
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-array-index-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "3ba37c2c753fe2236a7c7a83d5bb31df")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0}
!8 = !DIFile(filename: "per-thread-array-index-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "3ba37c2c753fe2236a7c7a83d5bb31df")
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
!26 = !DILocation(line: 16, column: 5, scope: !18)
!27 = !DILocation(line: 17, column: 3, scope: !18)
!28 = !{!29, !29, i64 0}
!29 = !{!"p1 int", !30, i64 0}
!30 = !{!"any pointer", !31, i64 0}
!31 = !{!"omnipotent char", !32, i64 0}
!32 = !{!"Simple C/C++ TBAA"}
!33 = !DILocation(line: 17, column: 12, scope: !18)
!34 = !{!35, !35, i64 0}
!35 = !{!"int", !31, i64 0}
!36 = !DILocation(line: 18, column: 3, scope: !18)
!37 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 21, type: !38, scopeLine: 21, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !40)
!38 = !DISubroutineType(types: !39)
!39 = !{!5}
!40 = !{!41, !42, !47, !49}
!41 = !DILocalVariable(name: "threads_total", scope: !37, file: !8, line: 22, type: !5)
!42 = !DILocalVariable(name: "tids", scope: !37, file: !8, line: 24, type: !43)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 27, baseType: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!46 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!47 = !DILocalVariable(name: "i", scope: !48, file: !8, line: 28, type: !5)
!48 = distinct !DILexicalBlock(scope: !37, file: !8, line: 28, column: 3)
!49 = !DILocalVariable(name: "i", scope: !50, file: !8, line: 33, type: !5)
!50 = distinct !DILexicalBlock(scope: !37, file: !8, line: 33, column: 3)
!51 = !DILocation(line: 0, scope: !37)
!52 = !DILocation(line: 24, column: 21, scope: !37)
!53 = !DILocation(line: 25, column: 11, scope: !37)
!54 = !DILocation(line: 25, column: 9, scope: !37)
!55 = !DILocation(line: 0, scope: !48)
!56 = !DILocation(line: 28, column: 3, scope: !48)
!57 = !DILocation(line: 29, column: 21, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !8, line: 28, column: 43)
!59 = distinct !DILexicalBlock(scope: !48, file: !8, line: 28, column: 3)
!60 = !DILocation(line: 29, column: 45, scope: !58)
!61 = !DILocation(line: 29, column: 5, scope: !58)
!62 = !DILocation(line: 28, column: 39, scope: !59)
!63 = !DILocation(line: 28, column: 21, scope: !59)
!64 = distinct !{!64, !56, !65, !66, !67}
!65 = !DILocation(line: 30, column: 3, scope: !48)
!66 = !{!"llvm.loop.mustprogress"}
!67 = !{!"llvm.loop.unroll.disable"}
!68 = !DILocation(line: 37, column: 3, scope: !37)
!69 = !DILocation(line: 38, column: 8, scope: !37)
!70 = !DILocation(line: 38, column: 3, scope: !37)
!71 = !DILocation(line: 40, column: 3, scope: !37)
!72 = !DILocation(line: 0, scope: !50)
!73 = !DILocation(line: 34, column: 18, scope: !74)
!74 = distinct !DILexicalBlock(scope: !75, file: !8, line: 33, column: 43)
!75 = distinct !DILexicalBlock(scope: !50, file: !8, line: 33, column: 3)
!76 = !{!77, !77, i64 0}
!77 = !{!"long", !31, i64 0}
!78 = !DILocation(line: 34, column: 5, scope: !74)
!79 = !DILocation(line: 33, column: 39, scope: !75)
!80 = !DILocation(line: 33, column: 21, scope: !75)
!81 = !DILocation(line: 33, column: 3, scope: !50)
!82 = distinct !{!82, !81, !83, !66, !67}
!83 = !DILocation(line: 35, column: 3, scope: !50)
!84 = !DISubprogram(name: "malloc", scope: !85, file: !85, line: 672, type: !86, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!85 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!86 = !DISubroutineType(types: !87)
!87 = !{!6, !88}
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !89, line: 18, baseType: !46)
!89 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!90 = !DISubprogram(name: "pthread_create", scope: !91, file: !91, line: 202, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!92 = !DISubroutineType(types: !93)
!93 = !{!5, !94, !95, !108, !109}
!94 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !43)
!95 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !96)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !98)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !45, line: 62, baseType: !99)
!99 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !45, line: 56, size: 448, elements: !100)
!100 = !{!101, !106}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !99, file: !45, line: 58, baseType: !102, size: 448)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !103, size: 448, elements: !104)
!103 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!104 = !{!105}
!105 = !DISubrange(count: 56)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !99, file: !45, line: 59, baseType: !107, size: 64)
!107 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!110 = !DISubprogram(name: "free", scope: !85, file: !85, line: 687, type: !111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DISubroutineType(types: !112)
!112 = !{null, !6}
!113 = !DISubprogram(name: "pthread_join", scope: !91, file: !91, line: 219, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!114 = !DISubroutineType(types: !115)
!115 = !{!5, !44, !116}
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
