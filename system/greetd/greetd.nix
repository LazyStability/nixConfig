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
    systemPackages = (with pkgs-unstable; [
      ags
      greetd.tuigreet
    ]);

    # Put the hyprland & ags files in /etc/greetd
    etc = {
      "greetd/hyprland.conf".source = ./hyprland.conf;
      "greetd/greeter.js".source = ./greeter.js;
    };
  };
  # Run tuigreet, TODO: Try ReGreet
    services.greetd = {
      enable = true;
      settings = {
	default_session = {
	  command = "${pkgs.greetd.tuigreet}/bin/tuigreet -d --r --user-menu --remember-session --time --cmd Hyprland";
	  user = "greeter";
	};
	# initial_session = {
	#   command = "Hyprland --config /etc/greetd/hyprland.conf";
	#   user = "me";
	# };
      };
    };
}
