; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/array-index-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@datas = dso_local global ptr null, align 8, !dbg !0

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !17 {
entry:
    #dbg_value(ptr %arg, !21, !DIExpression(), !23)
  %0 = ptrtoint ptr %arg to i32, !dbg !24
    #dbg_value(i32 %0, !22, !DIExpression(), !23)
  %1 = load ptr, ptr @datas, align 8, !dbg !25, !tbaa !26
  %idxprom = sext i32 %0 to i64, !dbg !25
  %arrayidx = getelementptr inbounds i32, ptr %1, i64 %idxprom, !dbg !25
  store i32 4, ptr %arrayidx, align 4, !dbg !31, !tbaa !32
  ret ptr null, !dbg !34
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !35 {
entry:
    #dbg_value(i32 4, !39, !DIExpression(), !49)
  %conv = sext i32 4 to i64, !dbg !50
  %mul = mul i64 %conv, 8, !dbg !51
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !52
    #dbg_value(ptr %call, !40, !DIExpression(), !49)
  %conv1 = sext i32 4 to i64, !dbg !53
  %mul2 = mul i64 %conv1, 4, !dbg !54
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !55
  store ptr %call3, ptr @datas, align 8, !dbg !56, !tbaa !26
    #dbg_value(i32 0, !45, !DIExpression(), !57)
  br label %for.body, !dbg !58

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !45, !DIExpression(), !57)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !59
  %0 = trunc nuw nsw i64 %indvars.iv to i32, !dbg !62
  %div.udiv = udiv i32 %0, 2, !dbg !62
  %conv5 = sext i32 %div.udiv to i64, !dbg !63
  %1 = inttoptr i64 %conv5 to ptr, !dbg !63
  %call6 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %1) #5, !dbg !64
  br label %for.inc, !dbg !65

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !66
    #dbg_value(i64 %indvars.iv.next, !45, !DIExpression(), !57)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !67
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !58, !llvm.loop !68

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !47, !DIExpression(), !72)
  br label %for.body12, !dbg !73

for.cond.cleanup11:                               ; preds = %for.inc16
  br label %for.end18

for.body12:                                       ; preds = %for.end, %for.inc16
  %indvars.iv14 = phi i64 [ 0, %for.end ], [ %indvars.iv.next15, %for.inc16 ]
    #dbg_value(i64 %indvars.iv14, !47, !DIExpression(), !72)
  %arrayidx14 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv14, !dbg !74
  %2 = load i64, ptr %arrayidx14, align 8, !dbg !74, !tbaa !77
  %call15 = call i32 @pthread_join(i64 noundef %2, ptr noundef null), !dbg !79
  br label %for.inc16, !dbg !80

for.inc16:                                        ; preds = %for.body12
  %indvars.iv.next15 = add nuw nsw i64 %indvars.iv14, 1, !dbg !81
    #dbg_value(i64 %indvars.iv.next15, !47, !DIExpression(), !72)
  %exitcond17 = icmp ne i64 %indvars.iv.next15, 4, !dbg !82
  br i1 %exitcond17, label %for.body12, label %for.cond.cleanup11, !dbg !73, !llvm.loop !83

