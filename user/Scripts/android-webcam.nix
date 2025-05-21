{
  pkgs,
  scrcpy,
  writeShellApplication,
  android-tools,
  ...
}:

writeShellApplication {
  name = "android-webcam";
  runtimeInputs = [
    scrcpy
    android-tools
  ];
  text = ''
    ${pkgs.android-tools}/bin/adb start-server
    ${pkgs.scrcpy}/bin/scrcpy --camera-facing=back --video-source=camera --no-audio --v4l2-sink=/dev/video0 -m1024
  '';
}
