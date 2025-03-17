{
  lib,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    # Use the ESR for more policies for example search engines
    package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped (
      import ../firefox-wrapping.nix {
        inherit pkgs lib;
        isZen = false;
      }
    );
    profiles = import ../firefox-profile.nix {
      inherit pkgs;
    };
  };
}
