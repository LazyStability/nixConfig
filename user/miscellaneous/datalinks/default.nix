{ config, lib, ... }:
let
  cfg = config.myHomeModules.dataLinks;
in
{
  options.myHomeModules.dataLinks = {
    enable = lib.mkEnableOption "dataLinks";
    dataPath = lib.mkOption {
      default = "/data";
      type = lib.types.str;
      description = "Partition were all the data directories reside";
    };
    dataDirectoryList = lib.mkOption {
      default = [
        "Musik"
        "Bilder"
        "Videos"
        "Dokumente"
        "Downloads"
        "Software"
      ];
      type = lib.types.listOf lib.types.str;
      description = "All the Directories which should be linked to home";
    };
    gamesPath = lib.mkOption {
      default = "/games";
      type = lib.types.str;
      description = "partition were Games reside";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.tmpfiles.rules =
      let
        createSystemdTmpfileRule = subDir: "L+ /home/me/${subDir} - - - - /${cfg.dataPath}/${subDir}";
      in
      lib.map createSystemdTmpfileRule cfg.dataDirectoryList
      ++
        # TODO: Use the same function as above to generate from gamesPath
        [ "L+ /home/me/Games - - - - ${cfg.gamesPath}" ];
  };
}
