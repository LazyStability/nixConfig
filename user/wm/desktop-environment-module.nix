{
  osConfig,
  config,
  lib,
  ...
}:
let
  cfg = config.myHomeModules.desktopEnvironment;
  subDirsIn =
    dir:
    builtins.mapAttrs (name: _: import (dir + "/${name}")) (
      lib.filterAttrs (name: type: type == "directory" && name != "desktopUtils") (builtins.readDir dir)
    );
  monitorType = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable this monitor";
      };
      name = lib.mkOption {
        default = "DP-1";
        type = lib.types.str;
        description = "Name of the monitor";
      };
      mode = lib.mkOption {
        default = "1920x1200";
        type = lib.types.strMatching "[0-9]+x[0-9]+";
        description = "Resolution of the monitor, format [0-9]+x[0-9]+";
      };
      position = lib.mkOption {
        default = "1920x1200";
        type = lib.types.strMatching "[0-9]+x[0-9]+";
        description = "Positon of the monitor starting from the left, format [0-9]+x[0-9]+";
      };
      rate = lib.mkOption {
        default = "60";
        type = lib.types.strMatching "[0-9]{2,3}";
        description = "Refreshrate of the monitor, format ";
      };
      primary = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether the monitor is the primary monitor";
      };
    };
  };
in
{
  options.myHomeModules.desktopEnvironment = {

    select = lib.mkOption {
      default = osConfig.myModules.desktopEnvironment.select;
      type = lib.types.enum ((builtins.attrNames (subDirsIn ./.)) ++ [ null ]);
      description = ''
        Select the desktop environment that should be used.
      '';
    };
    monitors = lib.mkOption {
      default = osConfig.myModules.desktopEnvironment.monitors;
      type = lib.types.listOf monitorType;
    };
  };
  imports = lib.attrsets.mapAttrsToList (name: value: value) (subDirsIn ./.);
}
