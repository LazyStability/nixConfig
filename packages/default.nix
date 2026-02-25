{
  pkgs ? import <nixpkgs> { },
}:

let
  # Import the packages file
  packages = import ./packages.nix {
    inherit (pkgs) lib callPackage;
  };
in
packages
