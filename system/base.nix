# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  self,
  lib,
  ...
}:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Garbage collection on the nix store
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # Auto optimizes the store to save diskspace
    optimise.automatic = true;
    optimise.persistent = true;

    # Enables the new cli and flakes
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Links the configuration with its git rev
  system.configurationRevision = self.rev or "dirty";

  # https://discourse.nixos.org/t/i-can-unbloat-systemd/74021/4
  systemd.generators.systemd-ssh-generator = "/dev/null";
  systemd.sockets.sshd-unix-local.enable = lib.mkForce false;
  systemd.sockets.sshd-vsock.enable = lib.mkForce false;

  # Default keyboard layout
  services.xserver.xkb = {
    layout = "de";
    variant = "";

  };

  boot.tmp.cleanOnBoot = true;
  services.journald.settings.Journal = {
    SystemMaxFileSize = "50M";
  };

  # Configure console keymap
  console.keyMap = "de";
  networking = {
    firewall.checkReversePath = "loose";
    hosts = {
      "192.168.105.51" = [ "OdinNix" ];
      "192.168.108.9" = [ "VidarNix" ];
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = (
      with pkgs;
      [
        # veracrypt
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        strace
        rsync
        clang
        ffmpeg
        nh
        ripgrep
        gh
        git
        git-lfs
        zsh
        cryptsetup
      ]
    );
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";

      XDG_PICTURES_DIR = "$HOME/Bilder";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # Electron
      NIXOS_OZONE_PLATFORM = 1;
    };
  };
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  # This alllows nix to run binary programs which expect these libraries in FHS compliant paths
  # See here for more info: https://wiki.nixos.org/wiki/Nix-ld
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # List by default
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        android-tools
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        glib
        xz
        systemd
      ];
    };
    nano.enable = false;
    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      # vimdiffAlias = true;
    };
  };
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.dejavu_fonts
      pkgs.nerd-fonts.fira-code
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
    };

  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
