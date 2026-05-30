{
  pkgs,
  extraPackages,
  config,
  lib,
  ...
}:
let
  linkhandler = pkgs.callPackage ./linkhandler.nix { inherit (extraPackages) sioyek; };
  qndl = pkgs.callPackage ./qndl.nix { };
  rssget = pkgs.callPackage ./rssget.nix { };
  android-webcam = pkgs.callPackage ./android-webcam.nix { };
  bookmark = pkgs.callPackage ./bookmark.nix { };
  emoji-picker = pkgs.callPackage ./emoji-picker.nix { };
in
{
  hjem.users.me = lib.mkMerge [
    {
      packages = [
        linkhandler
        qndl
        rssget
        # TODO: Get working with grapheneOS
        # android-webcam
        bookmark
        emoji-picker
      ];
    }
    { packages = lib.mkIf config.myModules.android-webcam.enable [ android-webcam ]; }
  ];
}
