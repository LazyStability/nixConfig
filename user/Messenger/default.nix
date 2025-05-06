{ pkgs, ... }:
{
  home.packages = [
    pkgs.element-desktop
  ];
  imports = [ ./vesktop.nix ];
}
