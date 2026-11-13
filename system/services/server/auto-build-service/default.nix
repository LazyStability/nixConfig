# Automatic nix build service for caching
{ pkgs, ... }:

{
  # --- Auto-Build Service ---
  systemd.services.nix-auto-build = {
    description = "Build and cache NixOS configurations";
    path = with pkgs; [
      git
      nix
      openssh
      diffutils
    ];
    script = ''
       set -euo pipefail
       DOTFILES=/etc/nixos

       if [ ! -d "$DOTFILES" ]; then
           git clone http://192.168.105.51:3000/LazilyStableProton/nixos-config.git "$DOTFILES"
       else
           cd "$DOTFILES"
           git fetch origin
           git reset --hard origin/main
       fi
       
       cd "$DOTFILES"
       RESULT_DIR="/var/lib/nix-auto-build/result-$(date +%F)"
       mkdir -p "$RESULT_DIR"
       OLD_HEAD="$(git rev-parse HEAD)"

       # Snapshot pre-update closures of all toplevels
         declare -A OLD_CLOSURE
       for host in Kronos  VidarNix ; do
           OLD_CLOSURE[$host]=$(nix build .#nixosConfigurations.$host.config.system.build.toplevel \
               --print-out-paths --keep-going --cores 2 --max-jobs 2)
       done

       nix flake update --commit-lock-file
       NEW_HEAD="$(git rev-parse HEAD)"
       COMMIT_ID="$(git rev-parse --short HEAD)"
       if [ "$NEW_HEAD" != "$OLD_HEAD" ]; then
           git format-patch -1 --stdout HEAD > "$RESULT_DIR/update.patch"
       else
           echo "no flake.lock changes this run" > "$RESULT_DIR/update.patch"
       fi

       # Build all host configurations, linked into the dated result dir
      declare -A NEW_CLOSURE

      for host in Kronos Nyx VidarNix ; do
          echo "Building $host..."
          NEW_CLOSURE[$host]="$(nix build .#nixosConfigurations.$host.config.system.build.toplevel \
              --out-link "$RESULT_DIR/$host" \
              --print-out-paths \
              --keep-going \
              --cores 2 \
              --max-jobs 2)" || {
              NEW_CLOSURE[$host]=""
              echo "Warning: $host build failed, continuing..."
              continue
          }
          echo "Built $host with $COMMIT_ID"
      done

       # Per-host closure diffs
      for host in Kronos Nyx VidarNix ; do
          if [[ "''${NEW_CLOSURE[$host]}" == "" ]]; then
              echo "=== $host Closure couldn't be built ==="
          else
              nix store diff-closures ''${OLD_CLOSURE[$host]} ''${NEW_CLOSURE[$host]} > "$RESULT_DIR/closure-diff-$host.raw"
          fi
      done

      # Tier-1 (security-critical) packages: only auto-switch if none of these changed
      CRIT_RE='^(glibc|libressl|nix|nixos-rebuild|openssh|sudo|linux-pam|pam_u2f|gnupg|sops|age-plugin|yubikey|git|curl|wget|gh|firejail|bubblewrap|systemd|linux|bind|iptables|tailscale|networkmanager|wpa_supplicant|docker|podman|libvirt|qemu|restic|syncthing|firefox|brave|tor-browser|thunderbird): '

      # Report: blocking changes on top, full diff below
      {
         echo "=== BLOCKING CHANGES (Tier 1) ==="
         for host in Kronos VidarNix ; do
             if [[ -n "''${NEW_CLOSURE[$host]}" ]]; then
                 echo "--- $host ---"
                 grep -E -e "$CRIT_RE" "$RESULT_DIR/closure-diff-$host.raw" || echo "(none)"
             fi
         done
         echo
         echo "=== FULL CLOSURE DIFF ==="
         for host in Kronos VidarNix ; do
             if [[ -n "''${NEW_CLOSURE[$host]}" ]]; then
                 echo "--- $host ---"
                 cat "$RESULT_DIR/closure-diff-$host.raw"
             fi
         done
      } > "$RESULT_DIR/closure-diff"

      # Only switch VidarNix if its build succeeded and no Tier-1 changes landed in its closure
      if [[ -z "''${NEW_CLOSURE[VidarNix]}" ]]; then
          echo "Skipping nixos-rebuild switch: VidarNix build failed"
      elif grep -E -e "$CRIT_RE" "$RESULT_DIR/closure-diff-VidarNix.raw" > "$RESULT_DIR/vidar-blocking"; then
          echo "Holding nixos-rebuild switch: Tier-1 changes in VidarNix closure (see $RESULT_DIR/vidar-blocking)"
          cat "$RESULT_DIR/vidar-blocking"
      else
          : > "$RESULT_DIR/vidar-blocking"
          nixos-rebuild switch --flake .#VidarNix
      fi

      echo "All builds completed at $(date)"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      TimeoutStartSec = "12h";
    };
  };

  # --- Build Timer (Mon + Thu; weekly GC keeps results ~2 weeks max) ---
  systemd.timers.nix-auto-build = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = [
        "Mon *-*-* 02:00:00"
        "Thu *-*-* 02:00:00"
      ];
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
