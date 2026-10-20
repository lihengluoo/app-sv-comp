; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/thread-join-counter-inner-race.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }

@threads_alive = dso_local global i32 0, align 4, !dbg !0
@keep_alive = dso_local global i8 1, align 1, !dbg !7
@keep_alive_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !11
@data = dso_local global i32 0, align 4, !dbg !46
@data_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !48

; Function Attrs: nounwind uwtable
define dso_local ptr @thread(ptr noundef %arg) #0 !dbg !57 {
entry:
    #dbg_value(ptr %arg, !61, !DIExpression(), !62)
  %0 = load i32, ptr @threads_alive, align 4, !dbg !63, !tbaa !64
  %inc = add nsw i32 %0, 1, !dbg !63
  store i32 %inc, ptr @threads_alive, align 4, !dbg !63, !tbaa !64
  %call = call i32 @pthread_mutex_lock(ptr noundef @keep_alive_mutex) #3, !dbg !68
  %1 = load i8, ptr @keep_alive, align 1, !dbg !69, !tbaa !70, !range !72, !noundef !73
  %loadedv1 = trunc i8 %1 to i1, !dbg !69
  br i1 %loadedv1, label %while.body.lr.ph, label %while.end, !dbg !74

while.body.lr.ph:                                 ; preds = %entry
  br label %while.body, !dbg !74

while.body:                                       ; preds = %while.body.lr.ph, %while.body
  %call1 = call i32 @pthread_mutex_unlock(ptr noundef @keep_alive_mutex) #3, !dbg !75
  %call2 = call i32 @pthread_mutex_lock(ptr noundef @data_mutex) #3, !dbg !77
  store i32 4, ptr @data, align 4, !dbg !78, !tbaa !64
  %call3 = call i32 @pthread_mutex_unlock(ptr noundef @data_mutex) #3, !dbg !79
  %call4 = call i32 @pthread_mutex_lock(ptr noundef @keep_alive_mutex) #3, !dbg !80
  %2 = load i8, ptr @keep_alive, align 1, !dbg !69, !tbaa !70, !range !72, !noundef !73
  %loadedv = trunc i8 %2 to i1, !dbg !69
  br i1 %loadedv, label %while.body, label %while.cond.while.end_crit_edge, !dbg !74, !llvm.loop !81

while.cond.while.end_crit_edge:                   ; preds = %while.body
  br label %while.end, !dbg !74

while.end:                                        ; preds = %while.cond.while.end_crit_edge, %entry
  %call5 = call i32 @pthread_mutex_unlock(ptr noundef @keep_alive_mutex) #3, !dbg !85
  %3 = load i32, ptr @threads_alive, align 4, !dbg !86, !tbaa !64
  %dec = add nsw i32 %3, -1, !dbg !86
  store i32 %dec, ptr @threads_alive, align 4, !dbg !86, !tbaa !64
  ret ptr null, !dbg !87
}

; Function Attrs: nounwind
declare !dbg !88 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !93 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !94 {
entry:
  %tid = alloca i64, align 8
    #dbg_value(i32 4, !98, !DIExpression(), !106)
    #dbg_value(i32 0, !99, !DIExpression(), !107)
  br label %for.body, !dbg !108

for.cond.cleanup:                                 ; preds = %for.inc
  br label %for.end

for.body:                                         ; preds = %entry, %for.inc
  %i.03 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
    #dbg_value(i32 %i.03, !99, !DIExpression(), !107)
  call void @llvm.lifetime.start.p0(i64 8, ptr %tid) #3, !dbg !109
    #dbg_declare(ptr %tid, !101, !DIExpression(), !110)
  %call = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @thread, ptr noundef null) #3, !dbg !111
  %0 = load i64, ptr %tid, align 8, !dbg !112, !tbaa !113
  %call1 = call i32 @pthread_detach(i64 noundef %0) #3, !dbg !115
  call void @llvm.lifetime.end.p0(i64 8, ptr %tid) #3, !dbg !116
  br label %for.inc, !dbg !117

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i32 %i.03, 1, !dbg !118
    #dbg_value(i32 %inc, !99, !DIExpression(), !107)
  %exitcond = icmp ne i32 %inc, 4, !dbg !119
  br i1 %exitcond, label %for.body, label %for.cond.cleanup, !dbg !108, !llvm.loop !120

for.end:                                          ; preds = %for.cond.cleanup
  br label %while.cond, !dbg !122

