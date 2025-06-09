{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "swaync-soundscript";
  runtimeInputs = [
    pkgs.mpv
  ];
  text = ''
    HAS_NOTIFICATION_SOUND=("Discord" "Thunderbird" "vesktop")
    case "$SWAYNC_URGENCY" in
        Critical)
            SOUNDFILE="/run/current-system/sw/share/sounds/freedesktop/stereo/suspend-error.oga"
            ;;
         Normal|Low)
            # Do this https://unix.stackexchange.com/questions/251013/bash-regex-capture-group
            # To get to this:
            # hints:
            #      sender-pid: int64 51307
            #      urgency: byte 0x01
            #      sound-file: '/path/to/file'

            # SOUNDFILE="test" ||
            # [[ "$SWAYNC_HINT_STRING:sound_name:" =~ $regex ]]
            # SOUNDFILE="$SWAYNC_HINT"
        [[ $(swaync-client --get-dnd) == "true" ]] && exit 0
            set +u
            if [ -n "$SWAYNC_HINT_SOUND_FILE" ]; then
                SOUNDFILE="$SWAYNC_HINT_SOUND_FILE"
            elif [[ " ''${HAS_NOTIFICATION_SOUND[*]} " =~ [[:space:]]''${SWAYNC_APP_NAME}[[:space:]] ]] ; then
                exit 0
            else
                SOUNDFILE="/run/current-system/sw/share/sounds/freedesktop/stereo/message.oga"
            fi
            ;;
    esac
    set -u
    mpv --really-quiet "$SOUNDFILE" 
  '';
}
