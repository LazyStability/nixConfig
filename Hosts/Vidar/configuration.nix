# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../system/base.nix
    # Feature modules
    ../../system/secrets
    ../../system/programs/shell
    ../../system/services/server/harmonia
    ../../system/services/server/auto-build-service
    ./secrets
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "VidarNix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    nameservers = [
      "192.168.108.30"
      "fdc3:c37b:a1e0:0:b2f2:8ff:fede:8265"
      "fritz.box"
    ];
    interfaces.ens33 = {
      ipv4.addresses = [
        {
          address = "192.168.108.9";
          prefixLength = 27;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.108.30";
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

  services.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.root.password = "12345";
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
      hashedPasswordFile = config.sops.secrets.hagen-password.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQUQQWdmgdktQTRgBq0phM5fh5+QCBBtaeGmUouWwkv Klysmus@online.de"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIujGMZjW+D/bbywnmZ10KK1PrwIHgn8rD6b/rRI77YzuhgR3GnXnGH8MQc0gTftoHDCF12KDyB+CVrYynudRuA= LazilyStable@proton.me"
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

  virtualisation.vmware.guest.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
    };
  };

  hardware.bluetooth.enable = lib.mkForce false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
