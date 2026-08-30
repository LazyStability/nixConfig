{
  pkgs,
  config,
  lib,
  jail,
  ...
}:
{
  hjem.users.me.packages =
    let
      steam-commons = with jail.combinators; [
        network

        (rw-bind (noescape "\"$HOME/.local/share/steam-sandbox\"") (noescape "\"$HOME\""))
        (readwrite (noescape "\"$HOME/.local/share/Valve Corporation\""))
        (readwrite (noescape "\"$HOME/.local/share/Steam\""))

        # Bind my gamefolder
        (rw-bind (noescape "\"/mnt/games\"") (noescape "\"$HOME/Games\" "))

        # Get cursor working
        (readonly (noescape "\"$HOME/.themes/\""))
        (readonly (noescape "\"$HOME/.local/share/icons\""))
        (readonly (noescape "\"$HOME/.gtkrc-2.0\""))
        (readonly (noescape "\"$HOME/.config/gtk-3.0\""))
        (readonly (noescape "\"$HOME/.config/Kvantum\""))
        (readonly (noescape "\"$HOME/.config/qt5ct\""))
        (readonly (noescape "\"$HOME/.config/qt6ct\""))
        (readonly (noescape "\"$HOME/.Xresources\""))
        (rw-bind (noescape "\"$HOME/Dokumente/\"") (noescape "\"$HOME/Dokumente/My\ Games\""))
      ];
      archipelago = jail "archipelago" pkgs.archipelago (
        steam-commons
        ++ (with jail.combinators; [
          gui
          wayland
          gpu
          pulse
          xwayland
          # Directly bind XDG_BASE_DIRS into the sandbox
          (readwrite (noescape "\"$XDG_CONFIG_HOME/Archipelago\""))
          (readwrite (noescape "\"$XDG_CACHE_HOME/Archipelago\""))
          (readwrite (noescape "\"$XDG_DATA_HOME/Archipelago\""))
          (readwrite (noescape "\"$XDG_STATE_HOME/Archipelago\""))
          (add-runtime ''
            mkdir -p "$XDG_STATE_HOME/Archipelago" "$XDG_DATA_HOME/Archipelago" "$XDG_CONFIG_HOME/Archipelago" "$XDG_CACHE_HOME/Archipelago"
          '')
        ])
      );
      steamcmd = jail "steamcmd" pkgs.steamcmd steam-commons;
      steam-tui = jail "steamtui" pkgs.steam-tui steam-commons;
    in
    (lib.mkIf config.myModules.gaming.enable) [
      # Steam stuff
      pkgs.steam-run
      pkgs.gamescope

      # Steam terminal client
      # Needs to be build from source, takes about 2 min and I cant even use it because it shows an empty library
      # steamcmd
      # steam-tui

      # better performance
      pkgs.gamemode
      archipelago
      #ryubing

      # Minecraft
      pkgs.prismlauncher
      # Compatibility layer
      # wineWowPackages.waylandFull
      # inputs.umu.packages.${pkgs.system}.umu
      #A Vulkan-based translation layer for Direct3D 9/10/11 for wine
      pkgs.dxvk

      # FPS and benchmarking
      pkgs.mangohud

      # Launcher
      # prevHeroic
      pkgs.heroic
      # lutris
      pkgs.r2modman
      pkgs.eepers # Cool game

      # Better Eldenring
      #     er-patcher
    ];
}
