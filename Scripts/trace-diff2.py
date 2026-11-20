#!/usr/bin/env python3
"""Categorize nix --trace frames and diff two traces."""
import sys
from collections import Counter

URL = '«https://releases.nixos.org/nixos/unstable/nixos-26.11pre1064949.34ab99075ac4/nixexprs.tar.xz?narHash=sha256-maQBa7XmWJ%2Ba6te4QwF%2B%2BR1FIXUrjvki0AtGOOhyZn0%3D»'

def norm(path):
    return path.replace(URL, 'nixexprs')

def parse(fname):
    total = Counter()
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
    return total, frames

def cat(path):
    if path.startswith('/persist/etc/nixos/'):
        return 'repo'
    if 'jail.nix' in path:
        return 'jail.nix'
    if path.startswith('nixexprs/nixos/modules/'):
        return 'nixos-modules'
    if path.startswith('nixexprs/pkgs/'):
        return 'nixpkgs-pkgs'
    if path.startswith('nixexprs/lib/'):
        return 'nixexprs-lib'
    if path.startswith('nixexprs/nixos/'):
        return 'nixos-lib'
    return 'other'

a, fa = parse(sys.argv[1])
b, fb = parse(sys.argv[2])
print(f"{'category':<16} {'repo-Kronos':>12} {'base':>10} {'delta':>10}")
ca, cb = Counter(), Counter()
for p, c in a.items():
    ca[cat(p)] += c
for p, c in b.items():
    cb[cat(p)] += c
for k in sorted(set(ca) | set(cb)):
    print(f"{k:<16} {ca[k]:>12} {cb[k]:>10} {ca[k]-cb[k]:>10}")
print(f"{'TOTAL':<16} {fa:>12} {fb:>10} {fa-fb:>10}")
print()

# NixOS modules present in repo-Kronos but not (or much less) in base
ma = Counter(); mb = Counter()
for p, c in a.items():
    if p.startswith('nixexprs/nixos/modules/'):
        ma[p.split('nixos/modules/', 1)[1]] = c
for p, c in b.items():
    if p.startswith('nixexprs/nixos/modules/'):
        mb[p.split('nixos/modules/', 1)[1]] = c
print("=== nixos modules: extra work in repo-Kronos (top 30 by delta) ===")
deltas = []
for m in set(ma) | set(mb):
    deltas.append((ma[m] - mb[m], ma[m], mb[m], m))
deltas.sort(reverse=True)
for d, x, y, m in deltas[:30]:
    print(f"{d:>7}  repo={x:<6} base={y:<6} {m}")
print()
print(f"distinct nixos modules: repo={len(ma)} base={len(mb)}")

# repo files
print()
print("=== repo files (repo-Kronos only) ===")
for p, c in sorted(a.items(), key=lambda kv: -kv[1]):
    if p.startswith('/persist/etc/nixos/'):
        print(f"{c:>7}  {p}")
