#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# link, delete, copy
ACTION="${1//[^a-zA-Z0-9 ]/}"
echo "$ACTION"

function symlink() {
    if [[ -e "$2" && ! -L "$2" ]] ; then
        echo "$2 exists and is not a symlink. Ignoring it." >&2
        return 1
    fi
 
    # "ln -sf source link" follows symlinks by default on ancient BSD (thus on macOS)
    # the fix on ancient BSD is to add -h, which would be incompatible with GNU
    # which doesn't do any of this nonsense and doesn't accept -h either
    #
    # Thus we get to -f ourselves because shell scripting is jank.
    [[ -L "$2" ]] && rm "$2"
 
    ln -sv "${SCRIPT_DIR}/$1" "$2"
}

if [ "$ACTION" == "link" ]; then
# symlink nvim ~/.config/nvim
# symlink git ~/.config/git
    echo "linking..."
    mkdir -p "$HOME"/.config/hypr
    ln -s "$SCRIPT_DIR"/hypr/*.conf "$HOME"/.config/hypr
    symlink "$SCRIPT_DIR"/waybar "$HOME"/.config/waybar
    symlink "$SCRIPT_DIR"/kitty "$HOME"/.config/kitty
    symlink "$SCRIPT_DIR"/git "$HOME"/.config/git
    symlink "$SCRIPT_DIR"/sioyek "$HOME"/.config/sioyek

elif [ "$ACTION" == "delete" ]; then
    echo "Deleting..."
    rm -rf "$HOME"/.config/hypr
    rm -rf "$HOME"/.config/waybar
    rm -rf "$HOME"/.config/kitty
    rm -rf "$HOME"/.config/git
    rm -rf "$HOME"/.config/sioyek
    rm -rf "$HOME"/.config/vesktop

elif [ "$ACTION" == "copy" ]; then
    echo "Copy..."
    mkdir -p "$HOME"/.config/hypr
    cp "$SCRIPT_DIR"/hypr/*.conf "$HOME"/.config/hypr/
    cp -R "$SCRIPT_DIR"/waybar "$HOME"/.config/waybar
    cp -R "$SCRIPT_DIR"/kitty "$HOME"/.config/kitty
    cp -R "$SCRIPT_DIR"/git "$HOME"/.config/git
    cp -R "$SCRIPT_DIR"/sioyek "$HOME"/.config/sioyek
    cp -R "$SCRIPT_DIR"/vesktop "$HOME"/.config/vesktop
else 
    echo "Operation not supported"
    exit 1
fi
