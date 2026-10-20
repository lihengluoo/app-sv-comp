; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/per-thread-index-bitmask-race-3.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@threads_mask = dso_local global i32 -1, align 4, !dbg !0
@threads_mask_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !8
@datas = dso_local global ptr null, align 8, !dbg !43

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !53 {
entry:
    #dbg_value(ptr %arg, !57, !DIExpression(), !59)
  %0 = ptrtoint ptr %arg to i32, !dbg !60
    #dbg_value(i32 %0, !58, !DIExpression(), !59)
  %1 = load ptr, ptr @datas, align 8, !dbg !61, !tbaa !62
  %idxprom = sext i32 %0 to i64, !dbg !61
  %arrayidx = getelementptr inbounds i32, ptr %1, i64 %idxprom, !dbg !61
  store i32 4, ptr %arrayidx, align 4, !dbg !67, !tbaa !68
  %call = call i32 @pthread_mutex_lock(ptr noundef @threads_mask_mutex) #5, !dbg !70
  %shl = shl i32 1, %0, !dbg !71
  %2 = load i32, ptr @threads_mask, align 4, !dbg !72, !tbaa !68
  %or = or i32 %2, %shl, !dbg !72
  store i32 %or, ptr @threads_mask, align 4, !dbg !72, !tbaa !68
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @threads_mask_mutex) #5, !dbg !73
  ret ptr null, !dbg !74
}

; Function Attrs: nounwind
declare !dbg !75 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !80 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !81 {
entry:
    #dbg_value(i32 4, !85, !DIExpression(), !97)
  %conv = sext i32 4 to i64, !dbg !98
  %mul = mul i64 %conv, 8, !dbg !99
  %call = call noalias ptr @malloc(i64 noundef %mul) #6, !dbg !100
    #dbg_value(ptr %call, !86, !DIExpression(), !97)
  %conv1 = sext i32 4 to i64, !dbg !101
  %mul2 = mul i64 %conv1, 4, !dbg !102
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #6, !dbg !103
  store ptr %call3, ptr @datas, align 8, !dbg !104, !tbaa !62
    #dbg_value(i32 0, !90, !DIExpression(), !105)
  br label %for.body, !dbg !106

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !90, !DIExpression(), !105)
  %call5 = call i32 @pthread_mutex_lock(ptr noundef @threads_mask_mutex) #5, !dbg !107
  %0 = load i32, ptr @threads_mask, align 4, !dbg !108, !tbaa !68
  %call6 = call i32 @ffs(i32 noundef %0) #7, !dbg !109
  %sub = sub nsw i32 %call6, 1, !dbg !110
  %div = sdiv i32 %sub, 2, !dbg !111
    #dbg_value(i32 %div, !92, !DIExpression(), !112)
  %shl = shl i32 1, %div, !dbg !113
  %not = xor i32 %shl, -1, !dbg !114
  %1 = load i32, ptr @threads_mask, align 4, !dbg !115, !tbaa !68
  %and = and i32 %1, %not, !dbg !115
  store i32 %and, ptr @threads_mask, align 4, !dbg !115, !tbaa !68
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef @threads_mask_mutex) #5, !dbg !116
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !117
  %conv8 = sext i32 %div to i64, !dbg !118
  %2 = inttoptr i64 %conv8 to ptr, !dbg !118
  %call9 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef %2) #5, !dbg !119
  br label %for.inc, !dbg !120

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !121
    #dbg_value(i64 %indvars.iv.next, !90, !DIExpression(), !105)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !122
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !106, !llvm.loop !123

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !95, !DIExpression(), !127)
  br label %for.body15, !dbg !128

for.cond.cleanup14:                               ; preds = %for.inc19
  br label %for.end21

for.body15:                                       ; preds = %for.end, %for.inc19
  %indvars.iv14 = phi i64 [ 0, %for.end ], [ %indvars.iv.next15, %for.inc19 ]
    #dbg_value(i64 %indvars.iv14, !95, !DIExpression(), !127)
  %arrayidx17 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv14, !dbg !129
  %3 = load i64, ptr %arrayidx17, align 8, !dbg !129, !tbaa !132
  %call18 = call i32 @pthread_join(i64 noundef %3, ptr noundef null), !dbg !134
  br label %for.inc19, !dbg !135

for.inc19:                                        ; preds = %for.body15
  %indvars.iv.next15 = add nuw nsw i64 %indvars.iv14, 1, !dbg !136
    #dbg_value(i64 %indvars.iv.next15, !95, !DIExpression(), !127)
  %exitcond17 = icmp ne i64 %indvars.iv.next15, 4, !dbg !137
  br i1 %exitcond17, label %for.body15, label %for.cond.cleanup14, !dbg !128, !llvm.loop !138

