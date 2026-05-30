{ lib, pkgs, ... }:
{
  programs = {
    firefox = lib.mkMerge [
        {
          package = pkgs.firefox;
        }
        (import ./firefox-wrapping.nix { inherit pkgs lib; })
      ];
    firejail.wrappedBinaries = {
      firefox = {
        executable = "${lib.getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        desktop = "${pkgs.firefox}/share/applications/firefox.desktop";
      };
    };
  };
}
