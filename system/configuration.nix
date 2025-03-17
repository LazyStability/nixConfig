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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

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
        gh
        git
        zsh
        nh
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