for.end18:                                        ; preds = %for.cond.cleanup11
  call void @free(ptr noundef %call) #5, !dbg !85
  %3 = load ptr, ptr @datas, align 8, !dbg !86, !tbaa !26
  call void @free(ptr noundef %3) #5, !dbg !87
  ret i32 0, !dbg !88
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !89 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !95 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !115 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !119 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13, !14, !15, !16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !8, line: 12, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/array-index-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "dab4ff3ce616f6caf5952f0eb7d2b4dd")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0}
!8 = !DIFile(filename: "array-index-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "dab4ff3ce616f6caf5952f0eb7d2b4dd")
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!10 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!11 = !{i32 7, !"Dwarf Version", i32 5}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{i32 8, !"PIC Level", i32 2}
!15 = !{i32 7, !"PIE Level", i32 2}
!16 = !{i32 7, !"uwtable", i32 2}
!17 = distinct !DISubprogram(name: "thread", scope: !8, file: !8, line: 14, type: !18, scopeLine: 14, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !20)
!18 = !DISubroutineType(types: !19)
!19 = !{!6, !6}
!20 = !{!21, !22}
!21 = !DILocalVariable(name: "arg", arg: 1, scope: !17, file: !8, line: 14, type: !6)
!22 = !DILocalVariable(name: "i", scope: !17, file: !8, line: 15, type: !5)
!23 = !DILocation(line: 0, scope: !17)
!24 = !DILocation(line: 15, column: 11, scope: !17)
!25 = !DILocation(line: 16, column: 3, scope: !17)
!26 = !{!27, !27, i64 0}
!27 = !{!"p1 int", !28, i64 0}
!28 = !{!"any pointer", !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C/C++ TBAA"}
!31 = !DILocation(line: 16, column: 12, scope: !17)
!32 = !{!33, !33, i64 0}
!33 = !{!"int", !29, i64 0}
!34 = !DILocation(line: 17, column: 3, scope: !17)
!35 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 20, type: !36, scopeLine: 20, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !38)
!36 = !DISubroutineType(types: !37)
!37 = !{!5}
!38 = !{!39, !40, !45, !47}
!39 = !DILocalVariable(name: "threads_total", scope: !35, file: !8, line: 21, type: !5)
!40 = !DILocalVariable(name: "tids", scope: !35, file: !8, line: 23, type: !41)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !43, line: 27, baseType: !44)
!43 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!44 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!45 = !DILocalVariable(name: "i", scope: !46, file: !8, line: 27, type: !5)
!46 = distinct !DILexicalBlock(scope: !35, file: !8, line: 27, column: 3)
!47 = !DILocalVariable(name: "i", scope: !48, file: !8, line: 32, type: !5)
!48 = distinct !DILexicalBlock(scope: !35, file: !8, line: 32, column: 3)
!49 = !DILocation(line: 0, scope: !35)
!50 = !DILocation(line: 23, column: 28, scope: !35)
!51 = !DILocation(line: 23, column: 42, scope: !35)
!52 = !DILocation(line: 23, column: 21, scope: !35)
!53 = !DILocation(line: 24, column: 18, scope: !35)
!54 = !DILocation(line: 24, column: 32, scope: !35)
!55 = !DILocation(line: 24, column: 11, scope: !35)
!56 = !DILocation(line: 24, column: 9, scope: !35)
!57 = !DILocation(line: 0, scope: !46)
!58 = !DILocation(line: 27, column: 3, scope: !46)
!59 = !DILocation(line: 28, column: 21, scope: !60)
!60 = distinct !DILexicalBlock(scope: !61, file: !8, line: 27, column: 43)
!61 = distinct !DILexicalBlock(scope: !46, file: !8, line: 27, column: 3)
!62 = !DILocation(line: 28, column: 55, scope: !60)
!63 = !DILocation(line: 28, column: 45, scope: !60)
!64 = !DILocation(line: 28, column: 5, scope: !60)
!65 = !DILocation(line: 29, column: 3, scope: !60)
!66 = !DILocation(line: 27, column: 39, scope: !61)
!67 = !DILocation(line: 27, column: 21, scope: !61)
!68 = distinct !{!68, !58, !69, !70, !71}
!69 = !DILocation(line: 29, column: 3, scope: !46)
!70 = !{!"llvm.loop.mustprogress"}
!71 = !{!"llvm.loop.unroll.disable"}
!72 = !DILocation(line: 0, scope: !48)
!73 = !DILocation(line: 32, column: 3, scope: !48)
!74 = !DILocation(line: 33, column: 18, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !8, line: 32, column: 43)
!76 = distinct !DILexicalBlock(scope: !48, file: !8, line: 32, column: 3)
!77 = !{!78, !78, i64 0}
!78 = !{!"long", !29, i64 0}
!79 = !DILocation(line: 33, column: 5, scope: !75)
!80 = !DILocation(line: 34, column: 3, scope: !75)
!81 = !DILocation(line: 32, column: 39, scope: !76)
!82 = !DILocation(line: 32, column: 21, scope: !76)
!83 = distinct !{!83, !73, !84, !70, !71}
!84 = !DILocation(line: 34, column: 3, scope: !48)
!85 = !DILocation(line: 36, column: 3, scope: !35)
!86 = !DILocation(line: 37, column: 8, scope: !35)
!87 = !DILocation(line: 37, column: 3, scope: !35)
!88 = !DILocation(line: 39, column: 3, scope: !35)
!89 = !DISubprogram(name: "malloc", scope: !90, file: !90, line: 672, type: !91, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!90 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!91 = !DISubroutineType(types: !92)
!92 = !{!6, !93}
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !94, line: 18, baseType: !44)
!94 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!95 = !DISubprogram(name: "pthread_create", scope: !96, file: !96, line: 202, type: !97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!96 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!97 = !DISubroutineType(types: !98)
!98 = !{!5, !99, !100, !113, !114}
!99 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !41)
!100 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !101)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !103)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !43, line: 62, baseType: !104)
!104 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !43, line: 56, size: 448, elements: !105)
!105 = !{!106, !111}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !104, file: !43, line: 58, baseType: !107, size: 448)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !108, size: 448, elements: !109)
!108 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!109 = !{!110}
!110 = !DISubrange(count: 56)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !104, file: !43, line: 59, baseType: !112, size: 64)
!112 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!115 = !DISubprogram(name: "pthread_join", scope: !96, file: !96, line: 219, type: !116, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!116 = !DISubroutineType(types: !117)
!117 = !{!5, !42, !118}
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!119 = !DISubprogram(name: "free", scope: !90, file: !90, line: 687, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!120 = !DISubroutineType(types: !121)
!121 = !{null, !6}
