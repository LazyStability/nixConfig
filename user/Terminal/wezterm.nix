{pkgs, lib, ...}:
{
  home.packages = [pkgs.wezterm];
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
			action = wezterm.action.Search ( Regex = '[a-f0-9]{6,}')
		}
		}
	  }
	'';
	};
}
