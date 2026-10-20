; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-counter-inner-2.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }

@threads_alive = dso_local global i32 0, align 4, !dbg !0
@threads_alive_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !7
@threads_alive_cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !43
@data = dso_local global i32 0, align 4, !dbg !78
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !80

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !89 {
entry:
    #dbg_value(ptr %arg, !93, !DIExpression(), !94)
  %call = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !95
  %0 = load i32, ptr @threads_alive, align 4, !dbg !96, !tbaa !97
  %inc = add nsw i32 %0, 1, !dbg !96
  store i32 %inc, ptr @threads_alive, align 4, !dbg !96, !tbaa !97
  %call1 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #4, !dbg !101
  %call2 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !102
  %call3 = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #4, !dbg !103
  store i32 4, ptr @data, align 4, !dbg !104, !tbaa !97
  %call4 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #4, !dbg !105
  %call5 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !106
  %1 = load i32, ptr @threads_alive, align 4, !dbg !107, !tbaa !97
  %dec = add nsw i32 %1, -1, !dbg !107
  store i32 %dec, ptr @threads_alive, align 4, !dbg !107, !tbaa !97
  %call6 = call i32 @pthread_cond_signal(ptr noundef @threads_alive_cond) #4, !dbg !108
  %call7 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !109
  ret ptr null, !dbg !110
}

; Function Attrs: nounwind
declare !dbg !111 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !116 i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !120 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !121 {
entry:
  %tid = alloca i64, align 8
    #dbg_value(i32 4, !125, !DIExpression(), !133)
    #dbg_value(i32 0, !126, !DIExpression(), !134)
  br label %for.body, !dbg !135

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %i.03 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
    #dbg_value(i32 %i.03, !126, !DIExpression(), !134)
  call void @llvm.lifetime.start.p0(i64 8, ptr %tid) #4, !dbg !136
    #dbg_declare(ptr %tid, !128, !DIExpression(), !137)
  %call = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef null) #4, !dbg !138
  %0 = load i64, ptr %tid, align 8, !dbg !139, !tbaa !140
  %call1 = call i32 @pthread_detach(i64 noundef %0) #4, !dbg !142
  call void @llvm.lifetime.end.p0(i64 8, ptr %tid) #4, !dbg !143
  br label %for.inc, !dbg !144

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i32 %i.03, 1, !dbg !145
    #dbg_value(i32 %inc, !126, !DIExpression(), !134)
  %exitcond = icmp ne i32 %inc, 4, !dbg !146
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !135, !llvm.loop !147

for.end:                                          ; preds = %for.cond.cleanup
  %call2 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !151
  %1 = load i32, ptr @threads_alive, align 4, !dbg !152, !tbaa !97
  %cmp34 = icmp ne i32 %1, 4, !dbg !153
  br i1 %cmp34, label %while.body.lr.ph, label %while.end, !dbg !154

while.body.lr.ph:                                 ; preds = %for.end
  br label %while.body, !dbg !154

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call4 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !155
  %2 = load i32, ptr @threads_alive, align 4, !dbg !152, !tbaa !97
  %cmp3 = icmp ne i32 %2, 4, !dbg !153
  br i1 %cmp3, label %while.body, label %while.cond.while.end_crit_edge, !dbg !154, !llvm.loop !156

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !154

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %for.end
  %call5 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !158
  %call6 = call i32 @pthread_mutex_lock(ptr noundef @threads_alive_mutex) #4, !dbg !159
  %3 = load i32, ptr @threads_alive, align 4, !dbg !160, !tbaa !97
  %tobool5 = icmp ne i32 %3, 0, !dbg !161
  br i1 %tobool5, label %while.body8.lr.ph, label %while.end10, !dbg !161

while.body8.lr.ph:                                ; preds = %while.end
  br label %while.body8, !dbg !161

while.body8:                                      ; preds = %while.body8.lr.ph, %while.body8
  %call9 = call i32 @pthread_cond_wait(ptr noundef @threads_alive_cond, ptr noundef @threads_alive_mutex), !dbg !162
  %4 = load i32, ptr @threads_alive, align 4, !dbg !160, !tbaa !97
  %tobool = icmp ne i32 %4, 0, !dbg !161
  br i1 %tobool, label %while.body8, label %while.cond7.while.end10_crit_edge, !dbg !161, !llvm.loop !163

while.cond7.while.end10_crit_edge:                ; preds = %while.body8
  br label %while.end10, !dbg !161

