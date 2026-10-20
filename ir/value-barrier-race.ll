; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/value-barrier-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@ready = dso_local global i8 0, align 1, !dbg !0
@data = dso_local global i32 0, align 4, !dbg !7

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !19 {
entry:
    #dbg_value(ptr %arg, !23, !DIExpression(), !25)
  br label %while.cond, !dbg !26

while.cond:                                       ; preds = %while.cond, %entry
  %0 = load i8, ptr @ready, align 1, !dbg !27, !tbaa !28, !range !32, !noundef !33
  %loadedv = trunc i8 %0 to i1, !dbg !27
  %lnot = xor i1 %loadedv, true, !dbg !34
  br i1 %lnot, label %while.cond, label %while.end, !dbg !26, !llvm.loop !35

while.end:                                        ; preds = %while.cond
  %1 = load i32, ptr @data, align 4, !dbg !39, !tbaa !40
    #dbg_value(i32 %1, !24, !DIExpression(), !25)
  ret ptr null, !dbg !42
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !43 {
entry:
    #dbg_value(i32 4, !47, !DIExpression(), !57)
  %conv = sext i32 4 to i64, !dbg !58
  %mul = mul i64 %conv, 8, !dbg !59
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !60
    #dbg_value(ptr %call, !48, !DIExpression(), !57)
    #dbg_value(i32 0, !53, !DIExpression(), !61)
  br label %for.body, !dbg !62

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !53, !DIExpression(), !61)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !63
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #5, !dbg !66
  br label %for.inc, !dbg !67

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !68
    #dbg_value(i64 %indvars.iv.next, !53, !DIExpression(), !61)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !69
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !62, !llvm.loop !70

for.end:                                          ; preds = %for.cond.cleanup
  store i32 4, ptr @data, align 4, !dbg !72, !tbaa !40
  store i8 1, ptr @ready, align 1, !dbg !73, !tbaa !28
    #dbg_value(i32 0, !55, !DIExpression(), !74)
  br label %for.body8, !dbg !75

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !55, !DIExpression(), !74)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !76
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !76, !tbaa !79
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !81
  br label %for.inc12, !dbg !82

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !83
    #dbg_value(i64 %indvars.iv.next13, !55, !DIExpression(), !74)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !84
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !75, !llvm.loop !85

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #5, !dbg !87
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
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "ready", scope: !2, file: !9, line: 14, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/value-barrier-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "ca313a600536eac67e4c97d7653cae98")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "value-barrier-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "ca313a600536eac67e4c97d7653cae98")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!12 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 8, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 2}
!19 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 17, type: !20, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !22)
!20 = !DISubroutineType(types: !21)
!21 = !{!5, !5}
!22 = !{!23, !24}
!23 = !DILocalVariable(name: "arg", arg: 1, scope: !19, file: !9, line: 17, type: !5)
!24 = !DILocalVariable(name: "x", scope: !19, file: !9, line: 21, type: !10)
!25 = !DILocation(line: 0, scope: !19)
!26 = !DILocation(line: 19, column: 3, scope: !19)
!27 = !DILocation(line: 19, column: 11, scope: !19)
!28 = !{!29, !29, i64 0}
!29 = !{!"_Bool", !30, i64 0}
!30 = !{!"omnipotent char", !31, i64 0}
!31 = !{!"Simple C/C++ TBAA"}
!32 = !{i8 0, i8 2}
!33 = !{}
!34 = !DILocation(line: 19, column: 10, scope: !19)
!35 = distinct !{!35, !26, !36, !37, !38}
!36 = !DILocation(line: 19, column: 17, scope: !19)
!37 = !{!"llvm.loop.mustprogress"}
!38 = !{!"llvm.loop.unroll.disable"}
!39 = !DILocation(line: 21, column: 11, scope: !19)
!40 = !{!41, !41, i64 0}
!41 = !{!"int", !30, i64 0}
!42 = !DILocation(line: 22, column: 3, scope: !19)
!43 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 25, type: !44, scopeLine: 25, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !46)
!44 = !DISubroutineType(types: !45)
!45 = !{!10}
!46 = !{!47, !48, !53, !55}
!47 = !DILocalVariable(name: "threads_total", scope: !43, file: !9, line: 26, type: !10)
!48 = !DILocalVariable(name: "tids", scope: !43, file: !9, line: 28, type: !49)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !51, line: 27, baseType: !52)
!51 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!52 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!53 = !DILocalVariable(name: "i", scope: !54, file: !9, line: 31, type: !10)
!54 = distinct !DILexicalBlock(scope: !43, file: !9, line: 31, column: 3)
!55 = !DILocalVariable(name: "i", scope: !56, file: !9, line: 41, type: !10)
!56 = distinct !DILexicalBlock(scope: !43, file: !9, line: 41, column: 3)
!57 = !DILocation(line: 0, scope: !43)
!58 = !DILocation(line: 28, column: 28, scope: !43)
!59 = !DILocation(line: 28, column: 42, scope: !43)
!60 = !DILocation(line: 28, column: 21, scope: !43)
!61 = !DILocation(line: 0, scope: !54)
!62 = !DILocation(line: 31, column: 3, scope: !54)
!63 = !DILocation(line: 32, column: 21, scope: !64)
!64 = distinct !DILexicalBlock(scope: !65, file: !9, line: 31, column: 43)
!65 = distinct !DILexicalBlock(scope: !54, file: !9, line: 31, column: 3)
!66 = !DILocation(line: 32, column: 5, scope: !64)
!67 = !DILocation(line: 33, column: 3, scope: !64)
!68 = !DILocation(line: 31, column: 39, scope: !65)
!69 = !DILocation(line: 31, column: 21, scope: !65)
!70 = distinct !{!70, !62, !71, !37, !38}
!71 = !DILocation(line: 33, column: 3, scope: !54)
!72 = !DILocation(line: 35, column: 8, scope: !43)
!73 = !DILocation(line: 38, column: 9, scope: !43)
!74 = !DILocation(line: 0, scope: !56)
!75 = !DILocation(line: 41, column: 3, scope: !56)
!76 = !DILocation(line: 42, column: 18, scope: !77)
!77 = distinct !DILexicalBlock(scope: !78, file: !9, line: 41, column: 43)
!78 = distinct !DILexicalBlock(scope: !56, file: !9, line: 41, column: 3)
!79 = !{!80, !80, i64 0}
!80 = !{!"long", !30, i64 0}
!81 = !DILocation(line: 42, column: 5, scope: !77)
!82 = !DILocation(line: 43, column: 3, scope: !77)
!83 = !DILocation(line: 41, column: 39, scope: !78)
!84 = !DILocation(line: 41, column: 21, scope: !78)
!85 = distinct !{!85, !75, !86, !37, !38}
!86 = !DILocation(line: 43, column: 3, scope: !56)
!87 = !DILocation(line: 45, column: 3, scope: !43)
!88 = !DILocation(line: 47, column: 3, scope: !43)
!89 = !DISubprogram(name: "malloc", scope: !90, file: !90, line: 672, type: !91, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!90 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!91 = !DISubroutineType(types: !92)
!92 = !{!5, !93}
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !94, line: 18, baseType: !52)
!94 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!95 = !DISubprogram(name: "pthread_create", scope: !96, file: !96, line: 202, type: !97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!96 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!97 = !DISubroutineType(types: !98)
!98 = !{!10, !99, !100, !113, !114}
!99 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !49)
!100 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !101)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !103)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !51, line: 62, baseType: !104)
!104 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !51, line: 56, size: 448, elements: !105)
!105 = !{!106, !111}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !104, file: !51, line: 58, baseType: !107, size: 448)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !108, size: 448, elements: !109)
!108 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!109 = !{!110}
!110 = !DISubrange(count: 56)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !104, file: !51, line: 59, baseType: !112, size: 64)
!112 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!115 = !DISubprogram(name: "pthread_join", scope: !96, file: !96, line: 219, type: !116, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!116 = !DISubroutineType(types: !117)
!117 = !{!10, !50, !118}
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!119 = !DISubprogram(name: "free", scope: !90, file: !90, line: 687, type: !120, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!120 = !DISubroutineType(types: !121)
!121 = !{null, !5}
