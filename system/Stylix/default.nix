{
  pkgs,
  inputs,
  ...
}: let
  Ember = {
    scheme = "Ember";
    author = "Emmet K (https://gitlab.com/librephoenix)";
    base00 = "330a0a";
    base01 = "4d0a0a";
    base02 = "662a0a";
    base03 = "992f0a";
    base04 = "c05a0a";
    base05 = "f89852";
    base06 = "ffb441";
    base07 = "ffc8b5";
    base08 = "f92622";
    base09 = "fd751f";
    base0A = "fdc51f";
    base0B = "8682fe";
    base0C = "f1bf84";
    base0D = "b6b98f";
    base0E = "a275a0";
    base0F = "bb86cc";
  };
  Tokyo-night = {
    scheme = "Tokyonight";
    author = "Folke Lemaitre (https://github.com/folke)";
    base00 = "24283b";
    base01 = "1f2335";
    base02 = "292e42";
    base03 = "565f89";
    base04 = "a9b1d6";
    base05 = "c0caf5";
    base06 = "c0caf5";
    base07 = "c0caf5";
    base08 = "f7768e";
    base09 = "ff9e64";
    base0A = "e0af68";
    base0B = "9ece6a";
    base0C = "1abc9c";
    base0D = "41a6b5";
    base0E = "bb9af7";
    base0F = "ff007c";
  };
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix.enable = true;
  # # Theme
  stylix.base16Scheme = Tokyo-night;
  stylix.polarity = "dark";

  ###########
  ## Fonts ##
  ###########
  stylix.fonts = {
    monospace = {
      name = "FireCode";
      package = with pkgs; (nerdfonts.override {fonts = ["FiraCode"];});
    };
    sansSerif = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
    };
    serif = {
      name = "DejaVu Serif";
      package = pkgs.dejavu_fonts;
    };
  };

  # Wallpaper set because it is mandatory, would not have been set otherwise
  stylix.image = ../../wallpaper/AbstraktWallpaper.jpg;

  ############
  ## Cursor ##
  ############
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };
}
