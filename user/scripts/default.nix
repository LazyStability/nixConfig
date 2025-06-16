{
  pkgs,
  config,
  osConfig,
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
  quickcapture = pkgs.callPackage ./quickcapture.nix { };
  linkhandler = pkgs.callPackage ./linkhandler.nix { config = config; };
  qndl = pkgs.callPackage ./qndl.nix { };
  rssget = pkgs.callPackage ./rssget.nix { config = config; };
  windowswitcher = pkgs.callPackage ./window-quickswitcher.nix { config = config; };
  android-webcam = pkgs.callPackage ./android-webcam.nix { };
  bookmark = pkgs.callPackage ./bookmark.nix { config = config; };
  emoji-picker = pkgs.callPackage ./emoji-picker.nix { config = config; };
  move-workspace-to-monitor = pkgs.callPackage ./move-workpace-to-monitor.nix { config = config; };
in
{
  home = lib.mkMerge [
    {
      packages = [
        univpn
        quickcapture
        linkhandler
        qndl
        rssget
        android-webcam
        bookmark
        windowswitcher
        move-workspace-to-monitor
        emoji-picker
      ];
    }
    { packages = (lib.mkIf osConfig.myModules.android-webcam.enable [ android-webcam ]); }
  ];
}
