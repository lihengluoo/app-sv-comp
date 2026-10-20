; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/atomic.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@data = dso_local global i32 0, align 4, !dbg !0

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !16 {
entry:
    #dbg_value(ptr %arg, !20, !DIExpression(), !21)
  %0 = atomicrmw add ptr @data, i32 1 seq_cst, align 4, !dbg !22
  ret ptr null, !dbg !23
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !24 {
entry:
    #dbg_value(i32 4, !28, !DIExpression(), !38)
  %conv = sext i32 4 to i64, !dbg !39
  %mul = mul i64 %conv, 8, !dbg !40
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !41
    #dbg_value(ptr %call, !29, !DIExpression(), !38)
    #dbg_value(i32 0, !34, !DIExpression(), !42)
  br label %for.body, !dbg !43

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !34, !DIExpression(), !42)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !44
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #5, !dbg !47
  br label %for.inc, !dbg !48

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !49
    #dbg_value(i64 %indvars.iv.next, !34, !DIExpression(), !42)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !50
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !43, !llvm.loop !51

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !36, !DIExpression(), !55)
  br label %for.body8, !dbg !56

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !36, !DIExpression(), !55)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !57
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !57, !tbaa !60
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !64
  br label %for.inc12, !dbg !65

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !66
    #dbg_value(i64 %indvars.iv.next13, !36, !DIExpression(), !55)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !67
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !56, !llvm.loop !68

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #5, !dbg !70
  ret i32 0, !dbg !71
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !72 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !78 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !98 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !102 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!9}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !7, line: 16, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/atomic.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "e50de309127c85b8521eaeff0687a336")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0}
!7 = !DIFile(filename: "atomic.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "e50de309127c85b8521eaeff0687a336")
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!10 = !{i32 7, !"Dwarf Version", i32 5}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 8, !"PIC Level", i32 2}
!14 = !{i32 7, !"PIE Level", i32 2}
!15 = !{i32 7, !"uwtable", i32 2}
!16 = distinct !DISubprogram(name: "thread", scope: !7, file: !7, line: 18, type: !17, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{!5, !5}
!19 = !{!20}
!20 = !DILocalVariable(name: "arg", arg: 1, scope: !16, file: !7, line: 18, type: !5)
!21 = !DILocation(line: 0, scope: !16)
!22 = !DILocation(line: 19, column: 3, scope: !16)
!23 = !DILocation(line: 20, column: 3, scope: !16)
!24 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 23, type: !25, scopeLine: 23, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !27)
!25 = !DISubroutineType(types: !26)
!26 = !{!8}
!27 = !{!28, !29, !34, !36}
!28 = !DILocalVariable(name: "threads_total", scope: !24, file: !7, line: 24, type: !8)
!29 = !DILocalVariable(name: "tids", scope: !24, file: !7, line: 26, type: !30)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !32, line: 27, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!33 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocalVariable(name: "i", scope: !35, file: !7, line: 29, type: !8)
!35 = distinct !DILexicalBlock(scope: !24, file: !7, line: 29, column: 3)
!36 = !DILocalVariable(name: "i", scope: !37, file: !7, line: 34, type: !8)
!37 = distinct !DILexicalBlock(scope: !24, file: !7, line: 34, column: 3)
!38 = !DILocation(line: 0, scope: !24)
!39 = !DILocation(line: 26, column: 28, scope: !24)
!40 = !DILocation(line: 26, column: 42, scope: !24)
!41 = !DILocation(line: 26, column: 21, scope: !24)
!42 = !DILocation(line: 0, scope: !35)
!43 = !DILocation(line: 29, column: 3, scope: !35)
!44 = !DILocation(line: 30, column: 21, scope: !45)
!45 = distinct !DILexicalBlock(scope: !46, file: !7, line: 29, column: 43)
!46 = distinct !DILexicalBlock(scope: !35, file: !7, line: 29, column: 3)
!47 = !DILocation(line: 30, column: 5, scope: !45)
!48 = !DILocation(line: 31, column: 3, scope: !45)
!49 = !DILocation(line: 29, column: 39, scope: !46)
!50 = !DILocation(line: 29, column: 21, scope: !46)
!51 = distinct !{!51, !43, !52, !53, !54}
!52 = !DILocation(line: 31, column: 3, scope: !35)
!53 = !{!"llvm.loop.mustprogress"}
!54 = !{!"llvm.loop.unroll.disable"}
!55 = !DILocation(line: 0, scope: !37)
!56 = !DILocation(line: 34, column: 3, scope: !37)
!57 = !DILocation(line: 35, column: 18, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !7, line: 34, column: 43)
!59 = distinct !DILexicalBlock(scope: !37, file: !7, line: 34, column: 3)
!60 = !{!61, !61, i64 0}
!61 = !{!"long", !62, i64 0}
!62 = !{!"omnipotent char", !63, i64 0}
!63 = !{!"Simple C/C++ TBAA"}
!64 = !DILocation(line: 35, column: 5, scope: !58)
!65 = !DILocation(line: 36, column: 3, scope: !58)
!66 = !DILocation(line: 34, column: 39, scope: !59)
!67 = !DILocation(line: 34, column: 21, scope: !59)
!68 = distinct !{!68, !56, !69, !53, !54}
!69 = !DILocation(line: 36, column: 3, scope: !37)
!70 = !DILocation(line: 38, column: 3, scope: !24)
!71 = !DILocation(line: 40, column: 3, scope: !24)
!72 = !DISubprogram(name: "malloc", scope: !73, file: !73, line: 672, type: !74, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!73 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!74 = !DISubroutineType(types: !75)
!75 = !{!5, !76}
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !77, line: 18, baseType: !33)
!77 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!78 = !DISubprogram(name: "pthread_create", scope: !79, file: !79, line: 202, type: !80, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!79 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!80 = !DISubroutineType(types: !81)
!81 = !{!8, !82, !83, !96, !97}
!82 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !30)
!83 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !84)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !86)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !32, line: 62, baseType: !87)
!87 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !32, line: 56, size: 448, elements: !88)
!88 = !{!89, !94}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !87, file: !32, line: 58, baseType: !90, size: 448)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 448, elements: !92)
!91 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!92 = !{!93}
!93 = !DISubrange(count: 56)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !87, file: !32, line: 59, baseType: !95, size: 64)
!95 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!98 = !DISubprogram(name: "pthread_join", scope: !79, file: !79, line: 219, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!99 = !DISubroutineType(types: !100)
!100 = !{!8, !31, !101}
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!102 = !DISubprogram(name: "free", scope: !73, file: !73, line: 687, type: !103, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!103 = !DISubroutineType(types: !104)
!104 = !{null, !5}
