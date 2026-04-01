{
  writeShellApplication,
  neovim,
  pkgs,
terminal
}:
writeShellApplication {
  name = "quickcapture";
  runtimeInputs = [ neovim ];
  text =
    let
      terminalCommand =
        # if terminal == pkgs.kitty then
        if true then
          "kitty --class scratchpad_quick_capture"
        # else if terminal == pkgs.wezterm then
        else if false then
          "wezterm"
        else

          builtins.throw
            "No supported terminal active. Use programs.kitty.enable or programs.wezterm.enable.";

    in
    ''
      cd "$HOME/Dokumente/Personal"
      noteFilename="./Tagebuch/Täglich/thisYear/$(date +%Y-%m-%d).md"

      ${terminalCommand} -- nvim  -c "norm Go## $(date +%H:%M)"\
            -c "norm Go"\
            -c "startinsert" "$noteFilename"

      exit
    '';
}
