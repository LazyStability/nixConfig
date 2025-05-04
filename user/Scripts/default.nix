{
  pkgs,
  config,
  userSettings,
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
  linkhandler = pkgs.callPackage ./linkhandler.nix { userSettings = userSettings; };
  qndl = pkgs.callPackage ./qndl.nix { };
  rssget = pkgs.callPackage ./rssget.nix { config = config; };
  windowswitcher = pkgs.callPackage ./window-quickswitcher.nix { config = config; };
in
{
  home.packages = [
    univpn
    quickcapture
    linkhandler
    qndl
    rssget
    windowswitcher
  ];
}
