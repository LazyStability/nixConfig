{
  lib,
  config,
  pkgs,
  extraPackages,
  ...
}:
let
  cfg = config.myModules.gaming;
in
{
  options.myModules.gaming = {
    enable = lib.mkEnableOption "enable gaming module required for gamescope session and shadowplay";
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          # https://discuss.cachyos.org/t/how-to-manage-graphicsdriver-settings/23770/4
          # LD_PRELOAD = "";
          # VK_LOADER_LAYERS_ENABLE = "VK_LAYER_MANGOHUD_overlay_x86_64";
          # MANGOHUD = true;
          # OBS_VKCAPTURE = true;
          # RADV_TEX_ANISO = 16;
        };
        extraBwrapArgs = [
          # Sandboxing steam
          "--tmpfs /home"
          "--bind  \"$HOME/.local/share/steam-sandbox\" \"$HOME\""
          "--bind \"$HOME/.local/share/Valve Corporation\" \"$HOME/.local/share/Valve Corporation\""
          "--bind \"$HOME/.local/share/Steam\" \"$HOME/.local/share/Steam\""

          # Bind my gamefolder
          "--bind \"/mnt/games\" \"$HOME/Games\" "

          # Get cursor working
          "--bind \"$HOME/.themes/\" \"$HOME/.themes/\""
          "--bind \"$HOME/.local/share/icons\" \"$HOME/.local/share/icons\""
          "--bind \"$HOME/.gtkrc-2.0\" \"$HOME/.gtkrc-2.0\""
          "--bind \"$HOME/.config/gtk-3.0\" \"$HOME/.config/gtk-3.0\""
          "--bind \"$HOME/.config/Kvantum\" \"$HOME/.config/Kvantum\""
          "--bind \"$HOME/.config/qt5ct\" \"$HOME/.config/qt5ct\""
          "--bind \"$HOME/.config/qt6ct\" \"$HOME/.config/qt6ct\""
          "--bind \"$HOME/.Xresources\" \"$HOME/.Xresources\""
          "--bind-try \"$XDG_DOCUMENTS_DIR/My\ Games\" \"$XDG_DOCUMENTS_DIR\" "
        ];
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        steamtinkerlaunch
      ];

    };

    programs.gamemode.enable = true;
    programs.gpu-screen-recorder = {
      # package = (
      #   pkgs.runCommand "gpu-screen-recorder"
      #     {
      #       nativeBuildInputs = [ pkgs.makeWrapper ];
      #     }
      #     ''
      #       mkdir -p $out/bin
      #       makeWrapper ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder $out/bin/gpu-screen-recorder \
      #         --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
      #         --prefix LD_LIBRARY_PATH : ${config.boot.kernelPackages.nvidia_x11}/lib
      #     ''
      # );
      enable = true;
    };
    environment.systemPackages = [
      pkgs.gpu-screen-recorder-gtk
      pkgs.protonup-rs
    ];
  };
}