while.end10:                                      ; preds = %while.cond7.while.end10_crit_edge, %while.end
  %call11 = call i32 @pthread_mutex_unlock(ptr noundef @threads_alive_mutex) #4, !dbg !165
  %5 = load i32, ptr @data, align 4, !dbg !166, !tbaa !97
  ret i32 %5, !dbg !167
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !168 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !186 i32 @pthread_detach(i64 noundef) #1

declare !dbg !189 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!82}
!llvm.module.flags = !{!83, !84, !85, !86, !87, !88}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !9, line: 14, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-counter-inner-2.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "236aee6045f1d54f86aa5515c91e3cb1")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !43, !78, !80}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "threads_alive_mutex", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-join-counter-inner-2.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "236aee6045f1d54f86aa5515c91e3cb1")
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
!44 = distinct !DIGlobalVariable(name: "threads_alive_cond", scope: !2, file: !9, line: 16, type: !45, isLocal: false, isDefinition: true)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !11, line: 80, baseType: !46)
!46 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 75, size: 384, elements: !47)
!47 = !{!48, !72, !76}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !46, file: !11, line: 77, baseType: !49, size: 384)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !30, line: 94, size: 384, elements: !50)
!50 = !{!51, !63, !64, !68, !69, !70, !71}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !49, file: !30, line: 96, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !53, line: 33, baseType: !54)
!53 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ec99b0f6e36c0a42ac284d459cbd38")
!54 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !53, line: 25, size: 64, elements: !55)
!55 = !{!56, !58}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !54, file: !53, line: 27, baseType: !57, size: 64)
!57 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !54, file: !53, line: 32, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !54, file: !53, line: 28, size: 64, elements: !60)
!60 = !{!61, !62}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !59, file: !53, line: 30, baseType: !21, size: 32)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !59, file: !53, line: 31, baseType: !21, size: 32, offset: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !49, file: !30, line: 97, baseType: !52, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__g_refs", scope: !49, file: !30, line: 98, baseType: !65, size: 64, offset: 128)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 64, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 2)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !49, file: !30, line: 99, baseType: !65, size: 64, offset: 192)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !49, file: !30, line: 100, baseType: !21, size: 32, offset: 256)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !49, file: !30, line: 101, baseType: !21, size: 32, offset: 288)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !49, file: !30, line: 102, baseType: !65, size: 64, offset: 320)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !46, file: !11, line: 78, baseType: !73, size: 384)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 384, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 48)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !46, file: !11, line: 79, baseType: !77, size: 64)
!77 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 18, type: !19, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 19, type: !10, isLocal: false, isDefinition: true)
!82 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!83 = !{i32 7, !"Dwarf Version", i32 5}
!84 = !{i32 2, !"Debug Info Version", i32 3}
!85 = !{i32 1, !"wchar_size", i32 4}
!86 = !{i32 8, !"PIC Level", i32 2}
!87 = !{i32 7, !"PIE Level", i32 2}
!88 = !{i32 7, !"uwtable", i32 2}
!89 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 21, type: !90, scopeLine: 21, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !92)
!90 = !DISubroutineType(types: !91)
!91 = !{!5, !5}
!92 = !{!93}
!93 = !DILocalVariable(name: "arg", arg: 1, scope: !89, file: !9, line: 21, type: !5)
!94 = !DILocation(line: 0, scope: !89)
!95 = !DILocation(line: 22, column: 3, scope: !89)
!96 = !DILocation(line: 23, column: 16, scope: !89)
!97 = !{!98, !98, i64 0}
!98 = !{!"int", !99, i64 0}
!99 = !{!"omnipotent char", !100, i64 0}
!100 = !{!"Simple C/C++ TBAA"}
!101 = !DILocation(line: 24, column: 3, scope: !89)
!102 = !DILocation(line: 25, column: 3, scope: !89)
!103 = !DILocation(line: 27, column: 3, scope: !89)
!104 = !DILocation(line: 28, column: 8, scope: !89)
!105 = !DILocation(line: 29, column: 3, scope: !89)
!106 = !DILocation(line: 31, column: 3, scope: !89)
!107 = !DILocation(line: 32, column: 16, scope: !89)
!108 = !DILocation(line: 33, column: 3, scope: !89)
!109 = !DILocation(line: 34, column: 3, scope: !89)
!110 = !DILocation(line: 35, column: 3, scope: !89)
!111 = !DISubprogram(name: "pthread_mutex_lock", scope: !112, file: !112, line: 794, type: !113, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!112 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!113 = !DISubroutineType(types: !114)
!114 = !{!19, !115}
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!116 = !DISubprogram(name: "pthread_cond_signal", scope: !112, file: !112, line: 1121, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DISubroutineType(types: !118)
!118 = !{!19, !119}
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!120 = !DISubprogram(name: "pthread_mutex_unlock", scope: !112, file: !112, line: 835, type: !113, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 38, type: !122, scopeLine: 38, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !124)
!122 = !DISubroutineType(types: !123)
!123 = !{!19}
!124 = !{!125, !126, !128}
!125 = !DILocalVariable(name: "threads_total", scope: !121, file: !9, line: 39, type: !19)
!126 = !DILocalVariable(name: "i", scope: !127, file: !9, line: 42, type: !19)
!127 = distinct !DILexicalBlock(scope: !121, file: !9, line: 42, column: 3)
!128 = !DILocalVariable(name: "tid", scope: !129, file: !9, line: 43, type: !131)
!129 = distinct !DILexicalBlock(scope: !130, file: !9, line: 42, column: 43)
!130 = distinct !DILexicalBlock(scope: !127, file: !9, line: 42, column: 3)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !132)
!132 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!133 = !DILocation(line: 0, scope: !121)
!134 = !DILocation(line: 0, scope: !127)
!135 = !DILocation(line: 42, column: 3, scope: !127)
!136 = !DILocation(line: 43, column: 5, scope: !129)
!137 = !DILocation(line: 43, column: 15, scope: !129)
!138 = !DILocation(line: 44, column: 5, scope: !129)
!139 = !DILocation(line: 45, column: 20, scope: !129)
!140 = !{!141, !141, i64 0}
!141 = !{!"long", !99, i64 0}
!142 = !DILocation(line: 45, column: 5, scope: !129)
!143 = !DILocation(line: 46, column: 3, scope: !130)
!144 = !DILocation(line: 46, column: 3, scope: !129)
!145 = !DILocation(line: 42, column: 39, scope: !130)
!146 = !DILocation(line: 42, column: 21, scope: !130)
!147 = distinct !{!147, !135, !148, !149, !150}
!148 = !DILocation(line: 46, column: 3, scope: !127)
!149 = !{!"llvm.loop.mustprogress"}
!150 = !{!"llvm.loop.unroll.disable"}
!151 = !DILocation(line: 49, column: 3, scope: !121)
!152 = !DILocation(line: 50, column: 10, scope: !121)
!153 = !DILocation(line: 50, column: 24, scope: !121)
!154 = !DILocation(line: 50, column: 3, scope: !121)
!155 = !DILocation(line: 51, column: 5, scope: !121)
!156 = distinct !{!156, !154, !157, !149, !150}
!157 = !DILocation(line: 51, column: 64, scope: !121)
!158 = !DILocation(line: 52, column: 3, scope: !121)
!159 = !DILocation(line: 55, column: 3, scope: !121)
!160 = !DILocation(line: 56, column: 10, scope: !121)
!161 = !DILocation(line: 56, column: 3, scope: !121)
!162 = !DILocation(line: 57, column: 5, scope: !121)
!163 = distinct !{!163, !161, !164, !149, !150}
!164 = !DILocation(line: 57, column: 64, scope: !121)
!165 = !DILocation(line: 58, column: 3, scope: !121)
!166 = !DILocation(line: 60, column: 10, scope: !121)
!167 = !DILocation(line: 60, column: 3, scope: !121)
!168 = !DISubprogram(name: "pthread_create", scope: !112, file: !112, line: 202, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!169 = !DISubroutineType(types: !170)
!170 = !{!19, !171, !173, !184, !185}
!171 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !172)
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!173 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !174)
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !175, size: 64)
!175 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !176)
!176 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !177)
!177 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !178)
!178 = !{!179, !183}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !177, file: !11, line: 58, baseType: !180, size: 448)
!180 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !181)
!181 = !{!182}
!182 = !DISubrange(count: 56)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !177, file: !11, line: 59, baseType: !42, size: 64)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!185 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!186 = !DISubprogram(name: "pthread_detach", scope: !112, file: !112, line: 269, type: !187, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!187 = !DISubroutineType(types: !188)
!188 = !{!19, !131}
!189 = !DISubprogram(name: "pthread_cond_wait", scope: !112, file: !112, line: 1133, type: !190, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!190 = !DISubroutineType(types: !191)
!191 = !{!19, !192, !193}
!192 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !119)
!193 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !115)
