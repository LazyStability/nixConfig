{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  environment = {
    systemPackages = [
      pkgs.sops
    ];
  };
  sops = {
    age.keyFile = "/persist/etc/ssh/github_kickstart_age";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      user-password.neededForUsers = true;
      Games = {
        sopsFile = ./Games.bin;
        format = "binary";
      };
      ArchKey = {
        sopsFile = ./ArchKey.bin;
        format = "binary";
      };
      Data_disk_keyfile = {
        sopsFile = ./Data_disk_keyfile.bin;
        format = "binary";
      };
      luks_password = {
      };
      "syncthing/key" = {
        owner = "me";
      };
      "syncthing/cert" = {
        owner = "me";
      };
      "wg-ginyu.conf" = {
        sopsFile = ./wg-ginyu.bin;
        format = "binary";
      };
    };
  };
}
