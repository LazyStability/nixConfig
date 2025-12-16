{
  pkgs,
  config,
  pkgs-stable,
  inputs,
  ...
}:
{
  imports = [
    ./nvidia.nix
    ./secrets
    ./hardware-configuration.nix
    ./wireguard.nix

    ../../system/configuration.nix

    inputs.disko.nixosModules.default
    (import ../../system/disko.nix {
      device = "/dev/disk/by-id/wwn-0x5002538043584d30";
      # inherit inputs;
    })

    inputs.home-manager.nixosModules.default
  ];
  environment = {
    sessionVariables = {
      NH_FLAKE = "/persist/etc/nixos";
    };
  };
  networking.hostName = "Kronos"; # Define your hostname.

  ################
  ## Networking ##
  ################
  # networking.hostName = systemSettings.hosteName; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # systemd.services.NetworkManager-wait-online.enable = false; # Takes forever on boot and is not necessary

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "btrfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;
  ###########
  ## Users ##
  ###########

  # User Hardening
  users.mutableUsers = false;
  users.users.root.hashedPassword = "*";
  users.users.me = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.user-password.path;
    description = "mynix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
      "wireshark"
      "ydotool"
    ]; # Enable ‘sudo’ for the user.
  };
  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs;
      inherit pkgs-stable;
      inherit inputs;
    };
    users = {
      "me" = import ./me.nix;
    };
  };
  myModules = {
    disks.samba.enable = true;
    gaming.enable = true;
    wireguard.enable = true;
    desktopEnvironment = {
      select = "hyprland";
      monitors = [
        {
          name = "DP-1";
          enable = true;
          position = "1920x0";
          mode = "3840x2160";
          scale = "1.5";
          rate = "60";
          primary = true;
        }
        {
          name = "DP-2";
          enable = true;
          mode = "1920x1200";
          position = "0x0";
          scale = "1";
          rate = "60";
        }
      ];
    };
  };

  virtualisation = {
    docker.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd.enable = true;
  };
  programs = {
    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;
    ydotool.enable = true;
    thunderbird.enable = true;
    firejail = {
      enable = true;
    };

    adb.enable = true;
    kdeconnect.enable = true;
  };

  # List services that you want to enable:
  # Mouse
  services = {
    ratbagd.enable = true;
    # llama-cpp.enable = true;
    syncthing.enable = true;
    playerctld.enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
