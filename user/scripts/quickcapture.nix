{
  writeShellApplication,
  neovim,
  config
}:
writeShellApplication {
  name = "quickcapture";
  runtimeInputs = [ neovim ];
  text =
    let
      terminalCommand =
        if config.programs.kitty.enable then
          "kitty --class scratchpad_quick_capture"
        else if config.programs.wezterm.enable then
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
