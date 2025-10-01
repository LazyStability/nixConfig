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
    # TODO: remove wireguard for thor enterely
    age.keyFile = "/etc/ssh/github_kickstart_age";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      user-password.neededForUsers = true;
      # TODO: look up the correct values
      "syncthing/key" = {
        owner = "me";
      };
      "syncthing/cert" = {
        owner = "me";
      };
    };
  };
}
