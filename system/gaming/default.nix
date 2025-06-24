{
  pkgs,
  lib,
  config,
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
  };
}
