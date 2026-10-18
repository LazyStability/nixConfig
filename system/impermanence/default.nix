{ config, lib, ... }:
{
  options.dataLinks = {
    dataPath = lib.mkOption {
      default = "/mnt/data";
      type = lib.types.str;
      description = "Partition were all the data directories reside";
    };
    dataDirectoryList = lib.mkOption {
      default = [
        "Musik"
        "Bilder"
        "Videos"
        "Dokumente"
        # "Downloads"
        "Software"
      ];
      type = lib.types.listOf lib.types.str;
      description = "All the Directories which should be linked to home";
    };
    gamesPath = lib.mkOption {
      default = "/mnt/games";
      type = lib.types.str;
      description = "partition were Games reside";
    };
  };
  config = {
    systemd.tmpfiles.rules =
      let
        createSystemdTmpfileRule = subDir: "L+ /home/me/${subDir} - - - - /${config.dataLinks.dataPath}/${subDir}";
      in
      lib.map createSystemdTmpfileRule config.dataLinks.dataDirectoryList
      ++
        # TODO: Use the same function as above to generate from gamesPath
        [ "L+ /home/me/Games - - - - ${config.dataLinks.gamesPath}" ];
  };
}
