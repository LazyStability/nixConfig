{...}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  environment = {
    sessionVariables = {
        FLAKE = "/etc/nixos";
};
};
}
