#!/usr/bin/env bash
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
sops decrypt "$SCRIPT_DIR"/../system/secrets/nix-sign.bin > /tmp/gatdag
nix store sign --key-file /tmp/gatdag --recursive ./result
rm /tmp/gatdag
