{ pkgs, ... }:
let
  shorts-filter = pkgs.callPackage ../../../packages/rss-filter/youtube-shorts-filter.nix { };
in
{
  home.packages = [
    pkgs.newsboat
    shorts-filter
  ];
}
