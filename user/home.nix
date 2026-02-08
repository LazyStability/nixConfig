{
  pkgs,
  config,
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

  home.packages = (
    with pkgs;
    let
      patched-mpv = pkgs.mpv.overrideAttrs {
        waylandSupport = true;
        sdl2Support = true;
        scripts = with pkgs.mpvScripts; [
          modernz
          mpris
          mpv-discord
          sponsorblock
        ];
      };

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
      kitty-sessionizer = pkgs.callPackage ../packages/kitty-sessionizer { };
      patched-sioyek = (
        pkgs.symlinkJoin {
          name = "sioyek";
          paths = [ pkgs.sioyek ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/sioyek \
              --set QT_QPA_PLATFORM xcb
          '';
        }
      );
      patched-vesktop = vesktop.override {
        withSystemVencord = true;
        vencord = patched-vencord;
      };
      patched-vencord = vencord.overrideAttrs (old: {
        version = "unstable-2026-01-28";
        src = fetchFromGitHub {
          owner = old.src.owner;
          repo = old.src.repo;
          rev = "0126090c8f06849cde9df18030f52e31931ece49";
          hash = "sha256-/DkTfi6fYlLQUSzPawHxZJK0C+vaZp5ho3ZiB/bGQAQ=";
        };
      });

      # From here https://github.com/Builditluc/wiki-tui/issues/267#issuecomment-3223496743
      patched-wiki-tui = wiki-tui.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          gnugrep
          findutils
          gnused
        ];
        postPatch = (old.postPatch or "") + ''
          set -e
          UA='wiki-tui/0.9.1 (+https://github.com/Builditluc/wiki-tui; contact: you@example.com)'

          # For each Rust file in wiki-api/, add a UA header on request builders like:
          #   Client::... .get(endpoint|url) ...
          while IFS= read -r -d "" f; do
            changed=0

            # Inject header after common patterns of .get(...)
            for pat in '.get(endpoint)' '.get(&endpoint)' '.get(url)' '.get(&url)'; do
              if grep -q "$pat" "$f"; then
                substituteInPlace "$f" --replace "$pat" "$pat.header(reqwest::header::USER_AGENT, \"$UA\")"
                changed=1
              fi
            done

            # If we added headers, ensure USER_AGENT is imported (idempotent)
            if [ "$changed" = 1 ] && ! grep -q 'header::USER_AGENT' "$f"; then
              sed -i '1 i use reqwest::header::USER_AGENT;' "$f"
            fi
          done < <(find wiki-api -type f -name '*.rs' -print0)

          # Also add origin=* wherever the Action API base params are set (avoids CORS oddities)
          for f in $(grep -RIl --include='*.rs' '("formatversion", "2")' wiki-api || true); do
            if ! grep -q '("origin"' "$f"; then
              substituteInPlace "$f" \
                --replace '("formatversion", "2"),' \
                          '("formatversion", "2"), ("origin","*"),'
            fi
          done
        '';
      });
    in
    [
      obsidian
      localsend
      vscode
      # xdg default
      kdePackages.okular

      imv
      keymapp
      piper
      networkmanagerapplet
      networkmanager-openvpn
      blueberry
      element-desktop
      iamb

      gimp
      brave
      nautilus

      # lsps
      lua-language-server
      pyright
      # texlab
      nixd
      nix-init # Create derivations from git urls
      harper
      llvmPackages_19.clang-unwrapped
      stylua
      typescript-language-server
      nodePackages.bash-language-server
      hyprls

      # typst
      typst
      tinymist
      typstyle

      # Markdown
      pandoc
      live-server

      #formatter
      nixfmt

      # latex
      # tex

      # Utility
      wl-clipboard

      # calibre
      dungeondraft
      rnote
      inkscape
      hyperfine
      tor-browser
      reddit-tui
      anki
      zotero
      prismlauncher
      yt-dlp
      wl-clipboard
      signal-desktop
      piper
      remmina
      w3m
      komikku
      kitty
      kitty-sessionizer
      patched-mpv
      # patched-keepassxc
      keepassxc
      patched-wiki-tui
      patched-sioyek
      patched-vesktop
    ]
  );

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser =
          if config.programs.floorp.enable then
            "floorp.desktop"
          else if config.programs.firefox.enable then
            "firefox.desktop"
          else
            "brave.desktop";
      in
      {
        "text/html" = [ browser ];
        "x-scheme-handler/http" = [ browser ];
        "x-scheme-handler/https" = [ browser ];
        "x-scheme-handler/about" = [ browser ];
        "x-scheme-handler/unknown" = [ browser ];
        "x-scheme-handler/ror2mm" = [ "r2modman.desktop" ];
        "x-scheme-handler/chrome" = [ browser ];
        "application/x-extension-htm" = [ browser ];
        "application/x-extension-html" = [ browser ];
        "application/x-extension-shtml" = [ browser ];
        "application/xhtml+xml" = [ browser ];
        "application/x-extension-xhtml" = [ browser ];
        "application/x-extension-xht" = [ browser ];
        "application/pdf" = [ "sioyek.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        # "inode/directory" = ["yazi-standalone.desktop"];
      };
  };

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