for.end21:                                        ; preds = %for.cond.cleanup14
  call void @free(ptr noundef %call) #5, !dbg !140
  %4 = load ptr, ptr @datas, align 8, !dbg !141, !tbaa !62
  call void @free(ptr noundef %4) #5, !dbg !142
  ret i32 0, !dbg !143
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !144 noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind willreturn memory(none)
declare !dbg !150 i32 @ffs(i32 noundef) #3

; Function Attrs: nounwind
declare !dbg !154 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !171 i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: nounwind
declare !dbg !175 void @free(ptr noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind willreturn memory(none) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { nounwind allocsize(0) }
attributes #7 = { nounwind willreturn memory(none) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!46}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_mask", scope: !2, file: !10, line: 14, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/per-thread-index-bitmask-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "0281b45af0aab6af8cbef16af95c88b9")
!4 = !{!5, !6}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !{!0, !8, !43}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "threads_mask_mutex", scope: !2, file: !10, line: 15, type: !11, isLocal: false, isDefinition: true)
!10 = !DIFile(filename: "per-thread-index-bitmask-race-3.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "0281b45af0aab6af8cbef16af95c88b9")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !12, line: 72, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!13 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !12, line: 67, size: 320, elements: !14)
!14 = !{!15, !36, !41}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !13, file: !12, line: 69, baseType: !16, size: 320)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !17, line: 22, size: 320, elements: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!18 = !{!19, !20, !22, !23, !24, !25, !27, !28}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !16, file: !17, line: 24, baseType: !5, size: 32)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !16, file: !17, line: 25, baseType: !21, size: 32, offset: 32)
!21 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !16, file: !17, line: 26, baseType: !5, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !16, file: !17, line: 28, baseType: !21, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !16, file: !17, line: 32, baseType: !5, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !16, file: !17, line: 34, baseType: !26, size: 16, offset: 160)
!26 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !16, file: !17, line: 35, baseType: !26, size: 16, offset: 176)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !16, file: !17, line: 36, baseType: !29, size: 128, offset: 192)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !30, line: 55, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !30, line: 51, size: 128, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !31, file: !30, line: 53, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !31, file: !30, line: 54, baseType: !34, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !13, file: !12, line: 70, baseType: !37, size: 320)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 320, elements: !39)
!38 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!39 = !{!40}
!40 = !DISubrange(count: 40)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !13, file: !12, line: 71, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "datas", scope: !2, file: !10, line: 17, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!46 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 2}
!53 = distinct !DISubprogram(name: "thread", scope: !10, file: !10, line: 19, type: !54, scopeLine: 19, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!6, !6}
!56 = !{!57, !58}
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !53, file: !10, line: 19, type: !6)
!58 = !DILocalVariable(name: "j", scope: !53, file: !10, line: 20, type: !5)
!59 = !DILocation(line: 0, scope: !53)
!60 = !DILocation(line: 20, column: 11, scope: !53)
!61 = !DILocation(line: 21, column: 3, scope: !53)
!62 = !{!63, !63, i64 0}
!63 = !{!"p1 int", !64, i64 0}
!64 = !{!"any pointer", !65, i64 0}
!65 = !{!"omnipotent char", !66, i64 0}
!66 = !{!"Simple C/C++ TBAA"}
!67 = !DILocation(line: 21, column: 12, scope: !53)
!68 = !{!69, !69, i64 0}
!69 = !{!"int", !65, i64 0}
!70 = !DILocation(line: 23, column: 3, scope: !53)
!71 = !DILocation(line: 25, column: 21, scope: !53)
!72 = !DILocation(line: 25, column: 16, scope: !53)
!73 = !DILocation(line: 26, column: 3, scope: !53)
!74 = !DILocation(line: 27, column: 3, scope: !53)
!75 = !DISubprogram(name: "pthread_mutex_lock", scope: !76, file: !76, line: 794, type: !77, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!76 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!77 = !DISubroutineType(types: !78)
!78 = !{!5, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!80 = !DISubprogram(name: "pthread_mutex_unlock", scope: !76, file: !76, line: 835, type: !77, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!81 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 30, type: !82, scopeLine: 30, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !84)
!82 = !DISubroutineType(types: !83)
!83 = !{!5}
!84 = !{!85, !86, !90, !92, !95}
!85 = !DILocalVariable(name: "threads_total", scope: !81, file: !10, line: 31, type: !5)
!86 = !DILocalVariable(name: "tids", scope: !81, file: !10, line: 33, type: !87)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !12, line: 27, baseType: !89)
!89 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!90 = !DILocalVariable(name: "i", scope: !91, file: !10, line: 37, type: !5)
!91 = distinct !DILexicalBlock(scope: !81, file: !10, line: 37, column: 3)
!92 = !DILocalVariable(name: "j", scope: !93, file: !10, line: 40, type: !5)
!93 = distinct !DILexicalBlock(scope: !94, file: !10, line: 37, column: 43)
!94 = distinct !DILexicalBlock(scope: !91, file: !10, line: 37, column: 3)
!95 = !DILocalVariable(name: "i", scope: !96, file: !10, line: 49, type: !5)
!96 = distinct !DILexicalBlock(scope: !81, file: !10, line: 49, column: 3)
!97 = !DILocation(line: 0, scope: !81)
!98 = !DILocation(line: 33, column: 28, scope: !81)
!99 = !DILocation(line: 33, column: 42, scope: !81)
!100 = !DILocation(line: 33, column: 21, scope: !81)
!101 = !DILocation(line: 34, column: 18, scope: !81)
!102 = !DILocation(line: 34, column: 32, scope: !81)
!103 = !DILocation(line: 34, column: 11, scope: !81)
!104 = !DILocation(line: 34, column: 9, scope: !81)
!105 = !DILocation(line: 0, scope: !91)
!106 = !DILocation(line: 37, column: 3, scope: !91)
!107 = !DILocation(line: 38, column: 5, scope: !93)
!108 = !DILocation(line: 40, column: 18, scope: !93)
!109 = !DILocation(line: 40, column: 14, scope: !93)
!110 = !DILocation(line: 40, column: 32, scope: !93)
!111 = !DILocation(line: 40, column: 37, scope: !93)
!112 = !DILocation(line: 0, scope: !93)
!113 = !DILocation(line: 42, column: 25, scope: !93)
!114 = !DILocation(line: 42, column: 21, scope: !93)
!115 = !DILocation(line: 42, column: 18, scope: !93)
!116 = !DILocation(line: 43, column: 5, scope: !93)
!117 = !DILocation(line: 45, column: 21, scope: !93)
!118 = !DILocation(line: 45, column: 45, scope: !93)
!119 = !DILocation(line: 45, column: 5, scope: !93)
!120 = !DILocation(line: 46, column: 3, scope: !93)
!121 = !DILocation(line: 37, column: 39, scope: !94)
!122 = !DILocation(line: 37, column: 21, scope: !94)
!123 = distinct !{!123, !106, !124, !125, !126}
!124 = !DILocation(line: 46, column: 3, scope: !91)
!125 = !{!"llvm.loop.mustprogress"}
!126 = !{!"llvm.loop.unroll.disable"}
!127 = !DILocation(line: 0, scope: !96)
!128 = !DILocation(line: 49, column: 3, scope: !96)
!129 = !DILocation(line: 50, column: 18, scope: !130)
!130 = distinct !DILexicalBlock(scope: !131, file: !10, line: 49, column: 43)
!131 = distinct !DILexicalBlock(scope: !96, file: !10, line: 49, column: 3)
!132 = !{!133, !133, i64 0}
!133 = !{!"long", !65, i64 0}
!134 = !DILocation(line: 50, column: 5, scope: !130)
!135 = !DILocation(line: 51, column: 3, scope: !130)
!136 = !DILocation(line: 49, column: 39, scope: !131)
!137 = !DILocation(line: 49, column: 21, scope: !131)
!138 = distinct !{!138, !128, !139, !125, !126}
!139 = !DILocation(line: 51, column: 3, scope: !96)
!140 = !DILocation(line: 53, column: 3, scope: !81)
!141 = !DILocation(line: 54, column: 8, scope: !81)
!142 = !DILocation(line: 54, column: 3, scope: !81)
!143 = !DILocation(line: 56, column: 3, scope: !81)
!144 = !DISubprogram(name: "malloc", scope: !145, file: !145, line: 672, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!145 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!146 = !DISubroutineType(types: !147)
!147 = !{!6, !148}
!148 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !149, line: 18, baseType: !89)
!149 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!150 = !DISubprogram(name: "ffs", scope: !151, file: !151, line: 104, type: !152, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!151 = !DIFile(filename: "/usr/include/strings.h", directory: "", checksumkind: CSK_MD5, checksum: "5d92b6448a8d3cbcc2a27725c7a2efe7")
!152 = !DISubroutineType(types: !153)
!153 = !{!5, !5}
!154 = !DISubprogram(name: "pthread_create", scope: !76, file: !76, line: 202, type: !155, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DISubroutineType(types: !156)
!156 = !{!5, !157, !158, !169, !170}
!157 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !87)
!158 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !159)
!159 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !160, size: 64)
!160 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !161)
!161 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !12, line: 62, baseType: !162)
!162 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !12, line: 56, size: 448, elements: !163)
!163 = !{!164, !168}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !162, file: !12, line: 58, baseType: !165, size: 448)
!165 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !166)
!166 = !{!167}
!167 = !DISubrange(count: 56)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !162, file: !12, line: 59, baseType: !42, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!170 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!171 = !DISubprogram(name: "pthread_join", scope: !76, file: !76, line: 219, type: !172, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!172 = !DISubroutineType(types: !173)
!173 = !{!5, !88, !174}
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!175 = !DISubprogram(name: "free", scope: !145, file: !145, line: 687, type: !176, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!176 = !DISubroutineType(types: !177)
!177 = !{null, !6}
