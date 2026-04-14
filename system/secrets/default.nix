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
    secrets = {
      "samba/login_data" = {
        sopsFile = ./samba.yaml;
      };
      "samba/destination" = {
        sopsFile = ./samba.yaml;
      };
      restic-password = {
        sopsFile = ./samba.yaml;
      };
    };

  };
}
