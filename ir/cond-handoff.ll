; ModuleID = '/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm/cond-handoff.linked.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }

@done_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@done_cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !7
@data = dso_local global i32 0, align 4, !dbg !47

; Function Attrs: nounwind uwtable
define dso_local ptr @worker(ptr noundef %arg) #0 !dbg !85 {
entry:
    #dbg_value(ptr %arg, !89, !DIExpression(), !90)
  store i32 1, ptr @data, align 4, !dbg !91, !tbaa !92
  %call = call i32 @pthread_mutex_lock(ptr noundef @done_mutex) #4, !dbg !96
  %call1 = call i32 @pthread_cond_signal(ptr noundef @done_cond) #4, !dbg !97
  %call2 = call i32 @pthread_mutex_unlock(ptr noundef @done_mutex) #4, !dbg !98
  ret ptr null, !dbg !99
}

; Function Attrs: nounwind
declare !dbg !100 i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !105 i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: nounwind
declare !dbg !109 i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 !dbg !110 {
entry:
  %tid = alloca i64, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr %tid) #4, !dbg !117
    #dbg_declare(ptr %tid, !114, !DIExpression(), !118)
  %call = call i32 @pthread_create(ptr noundef %tid, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !119
  %call1 = call i32 @pthread_mutex_lock(ptr noundef @done_mutex) #4, !dbg !120
  %call2 = call i32 @pthread_cond_wait(ptr noundef @done_cond, ptr noundef @done_mutex), !dbg !121
  %call3 = call i32 @pthread_mutex_unlock(ptr noundef @done_mutex) #4, !dbg !122
  %0 = load i32, ptr @data, align 4, !dbg !123, !tbaa !92
  call void @llvm.lifetime.end.p0(i64 8, ptr %tid) #4, !dbg !124
  ret i32 %0, !dbg !125
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: nounwind
declare !dbg !126 i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare !dbg !144 i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!78}
!llvm.module.flags = !{!79, !80, !81, !82, !83, !84}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "done_mutex", scope: !2, file: !9, line: 6, type: !50, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/liheng/proj-Delphi/applications/micro-apps/cond-handoff.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps/ir/wllvm", checksumkind: CSK_MD5, checksum: "246d5382bb6ffed6b2f55492181680c6")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !47}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "done_cond", scope: !2, file: !9, line: 7, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "cond-handoff.c", directory: "/home/liheng/proj-Delphi/applications/micro-apps", checksumkind: CSK_MD5, checksum: "246d5382bb6ffed6b2f55492181680c6")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !11, line: 80, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8a5acdbeec491eca11cf81cb1ef77ea7")
!12 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 75, size: 384, elements: !13)
!13 = !{!14, !40, !45}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !12, file: !11, line: 77, baseType: !15, size: 384)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !16, line: 94, size: 384, elements: !17)
!16 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "b9a7199822bce372686baacd32a9f4f3")
!17 = !{!18, !31, !32, !36, !37, !38, !39}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !15, file: !16, line: 96, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !20, line: 33, baseType: !21)
!20 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "d1ec99b0f6e36c0a42ac284d459cbd38")
!21 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !20, line: 25, size: 64, elements: !22)
!22 = !{!23, !25}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !21, file: !20, line: 27, baseType: !24, size: 64)
!24 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !21, file: !20, line: 32, baseType: !26, size: 64)
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !21, file: !20, line: 28, size: 64, elements: !27)
!27 = !{!28, !30}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !26, file: !20, line: 30, baseType: !29, size: 32)
!29 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !26, file: !20, line: 31, baseType: !29, size: 32, offset: 32)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !15, file: !16, line: 97, baseType: !19, size: 64, offset: 64)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "__g_refs", scope: !15, file: !16, line: 98, baseType: !33, size: 64, offset: 128)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 64, elements: !34)
!34 = !{!35}
!35 = !DISubrange(count: 2)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !15, file: !16, line: 99, baseType: !33, size: 64, offset: 192)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !15, file: !16, line: 100, baseType: !29, size: 32, offset: 256)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !15, file: !16, line: 101, baseType: !29, size: 32, offset: 288)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !15, file: !16, line: 102, baseType: !33, size: 64, offset: 320)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !12, file: !11, line: 78, baseType: !41, size: 384)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 384, elements: !43)
!42 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!43 = !{!44}
!44 = !DISubrange(count: 48)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !12, file: !11, line: 79, baseType: !46, size: 64)
!46 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !9, line: 9, type: !49, isLocal: false, isDefinition: true)
!49 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !11, line: 72, baseType: !51)
!51 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !11, line: 67, size: 320, elements: !52)
!52 = !{!53, !72, !76}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !51, file: !11, line: 69, baseType: !54, size: 320)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !55, line: 22, size: 320, elements: !56)
!55 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "6b075eca9ab0e2d761b2afc4ecfab776")
!56 = !{!57, !58, !59, !60, !61, !62, !64, !65}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !54, file: !55, line: 24, baseType: !49, size: 32)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !54, file: !55, line: 25, baseType: !29, size: 32, offset: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !54, file: !55, line: 26, baseType: !49, size: 32, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !54, file: !55, line: 28, baseType: !29, size: 32, offset: 96)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !54, file: !55, line: 32, baseType: !49, size: 32, offset: 128)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !54, file: !55, line: 34, baseType: !63, size: 16, offset: 160)
!63 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !54, file: !55, line: 35, baseType: !63, size: 16, offset: 176)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !54, file: !55, line: 36, baseType: !66, size: 128, offset: 192)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !16, line: 55, baseType: !67)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !16, line: 51, size: 128, elements: !68)
!68 = !{!69, !71}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !67, file: !16, line: 53, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !67, file: !16, line: 54, baseType: !70, size: 64, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !51, file: !11, line: 70, baseType: !73, size: 320)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 320, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 40)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !51, file: !11, line: 71, baseType: !77, size: 64)
!77 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!78 = !{!"clang version 21.1.0 (git@github.com:TELOS-syslab/proj-Delphi.git 60f1dce9c593044b6c52f6f8f47720ec6bbcd762)"}
!79 = !{i32 7, !"Dwarf Version", i32 5}
!80 = !{i32 2, !"Debug Info Version", i32 3}
!81 = !{i32 1, !"wchar_size", i32 4}
!82 = !{i32 8, !"PIC Level", i32 2}
!83 = !{i32 7, !"PIE Level", i32 2}
!84 = !{i32 7, !"uwtable", i32 2}
!85 = distinct !DISubprogram(name: "worker", scope: !9, file: !9, line: 11, type: !86, scopeLine: 11, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !88)
!86 = !DISubroutineType(types: !87)
!87 = !{!5, !5}
!88 = !{!89}
!89 = !DILocalVariable(name: "arg", arg: 1, scope: !85, file: !9, line: 11, type: !5)
!90 = !DILocation(line: 0, scope: !85)
!91 = !DILocation(line: 12, column: 8, scope: !85)
!92 = !{!93, !93, i64 0}
!93 = !{!"int", !94, i64 0}
!94 = !{!"omnipotent char", !95, i64 0}
!95 = !{!"Simple C/C++ TBAA"}
!96 = !DILocation(line: 13, column: 3, scope: !85)
!97 = !DILocation(line: 14, column: 3, scope: !85)
!98 = !DILocation(line: 15, column: 3, scope: !85)
!99 = !DILocation(line: 16, column: 3, scope: !85)
!100 = !DISubprogram(name: "pthread_mutex_lock", scope: !101, file: !101, line: 794, type: !102, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!101 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "cbcd748b3d3ecaa7356dc2925b45d819")
!102 = !DISubroutineType(types: !103)
!103 = !{!49, !104}
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!105 = !DISubprogram(name: "pthread_cond_signal", scope: !101, file: !101, line: 1121, type: !106, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!106 = !DISubroutineType(types: !107)
!107 = !{!49, !108}
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!109 = !DISubprogram(name: "pthread_mutex_unlock", scope: !101, file: !101, line: 835, type: !102, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!110 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 19, type: !111, scopeLine: 19, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !113)
!111 = !DISubroutineType(types: !112)
!112 = !{!49}
!113 = !{!114}
!114 = !DILocalVariable(name: "tid", scope: !110, file: !9, line: 20, type: !115)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !11, line: 27, baseType: !116)
!116 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!117 = !DILocation(line: 20, column: 3, scope: !110)
!118 = !DILocation(line: 20, column: 13, scope: !110)
!119 = !DILocation(line: 21, column: 3, scope: !110)
!120 = !DILocation(line: 23, column: 3, scope: !110)
!121 = !DILocation(line: 24, column: 3, scope: !110)
!122 = !DILocation(line: 25, column: 3, scope: !110)
!123 = !DILocation(line: 27, column: 10, scope: !110)
!124 = !DILocation(line: 28, column: 1, scope: !110)
!125 = !DILocation(line: 27, column: 3, scope: !110)
!126 = !DISubprogram(name: "pthread_create", scope: !101, file: !101, line: 202, type: !127, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!127 = !DISubroutineType(types: !128)
!128 = !{!49, !129, !131, !142, !143}
!129 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !130)
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!131 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !132)
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!133 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !134)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !11, line: 62, baseType: !135)
!135 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !11, line: 56, size: 448, elements: !136)
!136 = !{!137, !141}
!137 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !135, file: !11, line: 58, baseType: !138, size: 448)
!138 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 448, elements: !139)
!139 = !{!140}
!140 = !DISubrange(count: 56)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !135, file: !11, line: 59, baseType: !77, size: 64)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!144 = !DISubprogram(name: "pthread_cond_wait", scope: !101, file: !101, line: 1133, type: !145, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!145 = !DISubroutineType(types: !146)
!146 = !{!49, !147, !148}
!147 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !108)
!148 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !104)
