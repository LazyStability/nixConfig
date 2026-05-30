{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myModules.wireguard;
in
{
  options.myModules.wireguard = {
    enable = lib.mkEnableOption "Enable base wireguard modules";
  };
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedUDPPorts = [
        51820
        51821
      ];
    };
    networking.wg-quick.interfaces = {
      # wg0 = {
      #   configFile = "/run/secrets/wg-ginyu.conf";
      #   autostart = true; # set to false if you want manual control
      # };
    };
  };
}
