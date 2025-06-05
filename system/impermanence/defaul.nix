{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # The post mount hook to nuke the root partition
  boot.initrd.postDeviceCommands = lib.mkAfter (builtins.readFile ../../Scripts/nukeRoot.sh);

  # Persistant files, states which are needed
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/run/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
