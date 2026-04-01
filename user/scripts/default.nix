{
  pkgs,
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
  full-univpn = pkgs.callPackage ./univpn.nix {
    entryname = "Unizugang";
    database = "/home/me/Dokumente/Software/Keepass/Uni.kdbx";
    Host = "vpn-ac.urz.uni-heidelberg.de";
    User = "qf226";
    Useragent = "AnyConnect-compatible OpenConnect VPN Agent";
    vpnname = "uni-full";
  };
  quickcapture = pkgs.callPackage ./quickcapture.nix {  };
  vim-anywhere = pkgs.callPackage ./vim-anywhere.nix {  };
  linkhandler = pkgs.callPackage ./linkhandler.nix {  };
  qndl = pkgs.callPackage ./qndl.nix { };
  rssget = pkgs.callPackage ./rssget.nix {  };
  android-webcam = pkgs.callPackage ./android-webcam.nix { };
  bookmark = pkgs.callPackage ./bookmark.nix {  };
  emoji-picker = pkgs.callPackage ./emoji-picker.nix {  };
in
{
  home = lib.mkMerge [
    {
      packages = [
        univpn
        full-univpn
        vim-anywhere
        quickcapture
        linkhandler
        qndl
        rssget
        android-webcam
        bookmark
        emoji-picker
      ];
    }
    { packages = (lib.mkIf osConfig.myModules.android-webcam.enable [ android-webcam ]); }
  ];
}
