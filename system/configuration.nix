# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  pkgs-stable,
  self,
  lib,
  ...
}:
{
  # Imports all default.nix files in subdirectories
  imports =
    let
      go =
        dir:
        builtins.mapAttrs (
          n: v:
          if v == "regular" && n == "default.nix" then
            dir + "/${n}"
          else if v == "directory" then
            go (dir + "/${n}")
          else
            { }
        ) (builtins.readDir dir);
      flatten =
        set:
        let
          recurse =
            path:
            lib.attrsets.mapAttrsToList (
              name: value: if builtins.isAttrs value then recurse (path ++ name) value else value
            );
        in
        lib.lists.flatten (recurse "" set);
    in
    flatten (go ./.);

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

  # Default keyboard layout
  services.xserver.xkb = {
    layout = "de";
    variant = "";

  };

  boot.tmp.cleanOnBoot = true;
  services.journald.extraConfig = "SystemMaxFileSize=50M";

  # Configure console keymap
  console.keyMap = "de";
  # Enable CUPS to print documents.
  services.printing.enable = true;
  networking = {
    firewall.checkReversePath = "loose";
    hosts = {
      "192.168.105.51" = [ "OdinNix" ];
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages =
      (with pkgs; [
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

      ])
      ++ (with pkgs-stable; [
      ]);
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
      pkgs.dejavu_fonts
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
