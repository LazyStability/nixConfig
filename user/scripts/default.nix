{
  pkgs,
  config,
  lib,
  ...
}:
let
  univpn = pkgs.callPackage ./univpn.nix {
    entryname = "Unizugang";
    database = "/home/me/Dokumente/Software/Keepass/Uni.kdbx";
    Host = "vpn-ac.urz.uni-heidelberg.de";
    User = "qf226@split.uni-heidelberg.de";
    Useragent = "AnyConnect-compatible OpenConnect VPN Agent";
    vpnname = "uni";
  };
  full-univpn = pkgs.callPackage ./univpn.nix {
    entryname = "Unizugang";
    database = "/home/me/Dokumente/Software/Keepass/Uni.kdbx";
    Host = "vpn-ac.urz.uni-heidelberg.de";
    User = "qf226";
    Useragent = "AnyConnect-compatible OpenConnect VPN Agent";
    vpnname = "uni-full";
  };
  linkhandler = pkgs.callPackage ./linkhandler.nix { };
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
        univpn
        full-univpn
        linkhandler
        qndl
        rssget
        android-webcam
        bookmark
        emoji-picker
      ];
    }
    { packages = (lib.mkIf config.myModules.android-webcam.enable [ android-webcam ]); }
  ];
}
