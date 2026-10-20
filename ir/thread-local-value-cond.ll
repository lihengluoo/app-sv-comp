; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-value-cond.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@data = dso_local thread_local global i32 0, align 4, !dbg !0
@shared = dso_local global i32 0, align 4, !dbg !7
@shared_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !11

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !52 {
entry:
    #dbg_value(ptr %arg, !56, !DIExpression(), !57)
  %0 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !58
  store i32 1, ptr %0, align 4, !dbg !59, !tbaa !60
  %1 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !64
  %2 = load i32, ptr %1, align 4, !dbg !64, !tbaa !60
  %cmp = icmp eq i32 %2, 1, !dbg !66
  br i1 %cmp, label %if.then, label %if.end, !dbg !66

if.then:                                          ; preds = %entry
  %call = call i32 @pthread_mutex_lock(ptr noundef @shared_mutex) #5, !dbg !67
  br label %if.end, !dbg !69

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, ptr @shared, align 4, !dbg !70, !tbaa !60
  %inc = add nsw i32 %3, 1, !dbg !70
  store i32 %inc, ptr @shared, align 4, !dbg !70, !tbaa !60
  %4 = call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @data), !dbg !71
  %5 = load i32, ptr %4, align 4, !dbg !71, !tbaa !60
  %cmp1 = icmp eq i32 %5, 1, !dbg !73
  br i1 %cmp1, label %if.then2, label %if.end4, !dbg !73

if.then2:                                         ; preds = %if.end
  %call3 = call i32 @pthread_mutex_unlock(ptr noundef @shared_mutex) #5, !dbg !74
  br label %if.end4, !dbg !76

if.end4:                                          ; preds = %if.then2, %if.end
  ret ptr null, !dbg !77
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare nonnull ptr @llvm.threadlocal.address.p0(ptr nonnull) #1

; Function Attrs: nounwind
declare !dbg !78 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !83 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !84 {
entry:
    #dbg_value(i32 4, !88, !DIExpression(), !97)
  %conv = sext i32 4 to i64, !dbg !98
  %mul = mul i64 %conv, 8, !dbg !99
  %call = call noalias ptr @malloc(i64 noundef %mul) #6, !dbg !100
    #dbg_value(ptr %call, !89, !DIExpression(), !97)
    #dbg_value(i32 0, !93, !DIExpression(), !101)
  br label %for.body, !dbg !102

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !93, !DIExpression(), !101)
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 %indvars.iv, !dbg !103
  %call2 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #5, !dbg !106
  br label %for.inc, !dbg !107

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !108
    #dbg_value(i64 %indvars.iv.next, !93, !DIExpression(), !101)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !109
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !102, !llvm.loop !110

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !95, !DIExpression(), !114)
  br label %for.body8, !dbg !115

for.cond.cleanup7:                                ; preds = %for.inc12
  br label %for.end14

for.body8:                                        ; preds = %for.end, %for.inc12
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc12 ]
    #dbg_value(i64 %indvars.iv12, !95, !DIExpression(), !114)
  %arrayidx10 = getelementptr inbounds i64, ptr %call, i64 %indvars.iv12, !dbg !116
  %0 = load i64, ptr %arrayidx10, align 8, !dbg !116, !tbaa !119
  %call11 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !121
  br label %for.inc12, !dbg !122

for.inc12:                                        ; preds = %for.body8
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !123
    #dbg_value(i64 %indvars.iv.next13, !95, !DIExpression(), !114)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !124
  br i1 %exitcond15, label %for.body8, label %for.cond.cleanup7, !dbg !115, !llvm.loop !125

for.end14:                                        ; preds = %for.cond.cleanup7
  call void @free(ptr noundef %call) #5, !dbg !127
  ret i32 0, !dbg !128
}

