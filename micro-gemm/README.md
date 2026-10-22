# micro-gemm: GEMM concurrency-pattern micro-suite

Standalone C programs, one per concurrency pattern that
[`applications/gemm`](../../../applications/gemm) relies on after the
create/join simplification, so the Delphi compiler can prove each pattern
in isolation.  Every benchmark is a complete program: it computes a small
int8 x int8 -> int32 column product over a partitioned output, checks the
result against a serial reference, and prints `PASS <stem>` (the
deliberate `*_race.c` mutations print `DONE` because their results are
nondeterministic).

## Build and run

```sh
make native   # compile and run every benchmark natively (self-check)
make ir       # capture one <stem>.ll per benchmark via the shared build.sh
make test     # run delphi-compiler on every captured benchmark and score it
make clean
```

IR capture goes through the repository-wide `scripts/build.sh`; captured
`.ll` files are untracked build products.  `make test` scores compiler
exit codes against the ground-truth table embedded in `run_suite.sh`:
DRF benchmarks must prove (exit 0), RACE benchmarks must come back
unresolved (exit 2).  Per-run logs land in `results/<stamp>/`.

## Pattern catalog

| Benchmark | Pattern distilled from applications/gemm | Obligation |
|---|---|---|
| `create_join_plain` | lone worker returns through join (`blas_server.c` exec_blas) | thread order baseline |
| `job_descriptor_copy` | queue nodes written before create, privately copied by workers (`gemm_thread_n.c`) | immutable job descriptors |
| `partition_columns` | balanced disjoint N-slices (`blas_quickdivide` loop) | memory partitioning |
| `partition_block_tails` | N range in column blocks, k in chunks with remainder tails (`level3.c`) | partition through nested block loops |
| `caller_first_slice` | queue node 0 runs on the caller while workers run (`exec_blas`) | caller participation in the partition |
| `join_indexed_prefix` | pthread_t array, indexed create/join, inline remainder on create failure (`exec_blas`) | indexed join over the successful prefix |
| `worker_private_scratch` | per-worker packing buffer from alloc/free (`blas_job_thread`) | private scratch, no sharing |
| `shared_readonly_inputs` | A/B read by every worker across full ranges | read-only sharing is not a race |
| `sequential_calls` | repeated calls re-partitioning the same C | inter-call ordering via join |
| `concurrent_calls` | two parent threads each running their own create/join group | concurrent independent calls |
| `init_once_mutex` | lazy shared-table init behind mutex + atomic flag (`memory.c` alloc_lock) | lockset exclusion and publication |
| `init_once_spinlock` | same with the cmpxchg spinlock shape (`blas_lock`) | open: atomic fast path + spinlock |
| `atomic_thread_count` | `_Atomic blas_cpu_number` read by workers to derive slices | atomic publication |
| `*_race.c` | one deliberate mutation per family (overlapping slices, post-create descriptor write, missing join, shared scratch, input write, unlocked init, overlapping calls) | the checker must flag all of them |

## Conventions

- Sizes stay tiny (`rows = 64`, `columns = 64`, `depth = 48`, four
  workers) so loops normalize to counted forms the compiler handles.
- Inputs are static globals; only the partitioned output (and the
  init-once table where the pattern needs it) is shared writable state.
- Every benchmark exits 0; a native `FAIL` line means the program itself
  is wrong, not the pattern.
- Ground truth was audited by construction and exercised with
  `-fsanitize=thread` builds (`cc -fsanitize=thread <stem>.c`); rerun that
  on a host where TSan's shadow mapping works (kernels with
  `vm.mmap_rnd_bits=32` need it lowered to 28) — positives must stay
  silent and every `*_race.c` must be flagged.
- To add a pattern: write `<stem>.c` with a serial reference check, add
  it to the verdict table in `run_suite.sh` (drf), and extend this table.
  Deliberate mutations use the `_race` suffix and a `// RACE!` comment on
  the racing lines.
