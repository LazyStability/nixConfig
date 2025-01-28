{
  writeShellApplication,
  neovim,
}:
writeShellApplication {
  name = "quickcapture";
  runtimeInputs = [neovim];
  text = ''
    noteFilename="$HOME/Dokumente/Personal/Tagebuch/Täglich/thisYear/$(date +%Y-%m-%d).md"

    nvim  -c "norm Go## $(date +%H:%M)"\
          -c "norm Go"\
          -c "startinsert" "$noteFilename"

    exit
  '';
}
