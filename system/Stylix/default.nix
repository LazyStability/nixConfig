{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix.enable = true;
  # Theme
  # stylix.base16Scheme = {};
  stylix.image = /home/me/Bilder/Wallpaper/AbstraktWallpaper.jpg;

  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";
}
