{
  pkgs,
  inputs,
  lib,
  ...
}:
# TODO: Overlay proton-ge
let
  prevHeroic = pkgs.heroic.overrideAttrs (oldAttr: rec {
    pname = "Heroic-old";
    version = "2.14.1";
    src = pkgs.fetchFromGitHub {
      owner = "Heroic-Games-Launcher";
      repo = "HeroicGamesLauncher";
      rev = "v${version}";
      hash = "sha256-AnyltqNP+XyVzgCobM3g6DIXntD3spKecYtCRx+8oic=";
      name = "${pname}-${version}";
    };
  });
in {
  home.packages = with pkgs; [
    # Steam stuff
    steam-run
    gamescope

    # Steam terminal client
    # Needs to be build from source, takes about 2 min and I cant even use it because steam does not verify my passwort :(
    # steamcmd
    # steam-tui

    # better performance
    gamemode

    # Compatibility layer
    wineWowPackages.waylandFull
    # inputs.umu.packages.${pkgs.system}.umu
    #A Vulkan-based translation layer for Direct3D 9/10/11 for wine
    dxvk

    # FPS and benchmarking
    mangohud

    # Launcher
    # prevHeroic
    heroic
    lutris
    r2modman

    # Better Eldenring
    #     er-patcher
  ];
}
