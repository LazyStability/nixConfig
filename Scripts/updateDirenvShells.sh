#!/run/current-system/sw/bin/bash

## Update direnv gc roots
for link in /nix/var/nix/gcroots/auto/*; do
  # Check if the path contains the target string
  target=$(readlink "$link")
  if [[ "$target" == *".direnv"* && "$target" != *"/etc/nixos"* ]]; then
      # echo "$link -> $target"
      target=${target%%.direnv/*}
      echo "$target"
      sh -c "cd \"$target\" && direnv allow"
  fi
done
