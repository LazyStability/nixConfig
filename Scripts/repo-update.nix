{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenvNoCC.mkDerivation {
  pname = "repo-update";
  version = "1.0";

  src = pkgs.writeText "repo-update.sh" ''
    #!${pkgs.bash}/bin/bash
    # Pull the most recent artifact produced by the nix-auto-build service
    # (system/services/server/auto-build-service) from VidarNix.
    set -euo pipefail

    VIDAR="''${VIDAR_HOST:-VidarNix}"
    REMOTE_BASE="/var/lib/nix-auto-build"
    DEST_DIR="''${REPO_UPDATE_DEST:-$PWD}"

    latest="$(ssh "hagen@$VIDAR" "ls -1d ''${REMOTE_BASE}/result-* 2>/dev/null | sort | tail -n 1" || true)"

    if [ -z "$latest" ]; then
      echo "error: no artifacts found under ''${REMOTE_BASE} on ''${VIDAR}" >&2
      exit 1
    fi

    name="$(basename "$latest")"
    dest="''${DEST_DIR%/}/''${name}"

    mkdir -p "$dest"
    rsync -a --info=progress2 "hagen@$VIDAR:$latest/" "$dest/"

    echo "Pulled ''${name} from ''${VIDAR} into ''${dest}"
  '';

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.bash
  ];
  buildInputs = [
    pkgs.rsync
    pkgs.openssh
  ];

  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/repo-update'';
  postFixup = ''
    wrapProgram $out/bin/repo-update --prefix PATH : "$PATH"
  '';
}
