{
  config,
  lib,
  pkgs-stable,
  ...
}:
{
  # hardware.graphics.enable = true;
  hardware.graphics = {
    enable = true;
  };

  # Load "nvidia" driver for Xorg and wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Fixes suspend issues
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Disable the exp powermanagment
    powerManagement.enable = false;

    # Fine-grained power managment, turns off gpu if not in use,
    # experiment if it works even with it, otherwise of
    powerManagement.finegrained = false;

    # Open source drivers still beta
    open = false;

    # Enable Nvidia settings menu
    # accesable via 'nvidia-settings'
    nvidiaSettings = true;

    # specific driver for my gpu GeForce 3060TI
    # My card is still a current card so this should be supported
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
