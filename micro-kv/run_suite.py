#!/usr/bin/env python3
"""Run every micro-kv benchmark and score the results against verdicts.json.

This is a benchmark, not a unit test: the run succeeds whenever every file
yields a verdict (compiler exit 0 or 2), and disagreements with the verdicts
are reported as scores (miss / false alarm), never as failures.  Only
infrastructure problems fail the run: a missing IR input, a compiler crash
(exit 1), or a process timeout.

Artifacts land in --out-dir (default results/<UTC stamp>/): runs.json with one
record per benchmark, per-file stdout/stderr/pair dumps, and summary.md.
"""

import argparse
import datetime
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
        description="Run the micro-kv micro-benchmark and score the results.")
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
        benchmarks.append((src_path, ir_path, verdicts["files"][src_path.name]["race_free"]))
    return benchmarks


def score_result(race_free, status_text):
    """Score one compiler outcome against the recorded verdict."""
    if status_text in ("FAILURE", "TIMEOUT"):
        return "failure"
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


def check_race_line_coverage(benchmarks, out_dir):
    """Audit: each // RACE! source line must appear in the pair dump."""
    problems = []
    for src_path, _, race_free in benchmarks:
        if race_free is not False:
            continue
        annotated = [index + 1 for index, line in
                     enumerate(src_path.read_text().splitlines())
                     if "RACE!" in line]
        pairs_path = out_dir / f"{src_path.stem}.pairs.txt"
        reported = set()
        if pairs_path.is_file():
            for path_text, line_text, _ in AT_LINE_RE.findall(pairs_path.read_text()):
                if Path(path_text).resolve() == src_path.resolve():
                    reported.add(int(line_text))
        absent = [line for line in annotated if line not in reported]
        if absent:
            problems.append(f"{src_path.name}: RACE! lines {absent} "
                            f"missing from the pair dump")
    return problems


def write_summary(out_dir, args, compiler, records):
    """Write summary.md and runs.json; return the score counts."""
    counts = {}
    for record in records:
        counts[record["score"]] = counts.get(record["score"], 0) + 1

    order = ["correct warning", "correct", "false alarm", "miss", "failure"]
    lines = [
        "# micro-kv micro-benchmark run",
        "",
        f"Finished {datetime.datetime.now(datetime.timezone.utc).isoformat()}; "
        f"**{len(records)} benchmarks**.",
        "",
        "Scores: " + ", ".join(f"**{counts.get(name, 0)} {name}**"
                               for name in order) + ".",
        f"Compiler: `{compiler}`; symbolic budget "
        f"{args.symbex_timeout_ms} ms per pair, input budget "
        f"{args.input_timeout_ms} ms.",
        "",
        "| Benchmark | Verdict | Result | Score | Unresolved / examined | Analysis (ms) | Wall (ms) |",
        "| --- | --- | --- | --- | ---: | ---: | ---: |",
    ]
    for record in records:
        verdict_text = "race-free" if record["race_free"] else "racy"
        pair_counts = (f"{record.get('unresolved', '-')} / "
                       f"{record.get('examined', '-')}"
                       if "unresolved" in record else "-")
        lines.append(
            f"| [{record['file']}](../../{record['file']}) | {verdict_text} "
            f"| {record['status']} | {record['score']} | {pair_counts} "
            f"| {record.get('analysis_ms', '-')} | {record['wall_ms']} |")
    (out_dir / "summary.md").write_text("\n".join(lines) + "\n")

    payload = {
        "finished_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "compiler": str(compiler),
        "symbex_timeout_ms": args.symbex_timeout_ms,
        "input_timeout_ms": args.input_timeout_ms,
        "counts": counts,
        "runs": records,
    }
    (out_dir / "runs.json").write_text(json.dumps(payload, indent=2) + "\n")
    return counts


def main():
    args = parse_args()
    compiler = Path(args.compiler).resolve()
    if not compiler.is_file():
        raise SystemExit(f"compiler not found: {compiler}")

    ir_dir = (SUITE_DIR / args.ir_dir).resolve()
    benchmarks = load_benchmarks(ir_dir)
    out_dir = (Path(args.out_dir) if args.out_dir else
               SUITE_DIR / "results" /
               datetime.datetime.now(datetime.timezone.utc)
               .strftime("%Y%m%d-%H%M%S"))
    out_dir.mkdir(parents=True, exist_ok=True)

    records = []
    for src_path, ir_path, race_free in benchmarks:
        pairs_path = out_dir / f"{src_path.stem}.pairs.txt"
        record, stdout, stderr = run_compiler(compiler, ir_path, pairs_path,
                                              args)
        record.update(file=src_path.name, race_free=race_free,
                      score=score_result(race_free, record["status"]))
        records.append(record)
        (out_dir / f"{src_path.stem}.stdout.txt").write_text(stdout)
        (out_dir / f"{src_path.stem}.stderr.txt").write_text(stderr)
        pair_counts = (f"{record.get('unresolved')}/{record.get('examined')}"
                       if "unresolved" in record else "-")
        print(f"{record['file']:<24} {record['status']:<11} "
              f"{record['score']:<15} {pair_counts:>9} "
              f"{str(record.get('analysis_ms', '-')):>8} ms")

    counts = write_summary(out_dir, args, compiler, records)
    print("\nscores: " + ", ".join(f"{counts.get(name, 0)} {name}"
                                   for name in ["correct warning", "correct",
                                                "false alarm", "miss",
                                                "failure"]))
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
