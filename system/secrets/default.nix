{
  pkgs,
  inputs,
  lib,
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
    secrets = {
      "samba/login_data" = {
        sopsFile = ./samba.yaml;
      };
      "samba/destination" = {
        sopsFile = ./samba.yaml;
      };
    };
  };
}
