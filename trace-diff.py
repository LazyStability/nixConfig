#!/usr/bin/env python3
"""Compare two nix --trace files: count primop frames per source file."""
import re
import sys
from collections import Counter

def norm(path):
    # Collapse the long nixexprs URL to a short tag, keep everything else
    return path.replace(
        '«https://releases.nixos.org/nixos/unstable/nixos-26.11pre1064949.34ab99075ac4/nixexprs.tar.xz?narHash=sha256-maQBa7XmWJ%2Ba6te4QwF%2B%2BR1FIXUrjvki0AtGOOhyZn0%3D»',
        'nixexprs')

def parse(fname):
    total = Counter()
    primops = Counter()
    frames = 0
    with open(fname, 'r', errors='replace') as f:
        for line in f:
            for frame in line.split(';'):
                frame = frame.strip()
                if not frame:
                    continue
                parts = frame.rsplit(':', 3)
                if len(parts) < 4:
                    continue
                path, ln, col, primop = parts
                if not ln.isdigit() or not col.isdigit():
                    continue
                frames += 1
                total[norm(path)] += 1
                primops[primop.strip()] += 1
    return total, primops, frames

for label, fname in [("HOST (repo Kronos)", sys.argv[1]), ("HOST-BASE (minimal)", sys.argv[2])]:
    total, primops, frames = parse(fname)
    print(f"=== {label}: {frames} frames ===")
    for path, c in total.most_common(25):
        print(f"{c:>8}  {path}")
    print()
