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
  sops =
    let
      fill-interface =
        name:
        let
          wireguard-connection-secrets = {
            sopsFile = ./secrets.yaml;
            format = "yaml";
          };
        in
        {
          "${name}/address1" = wireguard-connection-secrets;
          "${name}/private-key" = wireguard-connection-secrets;
          "${name}/allowed-ips" = wireguard-connection-secrets;
          "${name}/endpoint" = wireguard-connection-secrets;
          "${name}/preshared-key" = wireguard-connection-secrets;
        };
      wireguard-keys = lib.attrsets.mergeAttrsList (
        builtins.map (fill-interface) [
          "ginyu_kronos"
          "itsec"
          "split_har"
        ]
      );
    in
    {
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
        "syncthing/key" = {
          sopsFile = ./syncthing.yaml;
          format = "yaml";
          owner = "me";
        };
        "syncthing/cert" = {
          sopsFile = ./syncthing.yaml;
          format = "yaml";
          owner = "me";
        };
        "samba/login_data" = {
          sopsFile = ./samba.yaml;
          format = "yaml";
        };
        "samba/destination" = {
          sopsFile = ./samba.yaml;
          format = "yaml";
        };
      } // wireguard-keys;
    };
}

# address1 = { };
# private-key = { };
# allowed-ips = { };
# endpoint = { };
# preshared-key = { };
