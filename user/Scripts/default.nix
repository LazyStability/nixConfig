{pkgs, ...}: let
  univpn = pkgs.callPackage ./univpn.nix {
    entryname = "Unizugang";
    database = "/data/Dokumente/Software/Keepass/Uni.kdbx";
    Host = "vpn-ac.urz.uni-heidelberg.de";
    User = "qf226@split.uni-heidelberg.de";
    Useragent = "AnyConnect-compatible OpenConnect VPN Agent";
    vpnname = "uni";
  };
  quickcapture = pkgs.callPackage ./quickcapture.nix {};
in {
  home.packages = [
    univpn
    quickcapture
  ];
}
