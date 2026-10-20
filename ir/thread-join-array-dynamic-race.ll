; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-array-dynamic-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@data = dso_local global i32 0, align 4, !dbg !0
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !50 {
entry:
    #dbg_value(ptr %arg, !54, !DIExpression(), !55)
  %call = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #4, !dbg !56
  store i32 4, ptr @data, align 4, !dbg !57, !tbaa !58
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #4, !dbg !62
  ret ptr null, !dbg !63
}

; Function Attrs: nounwind
declare !dbg !64 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !69 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !70 {
entry:
    #dbg_value(i32 4, !74, !DIExpression(), !83)
  %conv = sext i32 4 to i64, !dbg !84
  %mul = mul i64 %conv, 8, !dbg !85
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !86
    #dbg_value(ptr %call, !75, !DIExpression(), !83)
    #dbg_value(i32 0, !79, !DIExpression(), !87)
  br label %for.body, !dbg !88

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !79, !DIExpression(), !87)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !89
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !92
  br label %for.inc, !dbg !93

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !94
    #dbg_value(i64 %indvars.iv.next, !79, !DIExpression(), !87)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !95
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !88, !llvm.loop !96

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !81, !DIExpression(), !100)
  br label %for.body8, !dbg !101

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !81, !DIExpression(), !100)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !102
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !102, !tbaa !105
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !107
  br label %for.inc12, !dbg !108

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !109
    #dbg_value(i64 %indvars.iv.next13, !81, !DIExpression(), !100)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 3, !dbg !110
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !101, !llvm.loop !111

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #4, !dbg !113
  %1 = load i32, ptr @data, align 4, !dbg !114, !tbaa !58
  ret i32 %1, !dbg !115
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !116 noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare !dbg !122 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !139 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !143 void @free(ptr noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!43}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 14, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-array-dynamic-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "d5c070b386e9ecb112c68f8eef9664b9")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-join-array-dynamic-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "d5c070b386e9ecb112c68f8eef9664b9")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !11, line: 72, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!12 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 67, size: 320, elements: !13)
!13 = !{!14, !36, !41}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !12, file: !11, line: 69, baseType: !15, size: 320)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !16, line: 22, size: 320, elements: !17)
!16 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!17 = !{!18, !20, !22, !23, !24, !25, !27, !28}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !15, file: !16, line: 24, baseType: !19, size: 32)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !15, file: !16, line: 25, baseType: !21, size: 32, offset: 32)
!21 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !15, file: !16, line: 26, baseType: !19, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !15, file: !16, line: 28, baseType: !21, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !15, file: !16, line: 32, baseType: !19, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !15, file: !16, line: 34, baseType: !26, size: 16, offset: 160)
!26 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !15, file: !16, line: 35, baseType: !26, size: 16, offset: 176)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !15, file: !16, line: 36, baseType: !29, size: 128, offset: 192)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !30, line: 55, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !30, line: 51, size: 128, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !31, file: !30, line: 53, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !31, file: !30, line: 54, baseType: !34, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !12, file: !11, line: 70, baseType: !37, size: 320)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 320, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 40)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !12, file: !11, line: 71, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 8, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 2}
!50 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 17, type: !51, scopeLine: 17, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!5, !5}
!53 = !{!54}
!54 = !DILocalVariable(name: "arg", arg: 1, scope: !50, file: !9, line: 17, type: !5)
!55 = !DILocation(line: 0, scope: !50)
!56 = !DILocation(line: 18, column: 3, scope: !50)
!57 = !DILocation(line: 19, column: 8, scope: !50)
!58 = !{!59, !59, i64 0}
!59 = !{!"int", !60, i64 0}
!60 = !{!"omnipotent char", !61, i64 0}
!61 = !{!"Simple C/C++ TBAA"}
!62 = !DILocation(line: 20, column: 3, scope: !50)
!63 = !DILocation(line: 21, column: 3, scope: !50)
!64 = !DISubprogram(name: "pthread_mutex_lock", scope: !65, file: !65, line: 794, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!65 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!66 = !DISubroutineType(types: !67)
!67 = !{!19, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!69 = !DISubprogram(name: "pthread_mutex_unlock", scope: !65, file: !65, line: 835, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!70 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 24, type: !71, scopeLine: 24, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !73)
!71 = !DISubroutineType(types: !72)
!72 = !{!19}
!73 = !{!74, !75, !79, !81}
!74 = !DILocalVariable(name: "threads_total", scope: !70, file: !9, line: 25, type: !19)
!75 = !DILocalVariable(name: "tids", scope: !70, file: !9, line: 27, type: !76)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !78)
!78 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!79 = !DILocalVariable(name: "i", scope: !80, file: !9, line: 30, type: !19)
!80 = distinct !DILexicalBlock(scope: !70, file: !9, line: 30, column: 3)
!81 = !DILocalVariable(name: "i", scope: !82, file: !9, line: 35, type: !19)
!82 = distinct !DILexicalBlock(scope: !70, file: !9, line: 35, column: 3)
!83 = !DILocation(line: 0, scope: !70)
!84 = !DILocation(line: 27, column: 28, scope: !70)
!85 = !DILocation(line: 27, column: 42, scope: !70)
!86 = !DILocation(line: 27, column: 21, scope: !70)
!87 = !DILocation(line: 0, scope: !80)
!88 = !DILocation(line: 30, column: 3, scope: !80)
!89 = !DILocation(line: 31, column: 21, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !9, line: 30, column: 43)
!91 = distinct !DILexicalBlock(scope: !80, file: !9, line: 30, column: 3)
!92 = !DILocation(line: 31, column: 5, scope: !90)
!93 = !DILocation(line: 32, column: 3, scope: !90)
!94 = !DILocation(line: 30, column: 39, scope: !91)
!95 = !DILocation(line: 30, column: 21, scope: !91)
!96 = distinct !{!96, !88, !97, !98, !99}
!97 = !DILocation(line: 32, column: 3, scope: !80)
!98 = !{!"llvm.loop.mustprogress"}
!99 = !{!"llvm.loop.unroll.disable"}
!100 = !DILocation(line: 0, scope: !82)
!101 = !DILocation(line: 35, column: 3, scope: !82)
!102 = !DILocation(line: 36, column: 18, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !9, line: 35, column: 47)
!104 = distinct !DILexicalBlock(scope: !82, file: !9, line: 35, column: 3)
!105 = !{!106, !106, i64 0}
!106 = !{!"long", !60, i64 0}
!107 = !DILocation(line: 36, column: 5, scope: !103)
!108 = !DILocation(line: 37, column: 3, scope: !103)
!109 = !DILocation(line: 35, column: 43, scope: !104)
!110 = !DILocation(line: 35, column: 21, scope: !104)
!111 = distinct !{!111, !101, !112, !98, !99}
!112 = !DILocation(line: 37, column: 3, scope: !82)
!113 = !DILocation(line: 39, column: 3, scope: !70)
!114 = !DILocation(line: 41, column: 10, scope: !70)
!115 = !DILocation(line: 41, column: 3, scope: !70)
!116 = !DISubprogram(name: "malloc", scope: !117, file: !117, line: 672, type: !118, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!118 = !DISubroutineType(types: !119)
!119 = !{!5, !120}
!120 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !121, line: 18, baseType: !78)
!121 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!122 = !DISubprogram(name: "pthread_create", scope: !65, file: !65, line: 202, type: !123, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!123 = !DISubroutineType(types: !124)
!124 = !{!19, !125, !126, !137, !138}
!125 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !76)
!126 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !127)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !129)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !130)
!130 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !131)
!131 = !{!132, !136}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !130, file: !11, line: 58, baseType: !133, size: 448)
!133 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !134)
!134 = !{!135}
!135 = !DISubrange(count: 56)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !130, file: !11, line: 59, baseType: !42, size: 64)
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!138 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!139 = !DISubprogram(name: "pthread_join", scope: !65, file: !65, line: 219, type: !140, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!140 = !DISubroutineType(types: !141)
!141 = !{!19, !77, !142}
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!143 = !DISubprogram(name: "free", scope: !117, file: !117, line: 687, type: !144, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!144 = !DISubroutineType(types: !145)
!145 = !{null, !5}
