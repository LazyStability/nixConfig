{ lib, config, ... }:
{
  virtualisation.docker = lib.mkIf config.virtualisation.docker.enable {
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
