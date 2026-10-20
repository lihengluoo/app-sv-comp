; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-struct-tid-join.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.thread = type { i64 }

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
    #dbg_value(i32 4, !74, !DIExpression(), !90)
  %conv = sext i32 4 to i64, !dbg !91
  %mul = mul i64 %conv, 8, !dbg !92
  %call = call noalias ptr @malloc(i64 noundef %mul) #5, !dbg !93
    #dbg_value(ptr %call, !75, !DIExpression(), !90)
    #dbg_value(i32 0, !83, !DIExpression(), !94)
  br label %for.body, !dbg !95

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !83, !DIExpression(), !94)
  %call2 = call noalias ptr @malloc(i64 noundef 8) #5, !dbg !96
    #dbg_value(ptr %call2, !85, !DIExpression(), !97)
  %arrayidx = getelementptr inbounds ptr, ptr %call, i64 %indvars.iv, !dbg !98
  store ptr %call2, ptr %arrayidx, align 8, !dbg !99, !tbaa !100
  %tid = getelementptr inbounds nuw %struct.thread, ptr %call2, i32 0, i32 0, !dbg !103
  %call3 = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef %call2) #4, !dbg !104
  br label %for.inc, !dbg !105

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !106
    #dbg_value(i64 %indvars.iv.next, !83, !DIExpression(), !94)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !107
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !95, !llvm.loop !108

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !88, !DIExpression(), !112)
  br label %for.body9, !dbg !113

for.cond.cleanup8:                                ; preds = %for.inc16
  br label %for.end18

for.body9:                                        ; preds = %for.end, %for.inc16
  %indvars.iv16 = phi i64 [ 0, %for.end ], [ %indvars.iv.next17, %for.inc16 ]
    #dbg_value(i64 %indvars.iv16, !88, !DIExpression(), !112)
  %arrayidx11 = getelementptr inbounds ptr, ptr %call, i64 %indvars.iv16, !dbg !114
  %0 = load ptr, ptr %arrayidx11, align 8, !dbg !114, !tbaa !100
  %tid12 = getelementptr inbounds nuw %struct.thread, ptr %0, i32 0, i32 0, !dbg !117
  %1 = load i64, ptr %tid12, align 8, !dbg !117, !tbaa !118
  %call13 = call i32 @pthread_join(i64 noundef %1, ptr noundef null), !dbg !121
  %arrayidx15 = getelementptr inbounds ptr, ptr %call, i64 %indvars.iv16, !dbg !122
  %2 = load ptr, ptr %arrayidx15, align 8, !dbg !122, !tbaa !100
  call void @free(ptr noundef %2) #4, !dbg !123
  br label %for.inc16, !dbg !124

for.inc16:                                        ; preds = %for.body9
  %indvars.iv.next17 = add nuw nsw i64 %indvars.iv16, 1, !dbg !125
    #dbg_value(i64 %indvars.iv.next17, !88, !DIExpression(), !112)
  %exitcond19 = icmp ne i64 %indvars.iv.next17, 4, !dbg !126
  br i1 %exitcond19, label %for.body9, label %for.cond.cleanup8, !dbg !113, !llvm.loop !127

