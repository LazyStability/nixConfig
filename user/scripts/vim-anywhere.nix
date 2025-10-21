# Original script somewhat changed to fit wayland: https://github.com/cknadler/vim-anywhere
{
  writeShellApplication,
  neovim,
  config,
}:
writeShellApplication {
  name = "vim-anywhere";
  runtimeInputs = [
    neovim
  ];
  text =
    let
      terminalCommand =
        if true then
          "kitty --class vim-anywhere"
        else if config.programs.wezterm.enable then
          "wezterm"
        else

          builtins.throw
            "No supported terminal active. Use programs.kitty.enable or programs.wezterm.enable.";

    in
    ''
      TMPFILE_DIR=/tmp/vim-anywhere
      TMPFILE=$TMPFILE_DIR/doc-$(date +"%y%m%d%H%M%S")

      mkdir -p "$TMPFILE_DIR"
      touch "$TMPFILE"
      echo 
      chmod o-rwx "$TMPFILE"

      ${terminalCommand} -- nvim "$TMPFILE" -c "startinsert" || exit 1

      sleep 1
      # Does not support unicode, but I rarely need that.
      ydotool type --next-delay 1 --file="$TMPFILE"

    '';
}
