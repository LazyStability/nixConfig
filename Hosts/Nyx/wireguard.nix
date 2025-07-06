{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.myModules.wireguard;
in
{
  options.myModules.wireguard = {
    enable = lib.mkEnableOption "Enable base wireguard modules";
  };
  config = lib.mkIf (cfg.enable) {
    networking.firewall = {
      allowedUDPPorts = [
        51820
        51821
      ];
    };

    systemd = {
      services."wg-har" = {
        serviceConfig =
          let
            startScript = pkgs.writeShellApplication {
              name = "startScript";
              text = ''
                ${pkgs.kmod}/bin/modprobe wireguard
                ${pkgs.wireguard-tools}/bin/wg-quick up /run/secrets/wg-split_har.conf
              '';
            };
            stopScript = pkgs.writeShellApplication {
              name = "stopScript";
              text = ''
                ${pkgs.wireguard-tools}/bin/wg-quick down /run/secrets/wg-split_har.conf
              '';
            };
          in
          {
            Type = "oneshot";
            PrivateTmp = true;
            RemainAfterExit = true;

            # This is needed because there is a race condition with the dns server
            # RestartSec = 1;
            # Restart = "on-failure";
            ExecStart = "${startScript}/bin/startScript";
            ExecStop = "${stopScript}/bin/stopScript";
          };
        after = [
          "network.target"
          "nss-lookup.target"
          "network-online.target"
        ];
        requires = [
          "network-online.target"
          "nss-lookup.target"
        ];
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
