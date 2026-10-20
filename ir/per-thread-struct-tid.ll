; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-struct-tid.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.thread = type { i64, i32 }

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !11 {
entry:
    #dbg_value(ptr %arg, !16, !DIExpression(), !27)
    #dbg_value(ptr %arg, !17, !DIExpression(), !27)
  %data = getelementptr inbounds nuw %struct.thread, ptr %arg, i32 0, i32 1, !dbg !28
  store i32 4, ptr %data, align 8, !dbg !29, !tbaa !30
  ret ptr null, !dbg !36
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !37 {
entry:
    #dbg_value(i32 4, !41, !DIExpression(), !51)
  %conv = sext i32 4 to i64, !dbg !52
  %mul = mul i64 %conv, 8, !dbg !53
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !54
    #dbg_value(ptr %call, !42, !DIExpression(), !51)
    #dbg_value(i32 0, !44, !DIExpression(), !55)
  br label %for.body, !dbg !56

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !44, !DIExpression(), !55)
  %call2 = call noalias ptr @malloc(i64 noundef 16) #4, !dbg !57
    #dbg_value(ptr %call2, !46, !DIExpression(), !58)
  %arrayidx = getelementptr inbounds ptr, ptr %call, i64 %indvars.iv, !dbg !59
  store ptr %call2, ptr %arrayidx, align 8, !dbg !60, !tbaa !61
  %tid = getelementptr inbounds nuw %struct.thread, ptr %call2, i32 0, i32 0, !dbg !64
  %call3 = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef %call2) #5, !dbg !65
  br label %for.inc, !dbg !66

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !67
    #dbg_value(i64 %indvars.iv.next, !44, !DIExpression(), !55)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !68
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !56, !llvm.loop !69

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !49, !DIExpression(), !73)
  br label %for.body9, !dbg !74

for.cond.cleanup8:                                ; preds = %for.inc16
  br label %for.end18

for.body9:                                        ; preds = %for.end, %for.inc16
  %indvars.iv16 = phi i64 [ 0, %for.end ], [ %indvars.iv.next17, %for.inc16 ]
    #dbg_value(i64 %indvars.iv16, !49, !DIExpression(), !73)
  %arrayidx11 = getelementptr inbounds ptr, ptr %call, i64 %indvars.iv16, !dbg !75
  %0 = load ptr, ptr %arrayidx11, align 8, !dbg !75, !tbaa !61
  %tid12 = getelementptr inbounds nuw %struct.thread, ptr %0, i32 0, i32 0, !dbg !78
  %1 = load i64, ptr %tid12, align 8, !dbg !78, !tbaa !79
  %call13 = call i32 @pthread_join(i64 noundef %1, ptr noundef null), !dbg !80
  %arrayidx15 = getelementptr inbounds ptr, ptr %call, i64 %indvars.iv16, !dbg !81
  %2 = load ptr, ptr %arrayidx15, align 8, !dbg !81, !tbaa !61
  call void @free(ptr noundef %2) #5, !dbg !82
  br label %for.inc16, !dbg !83

for.inc16:                                        ; preds = %for.body9
  %indvars.iv.next17 = add nuw nsw i64 %indvars.iv16, 1, !dbg !84
    #dbg_value(i64 %indvars.iv.next17, !49, !DIExpression(), !73)
  %exitcond19 = icmp ne i64 %indvars.iv.next17, 4, !dbg !85
  br i1 %exitcond19, label %for.body9, label %for.cond.cleanup8, !dbg !74, !llvm.loop !86

