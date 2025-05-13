{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.myModules.desktopEnvironment;
  subDirsIn =
    dir:
    builtins.mapAttrs (name: _: import (dir + "/${name}")) (
      lib.filterAttrs (name: type: type == "directory") (builtins.readDir dir)
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
  options.myModules.desktopEnvironment = {
    # Gets every non nix file, which hopefully are all directories
    select = lib.mkOption {
      default = null;
      type = lib.types.enum ((builtins.attrNames (subDirsIn ./.)) ++ [ null ]);
      description = ''
        Select the desktop environment that should be used.
      '';
    };
    monitors = lib.mkOption {
      default = [
        {
          name = "DP-2";
          enable = true;
          mode = "1920x1200";
          position = "1280x0";
          rate = "60";
          primary = true;
        }
        {
          name = "DP-1";
          enable = true;
          mode = "1280x1024";
          position = "0x0";
          rate = "60";
        }
      ];
      type = lib.types.listOf monitorType;
    };
  };
  imports = lib.attrsets.mapAttrsToList (name: value: value) (subDirsIn ./.);
}