; Function Attrs: nounwind allocsize(0)
declare !dbg !129 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !135 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !152 i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: nounwind
declare !dbg !156 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!45}
!llvm.module.flags = !{!46, !47, !48, !49, !50, !51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 13, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-value-cond.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "85ada276585b04ef68943e6e59d3e053")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !11}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-local-value-cond.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "85ada276585b04ef68943e6e59d3e053")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "shared_mutex", scope: !2, file: !9, line: 16, type: !13, isLocal: false, isDefinition: true)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !14, line: 72, baseType: !15)
!14 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!15 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !14, line: 67, size: 320, elements: !16)
!16 = !{!17, !38, !43}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !15, file: !14, line: 69, baseType: !18, size: 320)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !19, line: 22, size: 320, elements: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!20 = !{!21, !22, !24, !25, !26, !27, !29, !30}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !18, file: !19, line: 24, baseType: !10, size: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !18, file: !19, line: 25, baseType: !23, size: 32, offset: 32)
!23 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !18, file: !19, line: 26, baseType: !10, size: 32, offset: 64)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !18, file: !19, line: 28, baseType: !23, size: 32, offset: 96)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !18, file: !19, line: 32, baseType: !10, size: 32, offset: 128)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !18, file: !19, line: 34, baseType: !28, size: 16, offset: 160)
!28 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !18, file: !19, line: 35, baseType: !28, size: 16, offset: 176)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !18, file: !19, line: 36, baseType: !31, size: 128, offset: 192)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !32, line: 55, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !32, line: 51, size: 128, elements: !34)
!34 = !{!35, !37}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !33, file: !32, line: 53, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !33, file: !32, line: 54, baseType: !36, size: 64, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !15, file: !14, line: 70, baseType: !39, size: 320)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 320, elements: !41)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 40)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !15, file: !14, line: 71, baseType: !44, size: 64)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!46 = !{i32 7, !"Dwarf Version", i32 5}
!47 = !{i32 2, !"Debug Info Version", i32 3}
!48 = !{i32 1, !"wchar_size", i32 4}
!49 = !{i32 8, !"PIC Level", i32 2}
!50 = !{i32 7, !"PIE Level", i32 2}
!51 = !{i32 7, !"uwtable", i32 2}
!52 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 18, type: !53, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{!5, !5}
!55 = !{!56}
!56 = !DILocalVariable(name: "arg", arg: 1, scope: !52, file: !9, line: 18, type: !5)
!57 = !DILocation(line: 0, scope: !52)
!58 = !DILocation(line: 19, column: 3, scope: !52)
!59 = !DILocation(line: 19, column: 8, scope: !52)
!60 = !{!61, !61, i64 0}
!61 = !{!"int", !62, i64 0}
!62 = !{!"omnipotent char", !63, i64 0}
!63 = !{!"Simple C/C++ TBAA"}
!64 = !DILocation(line: 20, column: 7, scope: !65)
!65 = distinct !DILexicalBlock(scope: !52, file: !9, line: 20, column: 7)
!66 = !DILocation(line: 20, column: 12, scope: !65)
!67 = !DILocation(line: 21, column: 5, scope: !68)
!68 = distinct !DILexicalBlock(scope: !65, file: !9, line: 20, column: 18)
!69 = !DILocation(line: 22, column: 3, scope: !68)
!70 = !DILocation(line: 23, column: 9, scope: !52)
!71 = !DILocation(line: 24, column: 7, scope: !72)
!72 = distinct !DILexicalBlock(scope: !52, file: !9, line: 24, column: 7)
!73 = !DILocation(line: 24, column: 12, scope: !72)
!74 = !DILocation(line: 25, column: 5, scope: !75)
!75 = distinct !DILexicalBlock(scope: !72, file: !9, line: 24, column: 18)
!76 = !DILocation(line: 26, column: 3, scope: !75)
!77 = !DILocation(line: 27, column: 3, scope: !52)
!78 = !DISubprogram(name: "pthread_mutex_lock", scope: !79, file: !79, line: 794, type: !80, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!79 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!80 = !DISubroutineType(types: !81)
!81 = !{!10, !82}
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!83 = !DISubprogram(name: "pthread_mutex_unlock", scope: !79, file: !79, line: 835, type: !80, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!84 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 30, type: !85, scopeLine: 30, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !87)
!85 = !DISubroutineType(types: !86)
!86 = !{!10}
!87 = !{!88, !89, !93, !95}
!88 = !DILocalVariable(name: "threads_total", scope: !84, file: !9, line: 31, type: !10)
!89 = !DILocalVariable(name: "tids", scope: !84, file: !9, line: 33, type: !90)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !14, line: 27, baseType: !92)
!92 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!93 = !DILocalVariable(name: "i", scope: !94, file: !9, line: 36, type: !10)
!94 = distinct !DILexicalBlock(scope: !84, file: !9, line: 36, column: 3)
!95 = !DILocalVariable(name: "i", scope: !96, file: !9, line: 41, type: !10)
!96 = distinct !DILexicalBlock(scope: !84, file: !9, line: 41, column: 3)
!97 = !DILocation(line: 0, scope: !84)
!98 = !DILocation(line: 33, column: 28, scope: !84)
!99 = !DILocation(line: 33, column: 42, scope: !84)
!100 = !DILocation(line: 33, column: 21, scope: !84)
!101 = !DILocation(line: 0, scope: !94)
!102 = !DILocation(line: 36, column: 3, scope: !94)
!103 = !DILocation(line: 37, column: 21, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !9, line: 36, column: 43)
!105 = distinct !DILexicalBlock(scope: !94, file: !9, line: 36, column: 3)
!106 = !DILocation(line: 37, column: 5, scope: !104)
!107 = !DILocation(line: 38, column: 3, scope: !104)
!108 = !DILocation(line: 36, column: 39, scope: !105)
!109 = !DILocation(line: 36, column: 21, scope: !105)
!110 = distinct !{!110, !102, !111, !112, !113}
!111 = !DILocation(line: 38, column: 3, scope: !94)
!112 = !{!"llvm.loop.mustprogress"}
!113 = !{!"llvm.loop.unroll.disable"}
!114 = !DILocation(line: 0, scope: !96)
!115 = !DILocation(line: 41, column: 3, scope: !96)
!116 = !DILocation(line: 42, column: 18, scope: !117)
!117 = distinct !DILexicalBlock(scope: !118, file: !9, line: 41, column: 43)
!118 = distinct !DILexicalBlock(scope: !96, file: !9, line: 41, column: 3)
!119 = !{!120, !120, i64 0}
!120 = !{!"long", !62, i64 0}
!121 = !DILocation(line: 42, column: 5, scope: !117)
!122 = !DILocation(line: 43, column: 3, scope: !117)
!123 = !DILocation(line: 41, column: 39, scope: !118)
!124 = !DILocation(line: 41, column: 21, scope: !118)
!125 = distinct !{!125, !115, !126, !112, !113}
!126 = !DILocation(line: 43, column: 3, scope: !96)
!127 = !DILocation(line: 45, column: 3, scope: !84)
!128 = !DILocation(line: 47, column: 3, scope: !84)
!129 = !DISubprogram(name: "malloc", scope: !130, file: !130, line: 672, type: !131, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!130 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!131 = !DISubroutineType(types: !132)
!132 = !{!5, !133}
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !134, line: 18, baseType: !92)
!134 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!135 = !DISubprogram(name: "pthread_create", scope: !79, file: !79, line: 202, type: !136, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!136 = !DISubroutineType(types: !137)
!137 = !{!10, !138, !139, !150, !151}
!138 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !90)
!139 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !140)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!141 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !142)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !14, line: 62, baseType: !143)
!143 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !14, line: 56, size: 448, elements: !144)
!144 = !{!145, !149}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !143, file: !14, line: 58, baseType: !146, size: 448)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 448, elements: !147)
!147 = !{!148}
!148 = !DISubrange(count: 56)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !143, file: !14, line: 59, baseType: !44, size: 64)
!150 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!151 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!152 = !DISubprogram(name: "pthread_join", scope: !79, file: !79, line: 219, type: !153, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DISubroutineType(types: !154)
!154 = !{!10, !91, !155}
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!156 = !DISubprogram(name: "free", scope: !130, file: !130, line: 687, type: !157, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!157 = !DISubroutineType(types: !158)
!158 = !{null, !5}
