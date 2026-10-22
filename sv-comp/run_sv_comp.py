#!/usr/bin/env python3
"""Run every sv-comp benchmark and score the results against upstream verdicts.

This is a benchmark, not a unit test: the run succeeds whenever every file
yields a verdict (compiler exit 0 or 2), and disagreements with the upstream
verdicts are reported as scores (miss / false alarm), never as failures.
Only infrastructure problems fail the run: a missing IR input, a compiler
crash (exit 1), or a process timeout.

Artifacts land in --out-dir (default results/<UTC stamp>/): runs.json with one
record per benchmark, per-file stdout/stderr/pair dumps, and summary.md.
"""

import argparse
import datetime
import hashlib
import json
import re
import subprocess
import sys
import time
from pathlib import Path

SUITE_DIR = Path(__file__).resolve().parent

# The compiler prints this block before the optional unresolved-pair report.
SUMMARY_RE = re.compile(
    r"^Result: (DRF|UNRESOLVED)\n"
    r"^Contexts: (\d+); accesses: (\d+)\n"
    r"^Pairs: (\d+) unresolved / (\d+) examined\n"
    r"(?:^Symbolic budget: .+\n)?"
    r"(?:^Input budget: .+\n)?"
    r"^Analysis time: (\d+\.\d+) s\n",
    re.MULTILINE)

# Pair dumps locate each access as "at=<file>:<line>:<column>".
AT_LINE_RE = re.compile(r"^\s*at=(.+):(\d+):(\d+)$", re.MULTILINE)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run the sv-comp micro-benchmark and score the results.")
    parser.add_argument("--compiler", required=True,
                        help="path to the delphi-compiler executable")
    parser.add_argument("--ir-dir", default="build/ir",
                        help="directory holding one <stem>.ll per benchmark")
    parser.add_argument("--out-dir", default=None,
                        help="output directory (default results/<UTC stamp>)")
    parser.add_argument("--symbex-timeout-ms", type=int, default=100,
                        help="per-pair symbolic proof budget (default 100)")
    parser.add_argument("--input-timeout-ms", type=int, default=100,
                        help="whole-module worker-input budget (default 100)")
    parser.add_argument("--process-timeout-s", type=int, default=300,
                        help="guard against a hanging compiler run (default 300)")
    parser.add_argument("--check-race-lines", action="store_true",
                        help="audit mode: every source line annotated // RACE! "
                             "must appear as an access in the pair dump")
    return parser.parse_args()


def load_benchmarks(ir_dir):
    """Pair every benchmark source with its verdict and captured IR path."""
    verdicts = json.loads((SUITE_DIR / "verdicts.json").read_text())
    src_paths = sorted(SUITE_DIR.glob("*.c"))
    recorded = set(verdicts["files"])
    present = {path.name for path in src_paths}
    missing = present - recorded
    stale = recorded - present
    if missing or stale:
        raise SystemExit(
            "verdicts.json is out of sync with the benchmark sources; "
            f"missing verdicts: {sorted(missing) or 'none'}; "
            f"stale verdicts: {sorted(stale) or 'none'}")
    benchmarks = []
    for src_path in src_paths:
        ir_path = Path(ir_dir) / f"{src_path.stem}.ll"
        if not ir_path.is_file():
            raise SystemExit(f"missing captured IR for {src_path.name}: "
                             f"{ir_path} (run `make ir` first)")
        entry = verdicts["files"][src_path.name]
        benchmarks.append((src_path, ir_path,
                           entry["race_free"], entry["upstream_file"]))
    return benchmarks, verdicts["upstream_commit"]


def score_result(race_free, status_text):
    """Score one compiler outcome against the upstream verdict."""
    if status_text in ("FAILURE", "TIMEOUT"):
        return "failure"
    if race_free is None:
        return "unscored"
    if race_free:
        return "correct" if status_text == "DRF" else "false alarm"
    return "miss" if status_text == "DRF" else "correct warning"


def run_compiler(compiler, ir_path, pairs_path, args):
    """Run one benchmark; return the outcome record without the score."""
    command = [str(compiler),
               f"--symbex-timeout-ms={args.symbex_timeout_ms}",
               f"--input-timeout-ms={args.input_timeout_ms}",
               f"--dump-unresolved={pairs_path}", str(ir_path)]
    started = time.monotonic()
    try:
        finished = subprocess.run(command, capture_output=True, text=True,
                                  timeout=args.process_timeout_s)
        exit_code, stdout, stderr = (finished.returncode,
                                     finished.stdout, finished.stderr)
        timed_out = False
    except subprocess.TimeoutExpired as expired:
        exit_code, timed_out = None, True
        stdout = expired.stdout or ""
        stderr = expired.stderr or ""
        if isinstance(stdout, bytes):
            stdout, stderr = stdout.decode(), stderr.decode()
    wall_ms = round((time.monotonic() - started) * 1000, 3)

    record = {"exit": exit_code, "wall_ms": wall_ms, "command": command}
    if timed_out:
        record.update(status="TIMEOUT")
    elif exit_code == 0:
        record.update(status="DRF")
    elif exit_code == 2:
        record.update(status="UNRESOLVED")
    else:
        record.update(status="FAILURE")

    matched = SUMMARY_RE.search(stdout)
    if record["status"] in ("DRF", "UNRESOLVED"):
        assert matched, (ir_path, stdout)
        result_text, contexts, accesses, unresolved, examined, seconds = \
            matched.groups()
        assert result_text == record["status"], (ir_path, stdout)
        record.update(contexts=int(contexts), accesses=int(accesses),
                      unresolved=int(unresolved), examined=int(examined),
                      analysis_ms=round(float(seconds) * 1000, 1))
    return record, stdout, stderr


