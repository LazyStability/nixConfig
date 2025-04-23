{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment = {
    systemPackages = [
      pkgs.sops
    ];
  };
  sops = {
    age.keyFile = "/persist/etc/ssh/github_kickstart_age";
    defaultSopsFile = ./secrets.json;
    defaultSopsFormat = "json";

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
    };
  };
}
