{ pkgs, ... }:
let armcord = pkgs.armcord.overrideAttrs (old:{
    version = "3.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "ArmCord";
      repo = "ArmCord";
      rev = "3.3.0";
      hash = "sha256-H/Y3xA7gE24UsUkrxmrRFSvs16qZCVxli9vdnt7ihi8=";
  };
    });
  in 
{
  home.packages = [
    armcord
  ];
}
