{ config, lib, ... }:
let
  subDirsIn =
    dir:
    builtins.mapAttrs (name: _: import (dir + "/${name}")) (
      lib.filterAttrs (name: type: type == "directory" && name != "desktopUtils") (builtins.readDir dir)
    );
in
{
  imports = lib.attrsets.mapAttrsToList (name: value: value) (subDirsIn ./.);
}
