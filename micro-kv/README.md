# micro-kv: linked-list micro-benchmark

Two sv-comp-style benchmarks distilled from
[`applications/kv`](../../../applications/kv): `list-walk-free.c` walks a
malloc'd four-node chain under the list mutex (race-free by
construction), and `list-walk-race.c` is the same program minus the
lock/unlock pair (racy).  Sizes are plain locals, all state travels
through the thread argument, and the programs carry no self-checks:
the compiler is the only consumer.  The pair is the minimal shape of
`kvs_get`'s chain traversal — heap nodes and a null-tail walk — which
the full `kvs.ll` leaves unresolved.

## Running

```sh
make -C applications/micro-apps/micro-kv test \
  CLANG=clang WLLVM=wllvm COMPILER=../../compiler/build/delphi-compiler
```

`make ir` captures one `.ll` per source through the repository-wide
`scripts/build.sh` (pass `CLANG`/`WLLVM` when the tools are not on
PATH; the sibling default paths work from the suite directory).
`make test` runs `run_suite.py`, which scores compiler results against
`verdicts.json` the sv-comp way: the run fails only when a benchmark
yields no verdict (compiler exit 1 or a timeout); disagreements are
scores — `correct` / `correct warning` / `false alarm` / `miss`.
Artifacts land in `results/<stamp>/` (`runs.json`, `summary.md`,
per-file stdout/stderr/pair dumps).  `--check-race-lines` audits that
every `// RACE!` source line appears as an access in the pair dump.

## Status (2026-10-22)

1 correct warning, 1 correct, 0 false alarm, 0 miss.  The walk loop's
header abstraction used to drop every held lock, so even the mutex-held
walk in `list-walk-free.c` reported its `node->data += 1` pairs
(`overlap remains possible in the approximation`).  `summarize_loop` now
keeps entry-held locks that no call inside the loop may release
(`keeps_mutex` decides by lock-range overlap), so the held walk proves
its exclusion and both files score as constructed.  The racy file is
unchanged: without any lock the same pairs remain the true race.
