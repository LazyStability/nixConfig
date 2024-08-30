# The result of this is the following Folder structure
# /etc/greetd
# ├── greeter.js -> /etc/static/greetd/greeter.js
# └── hyprland.conf -> /etc/static/greetd/hyprland.conf

# I dont know atm where nix throws the greetd.toml but for other systems you should put it in this directory as well
# The hyprlinks are nix stuff and also not needed if you happen to run another distro
{config, lib, pkgs, pkgs-unstable, ...}:
{
  # Enable hyprland & add ags to systempkgs, if not done so already
  programs.hyprland.enable = lib.mkForce true;
  environment = {
    systemPackages = (with pkgs-unstable; [ags]);

    # Put the hyprland & ags files in /etc/greetd
    etc = {
      "greetd/hyprland.conf".source = ./hyprland.conf;
      "greetd/greeter.js".source = ./greeter.js;
    };
  };
  # Configure greetd to launch hyprland conf which then runs ags, taken from the example config on AGS wiki
    services.greetd = {
      enable = true;
      settings = {
	default_session = {
	  command = "Hyprland --config /etc/greetd/hyprland.conf";
	};
      };
    };
}
