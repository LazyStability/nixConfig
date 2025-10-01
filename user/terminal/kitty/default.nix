{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.file = lib.mkIf config.programs.kitty.enable {
    ".config/kitty/relative_resize.py".source = ./relative_resize.py;
    ".config/kitty/Broadcast.py".source = ./Broadcast.py;
    ".config/kitty/split_window.py".source = ./split_window.py;
    ".config/kitty/neighboring_window.py".source = ./neighboring_window.py;
  };
  stylix.targets.kitty.enable = false;
  programs.kitty = lib.mkIf config.programs.kitty.enable {
    package = (
      pkgs.kitty.overrideAttrs (oldAttrs: rec {
        version = "0.43.1";
        src = pkgs.fetchFromGitHub {
          owner = oldAttrs.src.owner;
          repo = oldAttrs.src.repo;
          rev = "7f24dd68c98d8f4712457560f25e8056cce52ec8";
          hash = "sha256-Wd61Q1sG55oDxPuHJpmvSWuptwJIuzgn2sB/dzNRc1c=";
        };
        goModules =
          (pkgs.buildGo124Module {
            pname = "kitty-go-modules";
            inherit version src;
            vendorHash = "sha256-bjtzvEQmpsrwD0BArw9N6/HqMB3T5xeqxpx89FV7p2A=";
          }).goModules;

      })
    );
    settings = {
      # background_opacity = lib.mkForce "0.9";
    };
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
