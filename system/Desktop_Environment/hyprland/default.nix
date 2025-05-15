{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../greetd/greetd.nix
  ];
  config = lib.mkIf (config.myModules.desktopEnvironment.select == "hyprland") {

    environment.systemPackages = with pkgs; [
      # For automounting cd or usbsticks
      # Usage https://github.com/coldfix/udiskie/wiki/Usage
      # udiskie-umount and udiskie-mount for manuel (de)mounting
      udiskie
    ];
    services.udisks2.enable = true;
    # The following blocks are for the hyprland flake. that you would need to put into your flake.nix in inputs.hyprland
    # Caching so you don't have to build hyprland yourself.
    # nix.settings = {
    #   substituters = ["https://hyprland.cachix.org"];
    # trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };

    # Overrides the hyprland package in nixpkgs with the one from the flake
    # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    # Enable uwsm, a session manager. Its purpose is to have all applications and services not depend on the compositor itself.
    programs.uwsm.enable = true;
    # Enable hyprland
    programs.hyprland = {
      enable = true;
      withUWSM = true;

      # These are the default values, I just put them here for completion
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    # Enable greeter configured in ../../greetd/greetd.nix
    services.greetd.enable = true;

    # Hyprland uses pipewire for screensharing, all pulseaudio application should still work
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = lib.mkDefault true;
    };
  };
}
