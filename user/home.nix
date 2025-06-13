{
  pkgs,
  pkgs-stable,
  lib,
  ...
}:
{
  home.stateVersion = "23.11"; # Dont change without reading release change, might break

  nixpkgs.config.allowUnfree = true;
  # Imports all default.nix in all subfolders.
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
        (lib.lists.flatten (recurse "" set));
    in
    (flatten (go ./.));

  home.packages =
    (
      with pkgs;
      let
        patched-keepassxc = keepassxc.overrideAttrs (previousAttrs: {
          version = "patched";
          src = fetchFromGitHub {
            owner = "keepassxreboot";
            repo = "keepassxc";
            rev = "fc1bd2009959141e06f66d23f0908e0ac048c75d";
            hash = "sha256-lZ/fDTeC77pv93fYvPf/ocnxU0JX+liSLQx+rhTxlaQ=";
          };
          patches = [ ];
          # Tests fail so, fuck tests
          checkFlags = [ "-skip" ];
          buildInputs = previousAttrs.buildInputs ++ [ keyutils ];
        });
        dungeondraft = pkgs.callPackage ../packages/dungeondraft { };
      in
      [
        obsidian
        vscode
        # xdg default
        kdePackages.okular
        imv
        glance
        wealthfolio
        keymapp
        piper
        networkmanagerapplet
        networkmanager-openvpn
        blueberry

        obs-studio
        sonusmix
        gimp
        brave
        nautilus

        # calibre
        tor
        reddit-tui
        zathura
        zotero
        prismlauncher
        yt-dlp
        wl-clipboard
        signal-desktop
        piper
        patched-keepassxc
        dungeondraft
        remmina
        w3m

      ]
    )
    ++ (with pkgs-stable; [
    ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
      "x-scheme-handler/ror2mm" = [ "r2modman.desktop" ];
      "x-scheme-handler/chrome" = [ "zen.desktop" ];
      "application/x-extension-htm" = [ "zen.desktop" ];
      "application/x-extension-html" = [ "zen.desktop" ];
      "application/x-extension-shtml" = [ "zen.desktop" ];
      "application/xhtml+xml" = [ "zen.desktop" ];
      "application/x-extension-xhtml" = [ "zen.desktop" ];
      "application/x-extension-xht" = [ "zen.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      # "inode/directory" = ["yazi-standalone.desktop"];
    };
  };

  nix.gc = {
    automatic = true;
    persistent = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
