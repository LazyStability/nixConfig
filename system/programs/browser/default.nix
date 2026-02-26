{ lib, pkgs, ... }:
{
  programs = {
    firefox = (
      lib.mkMerge [
        {
          package = pkgs.firefox-esr;
        }
        (import ./firefox-wrapping.nix { inherit pkgs lib; })
      ]
    );
    firejail.wrappedBinaries = {
      firefox-esr = {
        executable = "${lib.getBin pkgs.firefox-esr}/bin/firefox-esr";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        desktop = "${pkgs.firefox-esr}/share/applications/firefox-esr.desktop";
      };
    };
  };
}
