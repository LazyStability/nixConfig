#!/run/current-system/sw/bin/bash

## Update direnv gc roots
for link in /nix/var/nix/gcroots/auto/*; do
  # Check if the path contains the target string
  target=$(readlink "$link")
  if [[ "$target" == *".direnv"* && "$target" != *"/etc/nixos"* ]]; then
      # echo "$link -> $target"
      target=${target%%.direnv/*}
      echo "$target"
      bash -c "eval \"$(direnv export bash)\" && cd \"$target\""
  fi
done
