{
  pkgs,
  config,
  pkgs-stable,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./secrets
    ./hardware-configuration.nix

    ../../system/configuration.nix
    ./wireguard.nix

    inputs.disko.nixosModules.default
    (import ../../system/disko.nix {
      device = "/dev/disk/by-id/nvme-eui.002538da21a048cb";
      # inherit inputs;
    })

    inputs.home-manager.nixosModules.default
  ];
  environment = {
    sessionVariables = {
      NH_FLAKE = "/persist/etc/nixos";
    };
  };

  ################
  ## Networking ##
  ################
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    hostName = "Nyx"; # Define your hostname.
    networkmanager = {
      enable = true; # Easiest to use and most distros use this by default.
      wifi.powersave = true;
    };
  };
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
  systemd.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';
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
    wireguard.enable = true;
    desktopEnvironment = {
      select = "hyprland";
      monitors = [
        {
          name = "eDP-1";
          enable = true;
          mode = "1920x1080";
          position = "0x0";
          rate = "60";
        }
      ];
    };
  };

  programs = {
    wireshark.enable = true;
    ydotool.enable = true;
    thunderbird.enable = true;

    adb.enable = true;
    kdeconnect.enable = true;
  };

  # List services that you want to enable:
  # Mouse
  services = {
    ratbagd.enable = true;
    syncthing.enable = true;
    playerctld.enable = true;
    # Handle lid behaviour
    logind = {
      lidSwitchDocked = "ignore";
      lidSwitch = "poweroff";
    };
  };

  ##################
  ## Laptop Power ##
  ##################

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        energy_performance_preference = "power";
        energy_perf_bias = "power";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
        energy_performance_preference = "performance";
      };
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
