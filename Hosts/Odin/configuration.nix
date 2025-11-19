# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../system/configuration.nix
    ./secrets
  ];
  # enable auto updates
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "OdinNix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    nameservers = [
      "192.168.105.30"
      "fdc3:c37b:a1e0:0:b2f2:8ff:fede:8265"
      "fritz.box"
    ];
    interfaces.ens33 = {
      ipv4.addresses = [
        {
          address = "192.168.105.51";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.105.30";
      interface = "ens33";
    };
  };

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    Bjoern = {
      isNormalUser = true;
      description = "Björn";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [ kdePackages.kate ];
    };
    hagen = {
      isNormalUser = true;
      description = "Hagen";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQUQQWdmgdktQTRgBq0phM5fh5+QCBBtaeGmUouWwkv Klysmus@online.de"
      ];
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        kdePackages.kate
        #  thunderbird
      ];
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  virtualisation.vmware.guest.enable = true;

  # List services that you want to enable:
  services.gitolite = {
    enable = true;
    adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQUQQWdmgdktQTRgBq0phM5fh5+QCBBtaeGmUouWwkv Klysmus@online.de";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "yes";
    };
  };

  myModules = {
    disks.samba.enable = true;
    desktopEnvironment = {
      select = "kde";
    };
  };
  services = {
    radicale.enable = true;
    paperless.enable = true;
    syncthing = {
      enable = false;
      cert = lib.mkForce null;
      key = lib.mkForce null;
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