def collect_race_lines(pairs_path, src_path):
    """Return pair-dump access lines (path, line) for one benchmark."""
    if not pairs_path.is_file():
        return []
    hits = [(Path(path), int(line))
            for path, line, _ in AT_LINE_RE.findall(pairs_path.read_text())]
    return [(path, line) for path, line in hits
            if path.resolve() == src_path.resolve()]


def check_race_line_coverage(benchmarks, out_dir):
    """Audit: each // RACE! source line must appear in the pair dump."""
    problems = []
    for src_path, _, race_free, _ in benchmarks:
        if race_free is not False:
            continue
        annotated = [index + 1 for index, line in
                     enumerate(src_path.read_text().splitlines())
                     if "RACE!" in line]
        reported = {line for _, line in
                    collect_race_lines(out_dir / f"{src_path.stem}.pairs.txt",
                                       src_path)}
        absent = [line for line in annotated if line not in reported]
        if absent:
            problems.append(f"{src_path.name}: RACE! lines {absent} "
                            f"missing from the pair dump")
    return problems


def write_summary(out_dir, args, compiler, records, upstream_commit):
    """Write summary.md and runs.json; return the score counts."""
    counts = {}
    for record in records:
        counts[record["score"]] = counts.get(record["score"], 0) + 1

    order = ["correct warning", "correct", "false alarm", "miss",
             "unscored", "failure"]
    lines = [
        "# sv-comp micro-benchmark run",
        "",
        f"Finished {datetime.datetime.now(datetime.timezone.utc).isoformat()}. "
        f"**{len(records)} benchmarks** against upstream verdicts pinned at "
        f"`{upstream_commit}`.",
        "",
        "Scores: " + ", ".join(f"**{counts.get(name, 0)} {name}**"
                               for name in order) + ".",
        f"Compiler: `{compiler}`; symbolic budget "
        f"{args.symbex_timeout_ms} ms per pair, input budget "
        f"{args.input_timeout_ms} ms.",
        "",
        "| Benchmark | Upstream | Result | Score | Unresolved / examined | Analysis (ms) | Wall (ms) |",
        "| --- | --- | --- | --- | ---: | ---: | ---: |",
    ]
    for record in records:
        verdict_text = ("unscored" if record["race_free"] is None else
                        "race-free" if record["race_free"] else "racy")
        pair_counts = (f"{record.get('unresolved', '-')} / "
                       f"{record.get('examined', '-')}"
                       if "unresolved" in record else "-")
        lines.append(
            f"| [{record['file']}](../../{record['file']}) | {verdict_text} "
            f"| {record['status']} | {record['score']} | {pair_counts} "
            f"| {record.get('analysis_ms', '-')} | {record['wall_ms']} |")
    (out_dir / "summary.md").write_text("\n".join(lines) + "\n")

    payload = {
        "started_utc": args.started_utc,
        "finished_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "compiler": str(compiler),
        "compiler_sha256": args.compiler_sha256,
        "symbex_timeout_ms": args.symbex_timeout_ms,
        "input_timeout_ms": args.input_timeout_ms,
        "process_timeout_s": args.process_timeout_s,
        "upstream_commit": upstream_commit,
        "counts": counts,
        "runs": records,
    }
    (out_dir / "runs.json").write_text(json.dumps(payload, indent=2) + "\n")
    return counts


def main():
    args = parse_args()
    args.started_utc = datetime.datetime.now(datetime.timezone.utc).isoformat()
    compiler = Path(args.compiler).resolve()
    if not compiler.is_file():
        raise SystemExit(f"compiler not found: {compiler}")
    args.compiler_sha256 = hashlib.sha256(compiler.read_bytes()).hexdigest()

    ir_dir = (SUITE_DIR / args.ir_dir).resolve()
    benchmarks, upstream_commit = load_benchmarks(ir_dir)
    out_dir = (Path(args.out_dir) if args.out_dir else
               SUITE_DIR / "results" /
               datetime.datetime.now(datetime.timezone.utc)
               .strftime("%Y%m%d-%H%M%S"))
    out_dir.mkdir(parents=True, exist_ok=True)

    records = []
    for src_path, ir_path, race_free, upstream_file in benchmarks:
        pairs_path = out_dir / f"{src_path.stem}.pairs.txt"
        record, stdout, stderr = run_compiler(compiler, ir_path, pairs_path,
                                              args)
        record.update(file=src_path.name, race_free=race_free,
                      upstream_file=upstream_file,
                      score=score_result(race_free, record["status"]))
        records.append(record)
        (out_dir / f"{src_path.stem}.stdout.txt").write_text(stdout)
        (out_dir / f"{src_path.stem}.stderr.txt").write_text(stderr)
        pair_counts = (f"{record.get('unresolved')}/{record.get('examined')}"
                       if "unresolved" in record else "-")
        print(f"{record['file']:<40} {record['status']:<10} "
              f"{record['score']:<15} {pair_counts:>9} "
              f"{str(record.get('analysis_ms', '-')):>8} ms")

    counts = write_summary(out_dir, args, compiler, records, upstream_commit)
    print(f"\nscores: " + ", ".join(f"{counts.get(name, 0)} {name}"
                                    for name in ["correct warning", "correct",
                                                 "false alarm", "miss",
                                                 "unscored", "failure"]))
    print(f"artifacts: {out_dir}")

    problems = []
    if args.check_race_lines:
        problems = check_race_line_coverage(benchmarks, out_dir)
        for problem in problems:
            print(f"race-line audit: {problem}", file=sys.stderr)
    failed = [record for record in records if record["score"] == "failure"]
    if failed or problems:
        raise SystemExit(f"{len(failed)} benchmark(s) failed to produce a "
                         f"verdict" + (f"; {len(problems)} race-line audit "
                                       f"problem(s)" if problems else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
