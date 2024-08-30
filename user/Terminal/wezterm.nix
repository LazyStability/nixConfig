{pkgs, lib, ...}:
#   let wezterm =  pkgs.wezterm.overrideAttrs (old:{
#     version = "main";
#     });
#   in 
# {
  # home.packages = [
  #   wezterm
  # ];
  programs.wezterm = {
	enable = true;
	package = inputs.wezterm.package.${pkgs.system}.default;
	enableZshIntegration = true;
	extraConfig = ''
	  return {
		enable_wayland = true,
		keys = {
		-- Search for (git) hashes
		{
			key = 'H',
			mods = 'SHIFT|CTRL',
			action = wezterm.action.Search { Regex = '[a-f0-9]{6,}'}
		}
		}
	  }
	'';
	};
}
