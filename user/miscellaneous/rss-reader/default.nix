{ pkgs, ... }:
let
in
{
  home.packages = [
    pkgs.newsboat
  ];
}
