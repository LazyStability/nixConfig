# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, inputs, lib, pkgs, pkgs-unstable, systemSettings, userSettings,  ... }:

{
  imports =
    [
      # hardware is included in the flake
      # inputs.xremap-flake.nixosModules.default
    ];

  #xremap user mode
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "me"];
  users.groups.input.members = [ "me"];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "btrfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;
  systemd.extraConfig = ''
	[Sleep]
	HibernateMode=shutdown
  '';

  # Just using gnome
  services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
};
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.hostName = systemSettings.hosteName; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Hyprland!!
  programs.hyprland.enable = true;
  # # Caching is needed for Hyprland flake
  # nix.settings = {
  #   substituters = ["https://hyprland.cachix.org"];
  # trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  # };
  
  # this is for the hyprland flake which i am currently not using
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

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
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.me = {
    isNormalUser = true;
    description = "mynix";
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment = {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  systemPackages = (with pkgs; [
    wget
    clang
    ffmpeg
    ripgrep
    ags
    git
    zsh
    veracrypt
    wireguard-tools
    nh
    networkmanagerapplet
    gnome.networkmanager-openvpn
    blueberry
    cryptsetup
  ])
      ++
		    (with pkgs-unstable; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      ]);
  sessionVariables = {
    FLAKE = "/etc/nixos";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  };

  # zsh main shell
  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # https://nixos.wiki/wiki/WireGuard#Client_setup_2
  # networking.wg-quick.interfaces = {
  #  wg0 = {
  #    address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
  #    dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
  #    privateKeyFile = "/root/wireguard-keys/privatekey";
  #    
  #    peers = [
  #      {
  #        publicKey = "{server public key}";
  #        presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
  #        allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #        endpoint = "{server ip}:51820";
  #        persistentKeepalive = 25;
  #      }
  #    ];
  #  };
  #};


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