while.cond:                                       ; preds = %while.cond, %for.end
  %1 = load i32, ptr @threads_alive, align 4, !dbg !123, !tbaa !64
  %cmp2 = icmp ne i32 %1, 4, !dbg !124
  br i1 %cmp2, label %while.cond, label %while.end, !dbg !122, !llvm.loop !125

while.end:                                        ; preds = %while.cond
  %call3 = call i32 @pthread_mutex_lock(ptr noundef @keep_alive_mutex) #3, !dbg !127
  store i8 0, ptr @keep_alive, align 1, !dbg !128, !tbaa !70
  %call4 = call i32 @pthread_mutex_unlock(ptr noundef @keep_alive_mutex) #3, !dbg !129
  br label %while.cond5, !dbg !130

while.cond5:                                      ; preds = %while.cond5, %while.end
  %2 = load i32, ptr @threads_alive, align 4, !dbg !131, !tbaa !64
  %tobool = icmp ne i32 %2, 0, !dbg !130
  br i1 %tobool, label %while.cond5, label %while.end7, !dbg !130, !llvm.loop !132

while.end7:                                       ; preds = %while.cond5
  %3 = load i32, ptr @data, align 4, !dbg !134, !tbaa !64
  ret i32 %3, !dbg !135
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !136 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !154 i32 @pthread_detach(i64 noundef) #1

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!50}
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "threads_alive", scope: !2, file: !9, line: 14, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/thread-join-counter-inner-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "d984105e372a5696f5714a02ab9d4e71")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !11, !46, !48}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "keep_alive", scope: !2, file: !9, line: 16, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "thread-join-counter-inner-race.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "d984105e372a5696f5714a02ab9d4e71")
!10 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "keep_alive_mutex", scope: !2, file: !9, line: 17, type: !13, isLocal: false, isDefinition: true)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !14, line: 72, baseType: !15)
!14 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!15 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !14, line: 67, size: 320, elements: !16)
!16 = !{!17, !39, !44}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !15, file: !14, line: 69, baseType: !18, size: 320)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !19, line: 22, size: 320, elements: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!20 = !{!21, !23, !25, !26, !27, !28, !30, !31}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !18, file: !19, line: 24, baseType: !22, size: 32)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !18, file: !19, line: 25, baseType: !24, size: 32, offset: 32)
!24 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !18, file: !19, line: 26, baseType: !22, size: 32, offset: 64)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !18, file: !19, line: 28, baseType: !24, size: 32, offset: 96)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !18, file: !19, line: 32, baseType: !22, size: 32, offset: 128)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !18, file: !19, line: 34, baseType: !29, size: 16, offset: 160)
!29 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !18, file: !19, line: 35, baseType: !29, size: 16, offset: 176)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !18, file: !19, line: 36, baseType: !32, size: 128, offset: 192)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !33, line: 55, baseType: !34)
!33 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !33, line: 51, size: 128, elements: !35)
!35 = !{!36, !38}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !34, file: !33, line: 53, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !34, file: !33, line: 54, baseType: !37, size: 64, offset: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !15, file: !14, line: 70, baseType: !40, size: 320)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 320, elements: !42)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !{!43}
!43 = !DISubrange(count: 40)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !15, file: !14, line: 71, baseType: !45, size: 64)
!45 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 19, type: !22, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "data_mutex", scope: !2, file: !9, line: 20, type: !13, isLocal: false, isDefinition: true)
!50 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 8, !"PIC Level", i32 2}
!55 = !{i32 7, !"PIE Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 2}
!57 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 22, type: !58, scopeLine: 22, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{!5, !5}
!60 = !{!61}
!61 = !DILocalVariable(name: "arg", arg: 1, scope: !57, file: !9, line: 22, type: !5)
!62 = !DILocation(line: 0, scope: !57)
!63 = !DILocation(line: 23, column: 16, scope: !57)
!64 = !{!65, !65, i64 0}
!65 = !{!"int", !66, i64 0}
!66 = !{!"omnipotent char", !67, i64 0}
!67 = !{!"Simple C/C++ TBAA"}
!68 = !DILocation(line: 25, column: 3, scope: !57)
!69 = !DILocation(line: 26, column: 10, scope: !57)
!70 = !{!71, !71, i64 0}
!71 = !{!"_Bool", !66, i64 0}
!72 = !{i8 0, i8 2}
!73 = !{}
!74 = !DILocation(line: 26, column: 3, scope: !57)
!75 = !DILocation(line: 27, column: 5, scope: !76)
!76 = distinct !DILexicalBlock(scope: !57, file: !9, line: 26, column: 22)
!77 = !DILocation(line: 29, column: 5, scope: !76)
!78 = !DILocation(line: 30, column: 10, scope: !76)
!79 = !DILocation(line: 31, column: 5, scope: !76)
!80 = !DILocation(line: 33, column: 5, scope: !76)
!81 = distinct !{!81, !74, !82, !83, !84}
!82 = !DILocation(line: 34, column: 3, scope: !57)
!83 = !{!"llvm.loop.mustprogress"}
!84 = !{!"llvm.loop.unroll.disable"}
!85 = !DILocation(line: 35, column: 3, scope: !57)
!86 = !DILocation(line: 37, column: 16, scope: !57)
!87 = !DILocation(line: 38, column: 3, scope: !57)
!88 = !DISubprogram(name: "pthread_mutex_lock", scope: !89, file: !89, line: 794, type: !90, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!89 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!90 = !DISubroutineType(types: !91)
!91 = !{!22, !92}
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!93 = !DISubprogram(name: "pthread_mutex_unlock", scope: !89, file: !89, line: 835, type: !90, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!94 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 41, type: !95, scopeLine: 41, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !97)
!95 = !DISubroutineType(types: !96)
!96 = !{!22}
!97 = !{!98, !99, !101}
!98 = !DILocalVariable(name: "threads_total", scope: !94, file: !9, line: 42, type: !22)
!99 = !DILocalVariable(name: "i", scope: !100, file: !9, line: 45, type: !22)
!100 = distinct !DILexicalBlock(scope: !94, file: !9, line: 45, column: 3)
!101 = !DILocalVariable(name: "tid", scope: !102, file: !9, line: 46, type: !104)
!102 = distinct !DILexicalBlock(scope: !103, file: !9, line: 45, column: 43)
!103 = distinct !DILexicalBlock(scope: !100, file: !9, line: 45, column: 3)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !14, line: 27, baseType: !105)
!105 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!106 = !DILocation(line: 0, scope: !94)
!107 = !DILocation(line: 0, scope: !100)
!108 = !DILocation(line: 45, column: 3, scope: !100)
!109 = !DILocation(line: 46, column: 5, scope: !102)
!110 = !DILocation(line: 46, column: 15, scope: !102)
!111 = !DILocation(line: 47, column: 5, scope: !102)
!112 = !DILocation(line: 48, column: 20, scope: !102)
!113 = !{!114, !114, i64 0}
!114 = !{!"long", !66, i64 0}
!115 = !DILocation(line: 48, column: 5, scope: !102)
!116 = !DILocation(line: 49, column: 3, scope: !103)
!117 = !DILocation(line: 49, column: 3, scope: !102)
!118 = !DILocation(line: 45, column: 39, scope: !103)
!119 = !DILocation(line: 45, column: 21, scope: !103)
!120 = distinct !{!120, !108, !121, !83, !84}
!121 = !DILocation(line: 49, column: 3, scope: !100)
!122 = !DILocation(line: 52, column: 3, scope: !94)
!123 = !DILocation(line: 52, column: 10, scope: !94)
!124 = !DILocation(line: 52, column: 24, scope: !94)
!125 = distinct !{!125, !122, !126, !83, !84}
!126 = !DILocation(line: 52, column: 41, scope: !94)
!127 = !DILocation(line: 55, column: 3, scope: !94)
!128 = !DILocation(line: 56, column: 14, scope: !94)
!129 = !DILocation(line: 57, column: 3, scope: !94)
!130 = !DILocation(line: 60, column: 3, scope: !94)
!131 = !DILocation(line: 60, column: 10, scope: !94)
!132 = distinct !{!132, !130, !133, !83, !84}
!133 = !DILocation(line: 60, column: 24, scope: !94)
!134 = !DILocation(line: 62, column: 10, scope: !94)
!135 = !DILocation(line: 62, column: 3, scope: !94)
!136 = !DISubprogram(name: "pthread_create", scope: !89, file: !89, line: 202, type: !137, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!137 = !DISubroutineType(types: !138)
!138 = !{!22, !139, !141, !152, !153}
!139 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !140)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!141 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !142)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !144)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !14, line: 62, baseType: !145)
!145 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !14, line: 56, size: 448, elements: !146)
!146 = !{!147, !151}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !145, file: !14, line: 58, baseType: !148, size: 448)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 448, elements: !149)
!149 = !{!150}
!150 = !DISubrange(count: 56)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !145, file: !14, line: 59, baseType: !45, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!154 = !DISubprogram(name: "pthread_detach", scope: !89, file: !89, line: 269, type: !155, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DISubroutineType(types: !156)
!156 = !{!22, !104}
