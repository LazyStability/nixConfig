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
    programs = {
      firejail.wrappedBinaries.steam = {
        executable = "${lib.getBin pkgs.steam}/bin/steam";
        profile = "${pkgs.firejail}/etc/firejail/steam.profile";
        desktop = "${lib.getBin pkgs.steam}/share/applications/steam.desktop";
      };

      steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          steamtinkerlaunch
        ];

      };
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
