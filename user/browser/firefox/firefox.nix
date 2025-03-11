{
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    # Use the ESR for more policies for example search engines
    package =
      pkgs.wrapFirefox pkgs.firefox-esr-unwrapped
      (import ../firefox-wrapping.nix {
        lib = lib;
        pkgs = pkgs;
      });
    profiles = import ../firefox-profile.nix {pkgs = pkgs;};
  };
}
