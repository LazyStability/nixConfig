# Credit to Luke Smith
# https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/rssadd
{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "rssadd";
  runtimeInputs = [
    pkgs.wl-clipboard
    pkgs.curl
  ];
  text = ''
    if echo "$1" | grep -q "https*://\S\+\.[A-Za-z]\+\S*" ; then
            url="$1"
    else
            url="$(grep -Eom1 '<[^>]+(rel="self"|application/[a-z]+\+xml)[^>]+>' "$1" |
                    grep -o "https?://[^\" ]")"

            echo "$url" | grep -q "https*://\S\+\.[A-Za-z]\+\S*" ||
                    notify-send "That doesn't look like a full URL." && exit 1
    fi

    if [ -f "$XDG_CONFIG_HOME/newsboat/urls" ]; then
            RSSFILE="$XDG_CONFIG_HOME/newsboat/urls"
    else
            RSSFILE="$HOME/.newsboat/urls"
    fi
    if awk '{print $1}' "$RSSFILE" | grep "^$url$" >/dev/null; then
            notify-send "You already have this RSS feed."
    else
            echo "$url" >> "$RSSFILE" && notify-send "RSS feed added."
    fi
  '';
}
