#!/usr/bin/env bash
# Run the Delphi compiler on every captured micro-gemm benchmark and score
# the exit status against the verdict table below.
#
# Usage: run_suite.sh [--compiler PATH] [--ir-dir DIR] [--symbex-timeout-ms N]
#
# Compiler exit codes: 0 = DRF proof, 2 = unresolved pairs, anything else is
# an error.  DRF benchmarks must prove (0); RACE benchmarks, the deliberate
# mutations, must come back unresolved (2).  Any other combination is a
# mismatch and fails the suite.  Each benchmark runs independently; per-run
# logs and pair dumps land under results/<stamp>/.
set -u

compiler=../../../compiler/build/delphi-compiler
ir_dir=build/ir
symbex_timeout_ms=20

# Ground truth per dual pair.  DRF: the pattern is race free by
# construction.  RACE: the *_race.c mutations carry a real data race.
# Every pair must appear on both lists.
expect_drf="create_join_plain \
job_descriptor_copy \
partition_columns \
partition_block_tails \
caller_first_slice \
join_indexed_prefix \
worker_private_scratch \
shared_readonly_inputs \
sequential_calls \
concurrent_calls \
init_once_mutex \
init_once_spinlock \
atomic_thread_count \
mode_dispatch \
partition_columns_simd \
caller_first_slice_simd \
worker_scratch_pack_simd \
tls_thread_slots"

expect_race="create_join_plain_race \
job_descriptor_copy_race \
partition_columns_race \
partition_block_tails_race \
caller_first_slice_race \
join_indexed_prefix_race \
worker_private_scratch_race \
shared_readonly_inputs_race \
sequential_calls_race \
concurrent_calls_race \
init_once_mutex_race \
init_once_spinlock_race \
atomic_thread_count_race \
mode_dispatch_race \
partition_columns_simd_race \
caller_first_slice_simd_race \
worker_scratch_pack_simd_race \
tls_thread_slots_race"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --compiler|--ir-dir|--symbex-timeout-ms)
            [[ $# -ge 2 && -n "$2" ]] || { printf '%s requires an argument\n' "$1" >&2; exit 1; }
            case "$1" in
                --compiler) compiler=$2 ;;
                --ir-dir) ir_dir=$2 ;;
                --symbex-timeout-ms) symbex_timeout_ms=$2 ;;
            esac
            shift 2 ;;
        --compiler=*) compiler=${1#*=}; shift ;;
        --ir-dir=*) ir_dir=${1#*=}; shift ;;
        --symbex-timeout-ms=*) symbex_timeout_ms=${1#*=}; shift ;;
        *) printf 'unknown option: %s\n' "$1" >&2; exit 1 ;;
    esac
done

[[ -x "$compiler" ]] || { printf 'compiler not found: %s\n' "$compiler" >&2; exit 1; }

stamp="$(date -u +%Y%m%dT%H%M%SZ)-$$"
out_dir="results/$stamp"
mkdir -p "$out_dir"

mismatch=0

run_one() {
    local stem=$1 expected=$2
    local ll="$ir_dir/$stem.ll"

    if [[ ! -f "$ll" ]]; then
        printf '%-32s expected=%-11s got=MISSING      MISMATCH\n' "$stem" "$expected" \
            | tee -a "$out_dir/summary.txt"
        mismatch=1
        return
    fi

    "$compiler" "$ll" --symbex-timeout-ms="$symbex_timeout_ms" \
        --dump-unresolved="$out_dir/$stem-pairs.txt" \
        >"$out_dir/$stem.stdout" 2>"$out_dir/$stem.stderr"
    local code=$?
    local got=error

    [[ $code -eq 0 ]] && got=drf
    [[ $code -eq 2 ]] && got=unresolved

    local mark=MISMATCH
    if { [[ $expected == drf && $got == drf ]] ||
         [[ $expected == race && $got == unresolved ]]; }; then
        mark=OK
    else
        mismatch=1
    fi

    printf '%-32s expected=%-11s got=%-11s %s\n' "$stem" "$expected" "$got" "$mark" \
        | tee -a "$out_dir/summary.txt"
}

for stem in $expect_drf; do run_one "$stem" drf; done
for stem in $expect_race; do run_one "$stem" race; done

printf 'results: %s\n' "$out_dir"
[[ $mismatch -eq 0 ]] || exit 1
exit 0
