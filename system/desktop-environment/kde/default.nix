{ config, lib, ... }:
{

  config = lib.mkIf (config.myModules.desktopEnvironment.select == "kde") {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
