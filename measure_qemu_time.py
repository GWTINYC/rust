#!/usr/bin/env python3
"""
Measure the execution time of an AArch64 binary under qemu-aarch64.

Edit the CONFIG section below and simply run:

    ./measure_qemu_time.py
"""

from __future__ import annotations

import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import List


@dataclass
class Config:
    binary: Path = Path("/home/huawei/sve-infrastructure/rust/tests/codegen-llvm/scalable-vectors/test/sve/bench2_auto_main")
    runs: int = 100
    qemu: str = "qemu-aarch64"
    qemu_args: List[str] = ("-L", "/usr/aarch64-linux-gnu")
    suppress_output: bool = True


CONFIG = Config()


def main() -> int:
    cfg = CONFIG

    if cfg.runs <= 0:
        print("Error: runs must be a positive integer", file=sys.stderr)
        return 2

    binary = cfg.binary
    if not binary.exists() or not binary.is_file():
        print(f"Error: binary '{binary}' not found", file=sys.stderr)
        return 2
    if not binary.stat().st_mode & 0o111:
        print(f"Error: binary '{binary}' is not executable", file=sys.stderr)
        return 2

    qemu_path = shutil.which(cfg.qemu)
    if qemu_path is None:
        print(f"Error: '{cfg.qemu}' not found in PATH", file=sys.stderr)
        return 2

    total_ns = 0
    cmd_base = [qemu_path, *cfg.qemu_args, str(binary)]
    print(f"Running {cfg.runs} iteration(s): {' '.join(cmd_base)}")

    stdout = subprocess.DEVNULL if cfg.suppress_output else None
    stderr = subprocess.DEVNULL if cfg.suppress_output else None

    for run_idx in range(1, cfg.runs + 1):
        start_ns = time.monotonic_ns()
        try:
            subprocess.run(
                cmd_base,
                check=True,
                stdout=stdout,
                stderr=stderr,
            )
        except subprocess.CalledProcessError as exc:
            print(f"Run {run_idx} failed with exit code {exc.returncode}", file=sys.stderr)
            return exc.returncode
        elapsed_ns = time.monotonic_ns() - start_ns
        total_ns += elapsed_ns
        elapsed_ms = elapsed_ns / 1_000_000
        print(f"run {run_idx}: {elapsed_ms:.3f} ms")

    avg_ns = total_ns / cfg.runs
    avg_ms = avg_ns / 1_000_000
    print(f"Average wall time over {cfg.runs} run(s): {avg_ms:.3f} ms")
    return 0


if __name__ == "__main__":
    sys.exit(main())

