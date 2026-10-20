; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-local-pthread-value-cond.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@shared = dso_local global i32 0, align 4, !dbg !0
@shared_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@key = dso_local global i32 0, align 4, !dbg !43

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !53 {
entry:
  %x = alloca i32, align 4
  %y = alloca i32, align 4
    #dbg_value(ptr %arg, !57, !DIExpression(), !60)
  call void @llvm.lifetime.start.p0(i64 4, ptr %x) #5, !dbg !61
    #dbg_declare(ptr %x, !58, !DIExpression(), !62)
  call void @llvm.lifetime.start.p0(i64 4, ptr %y) #5, !dbg !61
    #dbg_declare(ptr %y, !59, !DIExpression(), !63)
  %0 = load i32, ptr @key, align 4, !dbg !64, !tbaa !65
  %call = call i32 @pthread_setspecific(i32 noundef %0, ptr noundef %x) #5, !dbg !69
  %1 = load i32, ptr @key, align 4, !dbg !70, !tbaa !65
  %call1 = call i32 @pthread_setspecific(i32 noundef %1, ptr noundef %y) #5, !dbg !71
  %2 = load i32, ptr @key, align 4, !dbg !72, !tbaa !65
  %call2 = call ptr @pthread_getspecific(i32 noundef %2) #5, !dbg !74
  %cmp = icmp eq ptr %call2, %y, !dbg !75
  br i1 %cmp, label %if.then, label %if.end, !dbg !75

if.then:                                          ; preds = %entry
  %call3 = call i32 @pthread_mutex_lock(ptr noundef @shared_mutex) #5, !dbg !76
  br label %if.end, !dbg !78

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, ptr @shared, align 4, !dbg !79, !tbaa !65
  %inc = add nsw i32 %3, 1, !dbg !79
  store i32 %inc, ptr @shared, align 4, !dbg !79, !tbaa !65
  %4 = load i32, ptr @key, align 4, !dbg !80, !tbaa !65
  %call4 = call ptr @pthread_getspecific(i32 noundef %4) #5, !dbg !82
  %cmp5 = icmp eq ptr %call4, %y, !dbg !83
  br i1 %cmp5, label %if.then6, label %if.end8, !dbg !83

if.then6:                                         ; preds = %if.end
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef @shared_mutex) #5, !dbg !84
  br label %if.end8, !dbg !86

