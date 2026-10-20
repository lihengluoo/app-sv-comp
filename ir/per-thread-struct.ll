; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-struct.linked.bc'
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
  call void @free(ptr noundef %arg) #4, !dbg !31
  ret ptr null, !dbg !32
}

; Function Attrs: nounwind
declare !dbg !33 void @free(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !37 {
entry:
    #dbg_value(i32 4, !41, !DIExpression(), !54)
  %conv = sext i32 4 to i64, !dbg !55
  %mul = mul i64 %conv, 8, !dbg !56
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !57
    #dbg_value(ptr %call, !42, !DIExpression(), !54)
    #dbg_value(i32 0, !47, !DIExpression(), !58)
  br label %for.body, !dbg !59

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !47, !DIExpression(), !58)
  %call2 = call noalias ptr @malloc(i64 noundef 4) #5, !dbg !60
    #dbg_value(ptr %call2, !49, !DIExpression(), !61)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !62
  %call3 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %call2) #4, !dbg !63
  br label %for.inc, !dbg !64

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !65
    #dbg_value(i64 %indvars.iv.next, !47, !DIExpression(), !58)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !66
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !59, !llvm.loop !67

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !52, !DIExpression(), !71)
  br label %for.body9, !dbg !72

for.cond.cleanup8:                                ; preds = %for.inc13
  br label %for.end15

for.body9:                                        ; preds = %for.end, %for.inc13
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc13 ]
    #dbg_value(i64 %indvars.iv12, !52, !DIExpression(), !71)
  %arrayidx11 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !73
  %0 = load i64, ptr %arrayidx11, align 8, !dbg !73, !tbaa !76
  %call12 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !78
  br label %for.inc13, !dbg !79

for.inc13:                                        ; preds = %for.body9
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !80
    #dbg_value(i64 %indvars.iv.next13, !52, !DIExpression(), !71)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !81
  br i1 %exitcond15, label %for.body9, label %for.cond.cleanup8, !dbg !72, !llvm.loop !82

for.end15:                                        ; preds = %for.cond.cleanup8
  call void @free(ptr noundef %call) #4, !dbg !84
  ret i32 0, !dbg !85
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !86 noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare !dbg !91 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !111 i32 @pthread_join(i64 noundef, ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!4}
!llvm.module.flags = !{!5, !6, !7, !8, !9, !10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-struct.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "2c526a76e758519550f57432e6a0b14e")
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
!12 = !DIFile(filename: "per-thread-struct.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "2c526a76e758519550f57432e6a0b14e")
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
!32 = !DILocation(line: 21, column: 3, scope: !11)
!33 = !DISubprogram(name: "free", scope: !34, file: !34, line: 687, type: !35, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!34 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!35 = !DISubroutineType(types: !36)
!36 = !{null, !3}
!37 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 24, type: !38, scopeLine: 24, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !40)
!38 = !DISubroutineType(types: !39)
!39 = !{!22}
!40 = !{!41, !42, !47, !49, !52}
!41 = !DILocalVariable(name: "threads_total", scope: !37, file: !12, line: 25, type: !22)
!42 = !DILocalVariable(name: "tids", scope: !37, file: !12, line: 27, type: !43)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !45, line: 27, baseType: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!46 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!47 = !DILocalVariable(name: "i", scope: !48, file: !12, line: 30, type: !22)
!48 = distinct !DILexicalBlock(scope: !37, file: !12, line: 30, column: 3)
!49 = !DILocalVariable(name: "t", scope: !50, file: !12, line: 31, type: !18)
!50 = distinct !DILexicalBlock(scope: !51, file: !12, line: 30, column: 43)
!51 = distinct !DILexicalBlock(scope: !48, file: !12, line: 30, column: 3)
!52 = !DILocalVariable(name: "i", scope: !53, file: !12, line: 36, type: !22)
!53 = distinct !DILexicalBlock(scope: !37, file: !12, line: 36, column: 3)
!54 = !DILocation(line: 0, scope: !37)
!55 = !DILocation(line: 27, column: 28, scope: !37)
!56 = !DILocation(line: 27, column: 42, scope: !37)
!57 = !DILocation(line: 27, column: 21, scope: !37)
!58 = !DILocation(line: 0, scope: !48)
!59 = !DILocation(line: 30, column: 3, scope: !48)
!60 = !DILocation(line: 31, column: 24, scope: !50)
!61 = !DILocation(line: 0, scope: !50)
!62 = !DILocation(line: 32, column: 21, scope: !50)
!63 = !DILocation(line: 32, column: 5, scope: !50)
!64 = !DILocation(line: 33, column: 3, scope: !50)
!65 = !DILocation(line: 30, column: 39, scope: !51)
!66 = !DILocation(line: 30, column: 21, scope: !51)
!67 = distinct !{!67, !59, !68, !69, !70}
!68 = !DILocation(line: 33, column: 3, scope: !48)
!69 = !{!"llvm.loop.mustprogress"}
!70 = !{!"llvm.loop.unroll.disable"}
!71 = !DILocation(line: 0, scope: !53)
!72 = !DILocation(line: 36, column: 3, scope: !53)
!73 = !DILocation(line: 37, column: 18, scope: !74)
!74 = distinct !DILexicalBlock(scope: !75, file: !12, line: 36, column: 43)
!75 = distinct !DILexicalBlock(scope: !53, file: !12, line: 36, column: 3)
!76 = !{!77, !77, i64 0}
!77 = !{!"long", !29, i64 0}
!78 = !DILocation(line: 37, column: 5, scope: !74)
!79 = !DILocation(line: 38, column: 3, scope: !74)
!80 = !DILocation(line: 36, column: 39, scope: !75)
!81 = !DILocation(line: 36, column: 21, scope: !75)
!82 = distinct !{!82, !72, !83, !69, !70}
!83 = !DILocation(line: 38, column: 3, scope: !53)
!84 = !DILocation(line: 40, column: 3, scope: !37)
!85 = !DILocation(line: 42, column: 3, scope: !37)
!86 = !DISubprogram(name: "malloc", scope: !34, file: !34, line: 672, type: !87, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!87 = !DISubroutineType(types: !88)
!88 = !{!3, !89}
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !90, line: 18, baseType: !46)
!90 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!91 = !DISubprogram(name: "pthread_create", scope: !92, file: !92, line: 202, type: !93, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!92 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!93 = !DISubroutineType(types: !94)
!94 = !{!22, !95, !96, !109, !110}
!95 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !43)
!96 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !97)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !99)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !45, line: 62, baseType: !100)
!100 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !45, line: 56, size: 448, elements: !101)
!101 = !{!102, !107}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !100, file: !45, line: 58, baseType: !103, size: 448)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 448, elements: !105)
!104 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!105 = !{!106}
!106 = !DISubrange(count: 56)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !100, file: !45, line: 59, baseType: !108, size: 64)
!108 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!111 = !DISubprogram(name: "pthread_join", scope: !92, file: !92, line: 219, type: !112, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!112 = !DISubroutineType(types: !113)
!113 = !{!22, !44, !114}
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
