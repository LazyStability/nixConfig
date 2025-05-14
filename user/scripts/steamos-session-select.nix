# https://github.com/Grimish-ng/steam-gamescope-guide
{
  writeShellApplication,
  ...
}:
writeShellApplication {

  name = "steamos-session-select";
  text = ''
    steam -shutdown
  '';
}
