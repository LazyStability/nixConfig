{ lib, callPackage }:

let
  # Get all directories that contain a default.nix
  packageDirs =
    let
      allItems = lib.readDir ./.;
      names = lib.attrNames allItems;
    in
    lib.filter (
      name:
      let
        # Correct way to construct path - use lib.path
        path = ./. + "/${name}";
        itemType = allItems.${name};
      in
      itemType == "directory" && lib.pathExists (path + "/default.nix")
    ) names;

  extraPackages = lib.genAttrs packageDirs (name: callPackage (./. + "/${name}") { });
in
extraPackages
