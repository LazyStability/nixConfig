#!/run/current-system/sw/bin/bash
set -o errexit
set -o nounset
set -o pipefail

HAS_NOTIFICATION_SOUND=("Discord" "Thunderbird" "vesktop")

SOUNDFILE="/run/current-system/sw/share/sounds/freedesktop/stereo/suspend-error.oga" 

echo "SWAYNC_URGENCY"
[[ "$SWAYNC_URGENCY" != "Critical" ]] && {
    # Got any sound files?
    if [[ -z "${SWAYNC_HINT_SOUND_FILE-}" ]] || [[ ! -f "${SWAYNC_HINT_SOUND_FILE//\'}" ]]; then
      SOUNDFILE="/run/current-system/sw/share/sounds/freedesktop/stereo/message.oga"
    else
      SOUNDFILE="${SWAYNC_HINT_SOUND_FILE//\'}"
    fi

    # Are we busy?
    [[ $(swaync-client --get-dnd) == "true" ]] && exit 0

    # Has the program its own sound effect?
    # Do this https://unix.stackexchange.com/questions/251013/bash-regex-capture-group
    SWAYNC_APP_NAME=${SWAYNC_APP_NAME:-"No name"}
    [[ " ${HAS_NOTIFICATION_SOUND[*]} " =~ [[:space:]]${SWAYNC_APP_NAME}[[:space:]] ]] && {
        echo "there"
        exit 0
    }
}
echo "$SOUNDFILE"
/etc/profiles/per-user/me/bin/mpv --really-quiet --no-config "$SOUNDFILE"
