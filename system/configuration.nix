# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  pkgs-stable,
  self,
  ...
}:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enables the new cli and flakes
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Links the configuration with its git rev
  system.configurationRevision = self.rev or "dirty";

  # Default keyboard layout
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  services.journald.extraConfig = "SystemMaxFileSize=50M";

  # Configure console keymap
  console.keyMap = "de";
  # Enable CUPS to print documents.
  services.printing.enable = true;
  networking.firewall.checkReversePath = "loose";
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages =
      let
        patched-nh = pkgs.nh.overrideAttrs (_old: rec {
          pname = "nh";
          version = "4.0.0-beta.11";

          src = pkgs.fetchFromGitHub {
            owner = "nix-community";
            repo = "nh";
            tag = "v${version}";
            hash = "sha256-ILEarFQp89V6RWr5GRU/ip9dB1SEqUFQGs1QMPrk9TQ=";
          };

          preFixup = ''
            mkdir completions
            $out/bin/nh completions bash > completions/nh.bash
            $out/bin/nh completions zsh > completions/nh.zsh
            $out/bin/nh completions fish > completions/nh.fish

            installShellCompletion completions/*
          '';

          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            inherit pname version src;
            hash = "sha256-GnRLUV5dyQgcjBBQXzjW0dvfHqIrlBlIup4b7oL8InI=";
          };
        });
      in
      (with pkgs; [
        steam-run
        # veracrypt
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        clang
        ffmpeg
        ripgrep
        ags
        gh
        git
        zsh
        patched-nh
        wireshark
        networkmanagerapplet
        networkmanager-openvpn
        blueberry
        cryptsetup
        piper
      ])
      ++ (with pkgs-stable; [
      ]);
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXOS_OZONE_PLATFORM = 1;
    };
  };
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
