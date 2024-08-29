{pkgs, lib, ...}:
  let newWezterm =  pkgs.wezterm.overrideAttrs (old:{
    version = "main";
    });
  in 
{
  home.packages = [
    newWezterm 
    pkgs.wezterm
  ];
  programs.wezterm = {
	enable = true;
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
