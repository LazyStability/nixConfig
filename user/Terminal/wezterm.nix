{pkgs, lib, ...}:
  let newWezterm =  pkgs.wezterm.overrideAttrs (old:{
    version = "git";
    });
  in {
    programs.wezterm.package = newWezterm;
  }
{
  home.packages = [pkgs.wezterm];
  # pkgs.wezterm.overrideAttrs {
  #   version = "git";
  # };
  programs.wezterm = {
	enable = true;
	enableZshIntegration = true;
	extraConfig = ''
	  return {
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
