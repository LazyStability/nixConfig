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
      "syncthing/key" = {
        owner = "me";
      };
      "syncthing/cert" = {
        owner = "me";
      };
      "wg-split_har.conf" = {
        sopsFile = ./wg-split_har.bin;
        format = "binary";
      };
    };
  };
}
