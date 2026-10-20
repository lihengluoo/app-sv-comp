; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-counter-outer-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@threads_alive = dso_local global i32 0, align 4, !dbg !0
@data = dso_local global i32 0, align 4, !dbg !7
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !11

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !52 {
entry:
    #dbg_value(ptr %arg, !56, !DIExpression(), !57)
  %call = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #3, !dbg !58
  store i32 4, ptr @data, align 4, !dbg !59, !tbaa !60
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #3, !dbg !64
  %0 = load i32, ptr @threads_alive, align 4, !dbg !65, !tbaa !60
  %dec = add nsw i32 %0, -1, !dbg !65
  store i32 %dec, ptr @threads_alive, align 4, !dbg !65, !tbaa !60
  ret ptr null, !dbg !66
}

; Function Attrs: nounwind
declare !dbg !67 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !72 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !73 {
entry:
  %tid = alloca i64, align 8
    #dbg_value(i32 4, !77, !DIExpression(), !85)
    #dbg_value(i32 0, !78, !DIExpression(), !86)
  br label %for.body, !dbg !87

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %i.02 = phi i32 [ 0, %entry ], [ %inc2, %for.inc ]
    #dbg_value(i32 %i.02, !78, !DIExpression(), !86)
  %0 = load i32, ptr @threads_alive, align 4, !dbg !88, !tbaa !60
  %inc = add nsw i32 %0, 1, !dbg !88
  store i32 %inc, ptr @threads_alive, align 4, !dbg !88, !tbaa !60
  call void @llvm.lifetime.start.p0(i64 8, ptr %tid) #3, !dbg !89
    #dbg_declare(ptr %tid, !80, !DIExpression(), !90)
  %call = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef null) #3, !dbg !91
  %1 = load i64, ptr %tid, align 8, !dbg !92, !tbaa !93
  %call1 = call i32 @pthread_detach(i64 noundef %1) #3, !dbg !95
  call void @llvm.lifetime.end.p0(i64 8, ptr %tid) #3, !dbg !96
  br label %for.inc, !dbg !97

for.inc:                                          ; preds = %for.body
  %inc2 = add nuw nsw i32 %i.02, 1, !dbg !98
    #dbg_value(i32 %inc2, !78, !DIExpression(), !86)
  %exitcond = icmp ne i32 %inc2, 4, !dbg !99
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !87, !llvm.loop !100

for.end:                                          ; preds = %for.cond.cleanup
  br label %while.cond, !dbg !104

while.cond:                                       ; preds = %while.cond, %for.end
  %2 = load i32, ptr @threads_alive, align 4, !dbg !105, !tbaa !60
  %tobool = icmp ne i32 %2, 0, !dbg !104
  br i1 %tobool, label %while.cond, label %while.end, !dbg !104, !llvm.loop !106

while.end:                                        ; preds = %while.cond
  %3 = load i32, ptr @data, align 4, !dbg !108, !tbaa !60
  ret i32 %3, !dbg !109
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !110 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !128 i32 @pthread_detach(i64 noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!45}
!llvm.module.flags = !{!46, !47, !48, !49, !50, !51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !9, line: 13, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-counter-outer-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "c6e4de6e491855b437ec5005e9bb234f")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !11}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 15, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-join-counter-outer-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "c6e4de6e491855b437ec5005e9bb234f")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 16, type: !13, isLocal: false, isDefinition: true)
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
!59 = !DILocation(line: 20, column: 8, scope: !52)
!60 = !{!61, !61, i64 0}
!61 = !{!"int", !62, i64 0}
!62 = !{!"omnipotent char", !63, i64 0}
!63 = !{!"Simple C/C++ TBAA"}
!64 = !DILocation(line: 21, column: 3, scope: !52)
!65 = !DILocation(line: 23, column: 16, scope: !52)
!66 = !DILocation(line: 24, column: 3, scope: !52)
!67 = !DISubprogram(name: "pthread_mutex_lock", scope: !68, file: !68, line: 794, type: !69, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!68 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!69 = !DISubroutineType(types: !70)
!70 = !{!10, !71}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!72 = !DISubprogram(name: "pthread_mutex_unlock", scope: !68, file: !68, line: 835, type: !69, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!73 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 27, type: !74, scopeLine: 27, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !76)
!74 = !DISubroutineType(types: !75)
!75 = !{!10}
!76 = !{!77, !78, !80}
!77 = !DILocalVariable(name: "threads_total", scope: !73, file: !9, line: 28, type: !10)
!78 = !DILocalVariable(name: "i", scope: !79, file: !9, line: 31, type: !10)
!79 = distinct !DILexicalBlock(scope: !73, file: !9, line: 31, column: 3)
!80 = !DILocalVariable(name: "tid", scope: !81, file: !9, line: 34, type: !83)
!81 = distinct !DILexicalBlock(scope: !82, file: !9, line: 31, column: 43)
!82 = distinct !DILexicalBlock(scope: !79, file: !9, line: 31, column: 3)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !14, line: 27, baseType: !84)
!84 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!85 = !DILocation(line: 0, scope: !73)
!86 = !DILocation(line: 0, scope: !79)
!87 = !DILocation(line: 31, column: 3, scope: !79)
!88 = !DILocation(line: 32, column: 18, scope: !81)
!89 = !DILocation(line: 34, column: 5, scope: !81)
!90 = !DILocation(line: 34, column: 15, scope: !81)
!91 = !DILocation(line: 35, column: 5, scope: !81)
!92 = !DILocation(line: 36, column: 20, scope: !81)
!93 = !{!94, !94, i64 0}
!94 = !{!"long", !62, i64 0}
!95 = !DILocation(line: 36, column: 5, scope: !81)
!96 = !DILocation(line: 37, column: 3, scope: !82)
!97 = !DILocation(line: 37, column: 3, scope: !81)
!98 = !DILocation(line: 31, column: 39, scope: !82)
!99 = !DILocation(line: 31, column: 21, scope: !82)
!100 = distinct !{!100, !87, !101, !102, !103}
!101 = !DILocation(line: 37, column: 3, scope: !79)
!102 = !{!"llvm.loop.mustprogress"}
!103 = !{!"llvm.loop.unroll.disable"}
!104 = !DILocation(line: 40, column: 3, scope: !73)
!105 = !DILocation(line: 40, column: 10, scope: !73)
!106 = distinct !{!106, !104, !107, !102, !103}
!107 = !DILocation(line: 40, column: 24, scope: !73)
!108 = !DILocation(line: 42, column: 10, scope: !73)
!109 = !DILocation(line: 42, column: 3, scope: !73)
!110 = !DISubprogram(name: "pthread_create", scope: !68, file: !68, line: 202, type: !111, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DISubroutineType(types: !112)
!112 = !{!10, !113, !115, !126, !127}
!113 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !114)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !116)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !118)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !14, line: 62, baseType: !119)
!119 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !14, line: 56, size: 448, elements: !120)
!120 = !{!121, !125}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !119, file: !14, line: 58, baseType: !122, size: 448)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 448, elements: !123)
!123 = !{!124}
!124 = !DISubrange(count: 56)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !119, file: !14, line: 59, baseType: !44, size: 64)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!127 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!128 = !DISubprogram(name: "pthread_detach", scope: !68, file: !68, line: 269, type: !129, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!129 = !DISubroutineType(types: !130)
!130 = !{!10, !83}
