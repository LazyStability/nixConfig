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
        # TODO: These need to be filled here and in the wireguard file
        builtins.map (fill-interface) [
          # "ginyu_nyx"
          "itsec"
          # "split_har"
        ]
      );
    in
    {
      age.keyFile = "/persist/etc/ssh/github_kickstart_age";
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";

      secrets = {
        user-password.neededForUsers = true;
        # TODO: These need to be fixed
        "syncthing/key" = {
          owner = "me";
        };
        "syncthing/cert" = {
          owner = "me";
        };
      } // wireguard-keys;
    };
}
