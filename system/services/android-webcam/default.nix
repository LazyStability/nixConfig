{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myModules.android-webcam;
in
{
  options.myModules.android-webcam = {
    enable = lib.mkEnableOption "Enable scrcpy to stream with an android phone";
  };
  config = lib.mkIf (cfg.enable) {
    boot = {
      kernelModules = [ "v4l2loopback" ];
      extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Virtual Webcam"
      '';
    };
  };
}
