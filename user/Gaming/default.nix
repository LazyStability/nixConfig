{
  pkgs,
  inputs,
  lib,
  ...
}:
# TODO: Overlay proton-ge
let
  prevHeroic = pkgs.heroic.overrideAttrs (oldAttr: rec {
    pname = "heroic";
    version = "2.14.1";
    src = pkgs.fetchFromGitHub {
      owner = "Heroic-Games-Launcher";
      repo = "HeroicGamesLauncher";
      rev = "v${version}";
      hash = "sha256-AnyltqNP+XyVzgCobM3g6DIXntD3spKecYtCRx+8oic=";
    };
  });
in {
  home.packages = with pkgs; [
    # Steam stuff
    steam-run
    gamescope

    # Steam terminal client
    # TODO: Overlay, steamcmd times out package does not build
    steamcmd
    steam-tui

    # better performance
    gamemode

    # Compatibility layer
    wineWowPackages.waylandFull
    inputs.umu.packages.${pkgs.system}.umu
    #A Vulkan-based translation layer for Direct3D 9/10/11 for wine
    dxvk

    # FPS and benchmarking
    mangohud

    # Launcher
    prevHeroic
    lutris
    r2modman

    # Better Eldenring
    #     er-patcher
  ];
}
