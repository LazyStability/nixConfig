{...}:
{
  imports = [
    ./nvidia.nix
    ./hardware-configuration.nix
  ];
  environment = {
    sessionVariables = {
        FLAKE = "/persist/etc/nixos";
};
};
}
