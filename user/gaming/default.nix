{
  pkgs,
  config,
  ...
}:
# TODO: Overlay proton-ge
{
  hjem.users.me.packages =
    with pkgs;
    (lib.mkIf config.myModules.gaming.enable) [
      # Steam stuff
      steam-run
      gamescope

      # Steam terminal client
      # Needs to be build from source, takes about 2 min and I cant even use it because steam does not verify my passwort :(
      # steamcmd
      # steam-tui

      # better performance
      gamemode
      archipelago
      ryubing

      # Compatibility layer
      # wineWowPackages.waylandFull
      # inputs.umu.packages.${pkgs.system}.umu
      #A Vulkan-based translation layer for Direct3D 9/10/11 for wine
      dxvk

      # FPS and benchmarking
      mangohud

      # Launcher
      # prevHeroic
      heroic
      # lutris
      r2modman
      eepers # Cool game

      # Better Eldenring
      #     er-patcher
    ];
}
