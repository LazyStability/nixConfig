# Credit to Luke Smith
# https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/qndl
{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "qndl";
  runtimeInputs = [
    pkgs.yt-dlp
  ];
  text = ''
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --cmd)
          cmd="$2"
          shift
          shift
          ;;
        -p|--path)
          path="$2"
          shift
          shift
          ;;
        -*)
          echo "Unknown option $1"
          exit 1
          ;;
        *)
          url="$1"
          shift
          ;;
      esac
    done
    base="$(basename "$url")"
    currentpath=$(pwd)
    cd "''${path-$HOME/Videos}" || exit 1
    notify-send "⏳ Queuing $base..."
    [ -z "''${cmd-}" ] && cmd="yt-dlp --embed-metadata --extractor-args=youtube:player_client=mweb -ic"
    $cmd "$url" 1>/dev/null &
    cd "$currentpath" || exit 1
    wait
    notify-send "👍 $base done."
  '';
}
