{
  writeShellApplication,
  neovim,
}:
writeShellApplication {
  name = "quickcapture";
  runtimeInputs = [neovim];
  text = ''
    cd "$HOME/Dokumente/Personal"
    noteFilename="./Tagebuch/Täglich/thisYear/$(date +%Y-%m-%d).md"

    nvim  -c "norm Go## $(date +%H:%M)"\
          -c "norm Go"\
          -c "startinsert" "$noteFilename"

    exit
  '';
}
