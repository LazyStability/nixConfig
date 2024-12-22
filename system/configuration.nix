# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-stable,
  systemSettings,
  userSettings,
  ...
}: let
  DesktopEnvironmentPath = lib.path.append ./Desktop_Environment userSettings.wm;
in {
  imports = [
    # inputs.impermance.nixosModules.impermance
    # Installs dependencies for the Desktop environment
    DesktopEnvironmentPath
    # Login with greetd & Hyprland & ags
    # ./greetd/greetd.nix

    # ./impermanence/default.nix
    ./Stylix
    ./services/syncthing
    ./services/wireguard
    ./services/radicale

    ./gaming

    inputs.home-manager.nixosModules.default
  ];

  #xremap user mode
  hardware.uinput.enable = true;
  users.groups.uinput.members = ["me"];
  users.groups.input.members = ["me"];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = ["btrfs"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;
  systemd.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    extra-trusted-substituters = [
      "https://cache.nixos.org/"
      "https://hydra.nixos.org/"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  # networking.hostName = systemSettings.hosteName; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  systemd.services.NetworkManager-wait-online.enable = false; # Takes forever on boot and is not necessary

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Default keyboard layout
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  ###########
  ## Users ##
  ###########

  # User Hardening
  users.mutableUsers = false;
  users.users.root.hashedPassword = "*";
  users.users.me = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$cr3AwlwB1xsr7trhUULj./$hNmPq6jznKljbUI4KoMEWypjiFGzf.iITjZyy40MxE2";
    description = "mynix";
    extraGroups = ["networkmanager" "wheel"]; # Enable ‘sudo’ for the user.
  };

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs;
      inherit pkgs-stable;
      inherit inputs;
      inherit userSettings;
    };
    users = {
      "me" = import ../user/home.nix;
    };
  };

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages =
      (with pkgs; [
        steam-run
        # veracrypt
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        clang
        ffmpeg
        ripgrep
        ags
        git
        zsh
        nh
        networkmanagerapplet
        networkmanager-openvpn
        blueberry
        cryptsetup
      ])
      ++ (with pkgs-stable; [
        ]);
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  # zsh main shell
  environment.shells = with pkgs; [zsh];
  environment.pathsToLink = ["/share/zsh"];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.thunderbird.enable = true;
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