for.end18:                                        ; preds = %for.cond.cleanup8
  call void @free(ptr noundef %call) #4, !dbg !129
  %3 = load i32, ptr @data, align 4, !dbg !130, !tbaa !58
  ret i32 %3, !dbg !131
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !132 noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare !dbg !138 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !156 i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare !dbg !160 void @free(ptr noundef) #1

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
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 17, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-struct-tid-join.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "47c4058030ee5bffae1a15a2c4fc01c1")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 18, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "per-thread-struct-tid-join.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "47c4058030ee5bffae1a15a2c4fc01c1")
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
!50 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 20, type: !51, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!5, !5}
!53 = !{!54}
!54 = !DILocalVariable(name: "arg", arg: 1, scope: !50, file: !9, line: 20, type: !5)
!55 = !DILocation(line: 0, scope: !50)
!56 = !DILocation(line: 21, column: 3, scope: !50)
!57 = !DILocation(line: 22, column: 8, scope: !50)
!58 = !{!59, !59, i64 0}
!59 = !{!"int", !60, i64 0}
!60 = !{!"omnipotent char", !61, i64 0}
!61 = !{!"Simple C/C++ TBAA"}
!62 = !DILocation(line: 23, column: 3, scope: !50)
!63 = !DILocation(line: 24, column: 3, scope: !50)
!64 = !DISubprogram(name: "pthread_mutex_lock", scope: !65, file: !65, line: 794, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!65 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!66 = !DISubroutineType(types: !67)
!67 = !{!19, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!69 = !DISubprogram(name: "pthread_mutex_unlock", scope: !65, file: !65, line: 835, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!70 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 27, type: !71, scopeLine: 27, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !73)
!71 = !DISubroutineType(types: !72)
!72 = !{!19}
!73 = !{!74, !75, !83, !85, !88}
!74 = !DILocalVariable(name: "threads_total", scope: !70, file: !9, line: 28, type: !19)
!75 = !DILocalVariable(name: "ts", scope: !70, file: !9, line: 30, type: !76)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "thread", file: !9, line: 13, size: 64, elements: !79)
!79 = !{!80}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "tid", scope: !78, file: !9, line: 14, baseType: !81, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !82)
!82 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!83 = !DILocalVariable(name: "i", scope: !84, file: !9, line: 33, type: !19)
!84 = distinct !DILexicalBlock(scope: !70, file: !9, line: 33, column: 3)
!85 = !DILocalVariable(name: "t", scope: !86, file: !9, line: 34, type: !77)
!86 = distinct !DILexicalBlock(scope: !87, file: !9, line: 33, column: 43)
!87 = distinct !DILexicalBlock(scope: !84, file: !9, line: 33, column: 3)
!88 = !DILocalVariable(name: "i", scope: !89, file: !9, line: 40, type: !19)
!89 = distinct !DILexicalBlock(scope: !70, file: !9, line: 40, column: 3)
!90 = !DILocation(line: 0, scope: !70)
!91 = !DILocation(line: 30, column: 31, scope: !70)
!92 = !DILocation(line: 30, column: 45, scope: !70)
!93 = !DILocation(line: 30, column: 24, scope: !70)
!94 = !DILocation(line: 0, scope: !84)
!95 = !DILocation(line: 33, column: 3, scope: !84)
!96 = !DILocation(line: 34, column: 24, scope: !86)
!97 = !DILocation(line: 0, scope: !86)
!98 = !DILocation(line: 35, column: 5, scope: !86)
!99 = !DILocation(line: 35, column: 11, scope: !86)
!100 = !{!101, !101, i64 0}
!101 = !{!"p1 _ZTS6thread", !102, i64 0}
!102 = !{!"any pointer", !60, i64 0}
!103 = !DILocation(line: 36, column: 24, scope: !86)
!104 = !DILocation(line: 36, column: 5, scope: !86)
!105 = !DILocation(line: 37, column: 3, scope: !86)
!106 = !DILocation(line: 33, column: 39, scope: !87)
!107 = !DILocation(line: 33, column: 21, scope: !87)
!108 = distinct !{!108, !95, !109, !110, !111}
!109 = !DILocation(line: 37, column: 3, scope: !84)
!110 = !{!"llvm.loop.mustprogress"}
!111 = !{!"llvm.loop.unroll.disable"}
!112 = !DILocation(line: 0, scope: !89)
!113 = !DILocation(line: 40, column: 3, scope: !89)
!114 = !DILocation(line: 41, column: 18, scope: !115)
!115 = distinct !DILexicalBlock(scope: !116, file: !9, line: 40, column: 43)
!116 = distinct !DILexicalBlock(scope: !89, file: !9, line: 40, column: 3)
!117 = !DILocation(line: 41, column: 25, scope: !115)
!118 = !{!119, !120, i64 0}
!119 = !{!"thread", !120, i64 0}
!120 = !{!"long", !60, i64 0}
!121 = !DILocation(line: 41, column: 5, scope: !115)
!122 = !DILocation(line: 42, column: 10, scope: !115)
!123 = !DILocation(line: 42, column: 5, scope: !115)
!124 = !DILocation(line: 43, column: 3, scope: !115)
!125 = !DILocation(line: 40, column: 39, scope: !116)
!126 = !DILocation(line: 40, column: 21, scope: !116)
!127 = distinct !{!127, !113, !128, !110, !111}
!128 = !DILocation(line: 43, column: 3, scope: !89)
!129 = !DILocation(line: 45, column: 3, scope: !70)
!130 = !DILocation(line: 47, column: 10, scope: !70)
!131 = !DILocation(line: 47, column: 3, scope: !70)
!132 = !DISubprogram(name: "malloc", scope: !133, file: !133, line: 672, type: !134, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!133 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!134 = !DISubroutineType(types: !135)
!135 = !{!5, !136}
!136 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !137, line: 18, baseType: !82)
!137 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!138 = !DISubprogram(name: "pthread_create", scope: !65, file: !65, line: 202, type: !139, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!139 = !DISubroutineType(types: !140)
!140 = !{!19, !141, !143, !154, !155}
!141 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !142)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !144)
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!145 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !146)
!146 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !147)
!147 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !148)
!148 = !{!149, !153}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !147, file: !11, line: 58, baseType: !150, size: 448)
!150 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !151)
!151 = !{!152}
!152 = !DISubrange(count: 56)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !147, file: !11, line: 59, baseType: !42, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!155 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!156 = !DISubprogram(name: "pthread_join", scope: !65, file: !65, line: 219, type: !157, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!157 = !DISubroutineType(types: !158)
!158 = !{!19, !81, !159}
!159 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!160 = !DISubprogram(name: "free", scope: !133, file: !133, line: 687, type: !161, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!161 = !DISubroutineType(types: !162)
!162 = !{null, !5}
