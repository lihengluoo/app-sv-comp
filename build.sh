#!/usr/bin/env bash
# Capture each standalone micro-app before LLVM can discard unused accesses.
set -euo pipefail

app_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
clang=clang
wllvm="${WLLVM_CC:-wllvm}"
output_dir="$app_dir/ir"

fail() { printf 'error: %s\n' "$*" >&2; exit 1; }

print_usage() {
    printf 'Usage: %s [--clang PATH] [--wllvm PATH] [--output-dir DIR]\n' "$0"
    printf 'Defaults: clang and wllvm on PATH (or WLLVM_CC); output: %s/ir\n' "$app_dir"
}

find_executable() {
    local path
    path="$(command -v -- "$1")" || fail "Executable not found: $1"
    [[ -f "$path" && -x "$path" ]] || fail "Not an executable file: $path"
    printf '%s/%s\n' "$(cd -- "$(dirname -- "$path")" && pwd)" "$(basename -- "$path")"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --clang|--wllvm|--output-dir)
            [[ $# -ge 2 && -n "$2" ]] || fail "$1 requires an argument"
            case "$1" in
                --clang) clang="$2" ;;
                --wllvm) wllvm="$2" ;;
                --output-dir) output_dir="$2" ;;
            esac
            shift 2
            ;;
        -h|--help) print_usage; exit 0 ;;
        *) fail "Unknown option: $1" ;;
    esac
done

clang="$(find_executable "$clang")"
wllvm="$(find_executable "$wllvm")"
llvm_dir="$(dirname -- "$clang")"
wllvm_dir="$(dirname -- "$wllvm")"
command -v file >/dev/null || fail 'Required executable not found: file'
for tool in "$llvm_dir/llvm-link" "$llvm_dir/opt" "$wllvm_dir/extract-bc"; do
    [[ -x "$tool" ]] || fail "Required executable not found: $tool"
done

shopt -s nullglob
src_paths=("$app_dir"/*.c)
[[ ${#src_paths[@]} -gt 0 ]] || fail "No C benchmarks found in $app_dir"

mkdir -p -- "$output_dir"
output_dir="$(cd -- "$output_dir" && pwd)"
build_dir="$output_dir/wllvm"
mkdir -p -- "$build_dir"
export LLVM_COMPILER=clang LLVM_CC_NAME="${clang##*/}" LLVM_COMPILER_PATH="$llvm_dir"
unset WLLVM_CONFIGURE_ONLY
# Keep the frontend's O1 attributes while disabling its LLVM optimization
# pipeline: dead-code elimination would erase unused shared-memory reads.
flags=(-std=c11 -pthread -O1 -Xclang -disable-llvm-passes
       -g -fno-discard-value-names
       -fno-vectorize -fno-slp-vectorize -fno-unroll-loops)
passes='function(sroa,mem2reg,loop-simplify,loop(loop-rotate,indvars)),globaldce,verify'

# Keep capture intermediates separate from the one verified IR per benchmark.
cd -- "$build_dir"
for src_path in "${src_paths[@]}"; do
    name="$(basename -- "$src_path" .c)"
    executable="$build_dir/$name"
    linked="$build_dir/$name.linked.bc"
    ir="$output_dir/$name.ll"
    "$wllvm" "${flags[@]}" "$src_path" -o "$executable"
    "$wllvm_dir/extract-bc" --linker "$llvm_dir/llvm-link" \
        --output "$linked" "$executable"
    # Normalize stack slots and counted loops without a general DCE pipeline.
    "$llvm_dir/opt" -passes="$passes" -S "$linked" -o "$ir"
    printf '%s\n' "$ir"
done
