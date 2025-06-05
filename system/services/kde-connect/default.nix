{ config, lib, ... }:
{
  networking.firewall = lib.mkIf config.programs.kdeconnect.enable (rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  });
}
