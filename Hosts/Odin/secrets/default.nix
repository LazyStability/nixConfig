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
    age.keyFile = "/etc/ssh/age_key";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      "paperless-admin" = { };
      "syncthing/key" = {
      };
      "syncthing/cert" = {
      };
    };
  };
}
