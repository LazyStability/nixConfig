{...}:{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      splash_offset = 2.0;

      preload =
        [ "~/Bilder/Wallpaper/MinimalisticAbstract.jpg" "~/Bilder/Wallpaper/AbstraktWallpaper.jpg" ];

      wallpaper = [
        "DP-2,~/Bilder/Wallpaper/MinimalisticAbstract.jpg"
        "DP-1,~/Bilder/Wallpaper/AbstraktWallpaper.jpg"
      ];
    };
  };
}