for.end18:                                        ; preds = %for.cond.cleanup8
  call void @free(ptr noundef %call) #5, !dbg !88
  ret i32 0, !dbg !89
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !90 noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare !dbg !96 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !117 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !121 void @free(ptr noundef) #2

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
!1 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-struct-tid.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "bbe0258a2b00b5f66fbf1c8ba85bcc6c")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!4 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!5 = !{i32 7, !"Dwarf Version", i32 5}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 8, !"PIC Level", i32 2}
!9 = !{i32 7, !"PIE Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 2}
!11 = distinct !DISubprogram(name: "thread", scope: !12, file: !12, line: 18, type: !13, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !15)
!12 = !DIFile(filename: "per-thread-struct-tid.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "bbe0258a2b00b5f66fbf1c8ba85bcc6c")
!13 = !DISubroutineType(types: !14)
!14 = !{!3, !3}
!15 = !{!16, !17}
!16 = !DILocalVariable(name: "arg", arg: 1, scope: !11, file: !12, line: 18, type: !3)
!17 = !DILocalVariable(name: "t", scope: !11, file: !12, line: 19, type: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "thread", file: !12, line: 13, size: 128, elements: !20)
!20 = !{!21, !25}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "tid", scope: !19, file: !12, line: 14, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !23, line: 27, baseType: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!24 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !19, file: !12, line: 15, baseType: !26, size: 32, offset: 64)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DILocation(line: 0, scope: !11)
!28 = !DILocation(line: 20, column: 6, scope: !11)
!29 = !DILocation(line: 20, column: 11, scope: !11)
!30 = !{!31, !35, i64 8}
!31 = !{!"thread", !32, i64 0, !35, i64 8}
!32 = !{!"long", !33, i64 0}
!33 = !{!"omnipotent char", !34, i64 0}
!34 = !{!"Simple C/C++ TBAA"}
!35 = !{!"int", !33, i64 0}
!36 = !DILocation(line: 21, column: 3, scope: !11)
!37 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 24, type: !38, scopeLine: 24, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !40)
!38 = !DISubroutineType(types: !39)
!39 = !{!26}
!40 = !{!41, !42, !44, !46, !49}
!41 = !DILocalVariable(name: "threads_total", scope: !37, file: !12, line: 25, type: !26)
!42 = !DILocalVariable(name: "ts", scope: !37, file: !12, line: 27, type: !43)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!44 = !DILocalVariable(name: "i", scope: !45, file: !12, line: 30, type: !26)
!45 = distinct !DILexicalBlock(scope: !37, file: !12, line: 30, column: 3)
!46 = !DILocalVariable(name: "t", scope: !47, file: !12, line: 31, type: !18)
!47 = distinct !DILexicalBlock(scope: !48, file: !12, line: 30, column: 43)
!48 = distinct !DILexicalBlock(scope: !45, file: !12, line: 30, column: 3)
!49 = !DILocalVariable(name: "i", scope: !50, file: !12, line: 37, type: !26)
!50 = distinct !DILexicalBlock(scope: !37, file: !12, line: 37, column: 3)
!51 = !DILocation(line: 0, scope: !37)
!52 = !DILocation(line: 27, column: 31, scope: !37)
!53 = !DILocation(line: 27, column: 45, scope: !37)
!54 = !DILocation(line: 27, column: 24, scope: !37)
!55 = !DILocation(line: 0, scope: !45)
!56 = !DILocation(line: 30, column: 3, scope: !45)
!57 = !DILocation(line: 31, column: 24, scope: !47)
!58 = !DILocation(line: 0, scope: !47)
!59 = !DILocation(line: 32, column: 5, scope: !47)
!60 = !DILocation(line: 32, column: 11, scope: !47)
!61 = !{!62, !62, i64 0}
!62 = !{!"p1 _ZTS6thread", !63, i64 0}
!63 = !{!"any pointer", !33, i64 0}
!64 = !DILocation(line: 33, column: 24, scope: !47)
!65 = !DILocation(line: 33, column: 5, scope: !47)
!66 = !DILocation(line: 34, column: 3, scope: !47)
!67 = !DILocation(line: 30, column: 39, scope: !48)
!68 = !DILocation(line: 30, column: 21, scope: !48)
!69 = distinct !{!69, !56, !70, !71, !72}
!70 = !DILocation(line: 34, column: 3, scope: !45)
!71 = !{!"llvm.loop.mustprogress"}
!72 = !{!"llvm.loop.unroll.disable"}
!73 = !DILocation(line: 0, scope: !50)
!74 = !DILocation(line: 37, column: 3, scope: !50)
!75 = !DILocation(line: 38, column: 18, scope: !76)
!76 = distinct !DILexicalBlock(scope: !77, file: !12, line: 37, column: 43)
!77 = distinct !DILexicalBlock(scope: !50, file: !12, line: 37, column: 3)
!78 = !DILocation(line: 38, column: 25, scope: !76)
!79 = !{!31, !32, i64 0}
!80 = !DILocation(line: 38, column: 5, scope: !76)
!81 = !DILocation(line: 39, column: 10, scope: !76)
!82 = !DILocation(line: 39, column: 5, scope: !76)
!83 = !DILocation(line: 40, column: 3, scope: !76)
!84 = !DILocation(line: 37, column: 39, scope: !77)
!85 = !DILocation(line: 37, column: 21, scope: !77)
!86 = distinct !{!86, !74, !87, !71, !72}
!87 = !DILocation(line: 40, column: 3, scope: !50)
!88 = !DILocation(line: 42, column: 3, scope: !37)
!89 = !DILocation(line: 44, column: 3, scope: !37)
!90 = !DISubprogram(name: "malloc", scope: !91, file: !91, line: 672, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!92 = !DISubroutineType(types: !93)
!93 = !{!3, !94}
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !95, line: 18, baseType: !24)
!95 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!96 = !DISubprogram(name: "pthread_create", scope: !97, file: !97, line: 202, type: !98, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!97 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!98 = !DISubroutineType(types: !99)
!99 = !{!26, !100, !102, !115, !116}
!100 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !101)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !103)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !105)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !23, line: 62, baseType: !106)
!106 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !23, line: 56, size: 448, elements: !107)
!107 = !{!108, !113}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !106, file: !23, line: 58, baseType: !109, size: 448)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !110, size: 448, elements: !111)
!110 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!111 = !{!112}
!112 = !DISubrange(count: 56)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !106, file: !23, line: 59, baseType: !114, size: 64)
!114 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !3)
!117 = !DISubprogram(name: "pthread_join", scope: !97, file: !97, line: 219, type: !118, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!118 = !DISubroutineType(types: !119)
!119 = !{!26, !22, !120}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!121 = !DISubprogram(name: "free", scope: !91, file: !91, line: 687, type: !122, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!122 = !DISubroutineType(types: !123)
!123 = !{null, !3}
