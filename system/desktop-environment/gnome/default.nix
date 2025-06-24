{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.myModules.desktopEnvironment.select == "gnome") {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = with pkgs; [ xterm ];
    };
    environment.gnome.excludePackages =
      (with pkgs; [
        # for packages that are pkgs.*
        gnome-tour
        gnome-connections
        xterm
      ])
      ++ (with pkgs; [
        # for packages that are pkgs.gnome.*
        epiphany # web browser
        geary # email reader
        evince # document viewer
      ]);

    security.rtkit.enable = true;
    services.pipewire = lib.mkDefault {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

    };
  };
}
