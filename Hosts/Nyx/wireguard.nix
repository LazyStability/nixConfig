{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.firewall = {
    allowedUDPPorts = [
      51820
      51821
    ];
  };
  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = "/run/secrets/wg-split_har.conf";
      autostart = true; # set to false if you want manual control
    };
  };
}
