{ config, pkgs, ... }: {
  services.harmonia = {
    cache.enable = true;
    signKeyPaths = [ config.sops.secrets.harmonia-key.path ];
    settings = {
      bind = "[::]:5000";
      priority = 30;

    };
  };
  # optional if you use allowed-users in other places
  #nix.settings.allowed-users = [ "harmonia" ];

  networking.firewall.allowedTCPPorts = [
    5000
  ];

}
