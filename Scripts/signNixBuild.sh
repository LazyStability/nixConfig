#!/usr/bin/env bash
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
nix store sign --key-file "$(sops decrypt \"$SCRIPT_DIR/../system/secrets/nix-sign.bin\")" --recursive ./result

