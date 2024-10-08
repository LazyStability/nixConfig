{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ../../greetd/greetd.nix
  ];

  systemPackages = (with pkgs; [
    # For automounting cd or usbsticks
    udiskie
  ]);
  # The following blocks are for the hyprland flake. that you would need to put into your flake.nix in inputs.hyprland
  # Caching so you don't have to build hyprland yourself.
  # nix.settings = {
  #   substituters = ["https://hyprland.cachix.org"];
  # trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  # };
  
  # Overrides the hyprland package in nixpkgs with the one from the flake
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # Enable hyprland
  programs.hyprland = {
    enable = true;

    # These are the default values, I just put them here for completion
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # Hyprland uses pipewire for screensharing, all pulseaudio application should still work
  services.pipewire = {
    enable = true;
    pulse.enable = lib.mkDefault true;
  };
}
