{ config, lib, pkgs, pkgs-stable, input, ...}:
{
	home.packages = [pkgs.ags];
	home.file = {
		".config/ags/config.js" = ./config.js;
		".config/ags/applauncher.js" = ./applauncher.js;

	};
}