if.end8:                                          ; preds = %if.then6, %if.end
  call void @llvm.lifetime.end.p0(i64 4, ptr %y) #5, !dbg !87
  call void @llvm.lifetime.end.p0(i64 4, ptr %x) #5, !dbg !87
  ret ptr null, !dbg !88
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind
declare !dbg !89 i32 @pthread_setspecific(i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !95 ptr @pthread_getspecific(i32 noundef) #2

; Function Attrs: nounwind
declare !dbg !98 i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: nounwind
declare !dbg !102 i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !103 {
entry:
  %call = call i32 @pthread_key_create(ptr noundef @key, ptr noundef null) #5, !dbg !116
    #dbg_value(i32 4, !107, !DIExpression(), !117)
  %conv = sext i32 4 to i64, !dbg !118
  %mul = mul i64 %conv, 8, !dbg !119
  %call1 = call noalias ptr @malloc(i64 noundef %mul) #6, !dbg !120
    #dbg_value(ptr %call1, !108, !DIExpression(), !117)
    #dbg_value(i32 0, !112, !DIExpression(), !121)
  br label %for.body, !dbg !122

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
    #dbg_value(i64 %indvars.iv, !112, !DIExpression(), !121)
  %arrayidx = getelementptr inbounds i64, ptr %call1, i64 %indvars.iv, !dbg !123
  %call3 = call i32 @pthread_create(ptr noundef %arrayidx, ptr noundef null, ptr noundef @thread, ptr noundef null) #5, !dbg !126
  br label %for.inc, !dbg !127

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !128
    #dbg_value(i64 %indvars.iv.next, !112, !DIExpression(), !121)
  %exitcond = icmp ne i64 %indvars.iv.next, 4, !dbg !129
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !122, !llvm.loop !130

for.end:                                          ; preds = %for.cond.cleanup
    #dbg_value(i32 0, !114, !DIExpression(), !134)
  br label %for.body9, !dbg !135

for.cond.cleanup8:                                ; preds = %for.inc13
  br label %for.end15

for.body9:                                        ; preds = %for.end, %for.inc13
  %indvars.iv12 = phi i64 [ 0, %for.end ], [ %indvars.iv.next13, %for.inc13 ]
    #dbg_value(i64 %indvars.iv12, !114, !DIExpression(), !134)
  %arrayidx11 = getelementptr inbounds i64, ptr %call1, i64 %indvars.iv12, !dbg !136
  %0 = load i64, ptr %arrayidx11, align 8, !dbg !136, !tbaa !139
  %call12 = call i32 @pthread_join(i64 noundef %0, ptr noundef null), !dbg !141
  br label %for.inc13, !dbg !142

for.inc13:                                        ; preds = %for.body9
  %indvars.iv.next13 = add nuw nsw i64 %indvars.iv12, 1, !dbg !143
    #dbg_value(i64 %indvars.iv.next13, !114, !DIExpression(), !134)
  %exitcond15 = icmp ne i64 %indvars.iv.next13, 4, !dbg !144
  br i1 %exitcond15, label %for.body9, label %for.cond.cleanup8, !dbg !135, !llvm.loop !145

for.end15:                                        ; preds = %for.cond.cleanup8
  call void @free(ptr noundef %call1) #5, !dbg !147
  ret i32 0, !dbg !148
}

; Function Attrs: nounwind
declare !dbg !149 i32 @pthread_key_create(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind allocsize(0)
declare !dbg !156 noalias ptr @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare !dbg !162 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare !dbg !179 i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: nounwind
declare !dbg !183 void @free(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { nounwind allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!46}
!llvm.module.flags = !{!47, !48, !49, !50, !51, !52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !9, line: 15, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-local-pthread-value-cond.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "8c7172fdb67b0cc1dbb3f8d019e92f83")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "shared_mutex", scope: !2, file: !9, line: 16, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-local-pthread-value-cond.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "8c7172fdb67b0cc1dbb3f8d019e92f83")
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
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "key", scope: !2, file: !9, line: 13, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !11, line: 49, baseType: !21)
!46 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!47 = !{i32 7, !"Dwarf Version", i32 5}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 2}
!53 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 18, type: !54, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!5, !5}
!56 = !{!57, !58, !59}
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !53, file: !9, line: 18, type: !5)
!58 = !DILocalVariable(name: "x", scope: !53, file: !9, line: 19, type: !19)
!59 = !DILocalVariable(name: "y", scope: !53, file: !9, line: 19, type: !19)
!60 = !DILocation(line: 0, scope: !53)
!61 = !DILocation(line: 19, column: 3, scope: !53)
!62 = !DILocation(line: 19, column: 7, scope: !53)
!63 = !DILocation(line: 19, column: 10, scope: !53)
!64 = !DILocation(line: 20, column: 23, scope: !53)
!65 = !{!66, !66, i64 0}
!66 = !{!"int", !67, i64 0}
!67 = !{!"omnipotent char", !68, i64 0}
!68 = !{!"Simple C/C++ TBAA"}
!69 = !DILocation(line: 20, column: 3, scope: !53)
!70 = !DILocation(line: 21, column: 23, scope: !53)
!71 = !DILocation(line: 21, column: 3, scope: !53)
!72 = !DILocation(line: 22, column: 27, scope: !73)
!73 = distinct !DILexicalBlock(scope: !53, file: !9, line: 22, column: 7)
!74 = !DILocation(line: 22, column: 7, scope: !73)
!75 = !DILocation(line: 22, column: 32, scope: !73)
!76 = !DILocation(line: 23, column: 5, scope: !77)
!77 = distinct !DILexicalBlock(scope: !73, file: !9, line: 22, column: 39)
!78 = !DILocation(line: 24, column: 3, scope: !77)
!79 = !DILocation(line: 25, column: 9, scope: !53)
!80 = !DILocation(line: 26, column: 27, scope: !81)
!81 = distinct !DILexicalBlock(scope: !53, file: !9, line: 26, column: 7)
!82 = !DILocation(line: 26, column: 7, scope: !81)
!83 = !DILocation(line: 26, column: 32, scope: !81)
!84 = !DILocation(line: 27, column: 5, scope: !85)
!85 = distinct !DILexicalBlock(scope: !81, file: !9, line: 26, column: 39)
!86 = !DILocation(line: 28, column: 3, scope: !85)
!87 = !DILocation(line: 30, column: 1, scope: !53)
!88 = !DILocation(line: 29, column: 3, scope: !53)
!89 = !DISubprogram(name: "pthread_setspecific", scope: !90, file: !90, line: 1308, type: !91, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!90 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!91 = !DISubroutineType(types: !92)
!92 = !{!19, !45, !93}
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!95 = !DISubprogram(name: "pthread_getspecific", scope: !90, file: !90, line: 1305, type: !96, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!96 = !DISubroutineType(types: !97)
!97 = !{!5, !45}
!98 = !DISubprogram(name: "pthread_mutex_lock", scope: !90, file: !90, line: 794, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!99 = !DISubroutineType(types: !100)
!100 = !{!19, !101}
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!102 = !DISubprogram(name: "pthread_mutex_unlock", scope: !90, file: !90, line: 835, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!103 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 32, type: !104, scopeLine: 32, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !106)
!104 = !DISubroutineType(types: !105)
!105 = !{!19}
!106 = !{!107, !108, !112, !114}
!107 = !DILocalVariable(name: "threads_total", scope: !103, file: !9, line: 35, type: !19)
!108 = !DILocalVariable(name: "tids", scope: !103, file: !9, line: 37, type: !109)
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !111)
!111 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!112 = !DILocalVariable(name: "i", scope: !113, file: !9, line: 40, type: !19)
!113 = distinct !DILexicalBlock(scope: !103, file: !9, line: 40, column: 3)
!114 = !DILocalVariable(name: "i", scope: !115, file: !9, line: 45, type: !19)
!115 = distinct !DILexicalBlock(scope: !103, file: !9, line: 45, column: 3)
!116 = !DILocation(line: 33, column: 3, scope: !103)
!117 = !DILocation(line: 0, scope: !103)
!118 = !DILocation(line: 37, column: 28, scope: !103)
!119 = !DILocation(line: 37, column: 42, scope: !103)
!120 = !DILocation(line: 37, column: 21, scope: !103)
!121 = !DILocation(line: 0, scope: !113)
!122 = !DILocation(line: 40, column: 3, scope: !113)
!123 = !DILocation(line: 41, column: 21, scope: !124)
!124 = distinct !DILexicalBlock(scope: !125, file: !9, line: 40, column: 43)
!125 = distinct !DILexicalBlock(scope: !113, file: !9, line: 40, column: 3)
!126 = !DILocation(line: 41, column: 5, scope: !124)
!127 = !DILocation(line: 42, column: 3, scope: !124)
!128 = !DILocation(line: 40, column: 39, scope: !125)
!129 = !DILocation(line: 40, column: 21, scope: !125)
!130 = distinct !{!130, !122, !131, !132, !133}
!131 = !DILocation(line: 42, column: 3, scope: !113)
!132 = !{!"llvm.loop.mustprogress"}
!133 = !{!"llvm.loop.unroll.disable"}
!134 = !DILocation(line: 0, scope: !115)
!135 = !DILocation(line: 45, column: 3, scope: !115)
!136 = !DILocation(line: 46, column: 18, scope: !137)
!137 = distinct !DILexicalBlock(scope: !138, file: !9, line: 45, column: 43)
!138 = distinct !DILexicalBlock(scope: !115, file: !9, line: 45, column: 3)
!139 = !{!140, !140, i64 0}
!140 = !{!"long", !67, i64 0}
!141 = !DILocation(line: 46, column: 5, scope: !137)
!142 = !DILocation(line: 47, column: 3, scope: !137)
!143 = !DILocation(line: 45, column: 39, scope: !138)
!144 = !DILocation(line: 45, column: 21, scope: !138)
!145 = distinct !{!145, !135, !146, !132, !133}
!146 = !DILocation(line: 47, column: 3, scope: !115)
!147 = !DILocation(line: 49, column: 3, scope: !103)
!148 = !DILocation(line: 51, column: 3, scope: !103)
!149 = !DISubprogram(name: "pthread_key_create", scope: !90, file: !90, line: 1297, type: !150, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!150 = !DISubroutineType(types: !151)
!151 = !{!19, !152, !153}
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!154 = !DISubroutineType(types: !155)
!155 = !{null, !5}
!156 = !DISubprogram(name: "malloc", scope: !157, file: !157, line: 672, type: !158, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!157 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!158 = !DISubroutineType(types: !159)
!159 = !{!5, !160}
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !161, line: 18, baseType: !111)
!161 = !DIFile(filename: "dependencies/install/llvm21/lib/clang/21/include/__stddef_size_t.h", directory: "/home/liheng/proj-Delphi", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!162 = !DISubprogram(name: "pthread_create", scope: !90, file: !90, line: 202, type: !163, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!163 = !DISubroutineType(types: !164)
!164 = !{!19, !165, !166, !177, !178}
!165 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !109)
!166 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !167)
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!168 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !169)
!169 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !170)
!170 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !171)
!171 = !{!172, !176}
!172 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !170, file: !11, line: 58, baseType: !173, size: 448)
!173 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !174)
!174 = !{!175}
!175 = !DISubrange(count: 56)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !170, file: !11, line: 59, baseType: !42, size: 64)
!177 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!178 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!179 = !DISubprogram(name: "pthread_join", scope: !90, file: !90, line: 219, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!180 = !DISubroutineType(types: !181)
!181 = !{!19, !110, !182}
!182 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!183 = !DISubprogram(name: "free", scope: !157, file: !157, line: 687, type: !154, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
