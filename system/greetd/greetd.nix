# The result of this is the following Folder structure
# /etc/greetd
# ├── greeter.js -> /etc/static/greetd/greeter.js
# └── hyprland.conf -> /etc/static/greetd/hyprland.conf
# I dont know atm where nix throws the greetd.toml but for other systems you should put it in this directory as well
# The hyprlinks are nix stuff and also not needed if you happen to run another distro
{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Enable hyprland & add ags to systempkgs, if not done so already
  # programs.hyprland.enable = lib.mkForce true;
  environment = {
    systemPackages = with pkgs; [
      # ags
      tuigreet
    ];

    # Put the hyprland & ags files in /etc/greetd
    # etc = {
    #   "greetd/hyprland.conf".source = ./hyprland.conf;
    #   "greetd/greeter.js".source = ./greeter.js;
    # };
  };
  # Run tuigreet, TODO: Try ReGreet
  services.greetd = {
    enable = lib.mkDefault false;
    settings = {
      default_session = (
        lib.mkMerge [
          (lib.mkIf (!config.programs.uwsm.enable) {
            command = "${pkgs.tuigreet}/bin/tuigreet -d --r --user-menu --time -cmd Hyprland";
          })

          (lib.mkIf config.programs.uwsm.enable {
            command = "${pkgs.tuigreet}/bin/tuigreet -d --r --user-menu --time --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
          })
          {
            user = "greeter";
          }
        ]
      );
      # initial_session = {
      #   command = "Hyprland --config /etc/greetd/hyprland.conf";
      #   user = "me";
      # };
    };
  };
}
