# micro-gemm: GEMM concurrency-pattern micro-suite

Standalone C programs, one **dual pair** per concurrency pattern that
[`applications/gemm`](../../../applications/gemm) relies on after the
create/join simplification: a race-free `<pattern>.c` and its single
minimal mutation `<pattern>_race.c`.  Every benchmark computes a true
int8 GEMM — `C = alpha * A * B + beta * C`, A row-major, B
column-major, beta pre-scale then alpha-accumulate per worker slice —
checks the result against a serial reference, and prints
`PASS <stem>`; the `_race.c` mutations print `DONE` because their
results are nondeterministic.

Scalar benchmarks run anywhere; the three `*_simd.c` pairs use the
AVX-512 VNNI kernel scheme of the gemm 4509y backend (int8 widened to
int16 lanes, `_mm512_dpwssd_epi32` pair accumulation) and are
**analysis-only** on hosts without AVX-512 VNNI — `make native` skips
them, `make ir` captures them like everything else.

## Build and run

```sh
make native           # compile and run every scalar benchmark (self-check)
make ir               # capture one <stem>.ll per benchmark via the shared build.sh
make test             # run delphi-compiler on every captured benchmark and score it
make audit-externals  # every external the gemm IR declares must appear in the suite IR
make clean
```

IR capture goes through the repository-wide `scripts/build.sh` (the
`*_simd.c` kernels carry `__attribute__((target(...)))` so no extra
compile flags are needed); captured `.ll` files are untracked build
products.  `make test` scores compiler exit codes against the
ground-truth table embedded in `run_suite.sh`: DRF benchmarks must
prove (exit 0), RACE benchmarks must come back unresolved (exit 2).
Per-run logs land in `results/<stamp>/`.

## Dual catalog

| Pair | Pattern distilled from applications/gemm | Obligation |
|---|---|---|
| `create_join_plain` | lone worker returns through join (`blas_server.c` exec_blas) | thread order baseline |
| `job_descriptor_copy` | queue nodes written before create, privately copied by workers (`gemm_thread_n.c`) | immutable job descriptors |
| `partition_columns` | balanced disjoint N-slices (`blas_quickdivide` loop) | memory partitioning |
| `partition_block_tails` | N range in column blocks with min-clamped ends, k in chunks with remainder tails (`level3.c`) | partition through nested block loops |
| `caller_first_slice` | queue node 0 runs on the caller while workers run (`exec_blas`) | caller participation in the partition |
| `join_indexed_prefix` | pthread_t array, indexed create/join, inline remainder on create failure (`exec_blas`) | indexed join over the successful prefix |
| `worker_private_scratch` | per-worker packing buffer from the memory pool: alignment guard, memcpy pack, sfence before free (`memory.c`, `blas_job_thread`) | private scratch, no sharing |
| `shared_readonly_inputs` | A/B read by every worker across full ranges | read-only sharing is not a race |
| `sequential_calls` | repeated calls re-partitioning the same C; beta=0 then beta=1 | inter-call ordering via join |
| `concurrent_calls` | two parent threads each running their own create/join group | concurrent independent calls |
| `init_once_mutex` | shared table behind mutex + atomic flag (`memory.c` buffer pool) | lockset exclusion and publication |
| `init_once_spinlock` | same with the cmpxchg spinlock shape (`blas_lock`) | open: atomic fast path + spinlock |
| `atomic_thread_count` | `_Atomic blas_cpu_number` read by workers to derive slices | atomic publication |
| `mode_dispatch` | switch on mode bits routes each job to a kernel path (`blas_server.c`) | dispatch keeps the partition |
| `tls_thread_slots` | `__thread` cancel slot consulted inside the kernel loops (`openblas_cancel.c`) | thread-local state is private |
| `partition_columns_simd` | the partition pattern through the VNNI kernel | SIMD compute path |
| `caller_first_slice_simd` | caller participation through the VNNI kernel | SIMD + caller slice |
| `worker_scratch_pack_simd` | private packed-column scratch feeding the VNNI kernel | SIMD + private packing |

Mutations, one per pair: over-wide slices (partition, block tails,
caller, dispatch, SIMD variants), post-create descriptor write, missing
join, shared scratch, input write, unlocked or wrongly-scoped init,
worker-republished count, shared TLS slot, overlapping calls.  Racing
lines carry `// RACE!` comments.

## Minimal external contract

`applications/gemm` is deliberately built against a minimal external
surface; `make audit-externals` enforces that every function the
captured gemm IR declares also appears in the suite IR (linker
`--wrap` artifacts, `@__real_*`, are harness plumbing and excluded):

| gemm external | Covered by |
|---|---|
| `pthread_create`, `pthread_join` | every pair |
| `pthread_mutex_lock`, `pthread_mutex_unlock` | init_once_mutex |
| `aligned_alloc`, `free` | worker_private_scratch, tls_thread_slots, worker_scratch_pack_simd |
| `abort` | alignment guard in the scratch benchmarks |
| `printf` | the `PASS`/`DONE` report lines (the compiler summarizes printf as touching no user memory) |
| `llvm.memcpy`, `llvm.memset`, `llvm.threadlocal.address` and other intrinsics | packing, output init, `__thread` slot |

The library reads no environment, probes no CPUs, and uses no TLS keys,
mmap, or error-print paths — those all left `applications/gemm` in the
minimal-library round; the pool in `memory.c` is a mutex-guarded free
list over `aligned_alloc` blocks.

## Conventions

- Sizes stay tiny (`rows_m = 64`, `cols_n = 64`, `depth_k = 64`, four
  workers; `partition_block_tails` uses odd 61 sizes to force tails) so
  loops normalize to counted forms the compiler handles.
- Inputs are static globals; only the partitioned output (and the
  init-once table where the pattern needs it) is shared writable state.
- Every benchmark exits 0; a native `FAIL` line means the program itself
  is wrong, not the pattern.
- To add a pattern: write the dual pair `<stem>.c` / `<stem>_race.c`
  with a serial reference check and one minimal mutation, add both to
  the verdict table in `run_suite.sh`, and extend the tables above.
- Ground truth was audited by construction and exercised with
  `-fsanitize=thread` builds (`cc -fsanitize=thread <stem>.c`); rerun
  that on a host where TSan's shadow mapping works (kernels with
  `vm.mmap_rnd_bits=32` need it lowered to 28) — positives must stay
  silent and every `*_race.c` must be flagged.
