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
        version = "nightly";
        src = pkgs.fetchFromGitHub {
          owner = oldAttrs.src.owner;
          repo = oldAttrs.src.repo;
          rev = "6ab8e7b4c8de80fc969ff0c1f1f8e8fdf1b2bd4e";
          hash = "sha256-CsWktReyTDBA0UBQmnHFwLY7MzLDXLS5ZTrW1KiORVc=";
        };
        goModules =
          (pkgs.buildGo124Module {
            pname = "kitty-go-modules";
            inherit version src;
            vendorHash = "sha256-jq0BympW1+FwOeCJKSm16Jn8wqqu+R0n1c4ibr7Ipso=";
          }).goModules;

      })
    );
    settings = {
      # background_opacity = lib.mkForce "0.9";
    };
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
