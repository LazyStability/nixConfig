{
  pkgs,
  config,
  ...
}:
let
  script = pkgs.callPackage ./swaync-soundscript.nix { }; # Settings from here https://github.com/ArtemChandragupta/NixFlake/blob/55394763321e4ba3fc13167738103c387a306747/home-modules/hyprland/swaync/default.nix
in
{
  services.swaync = {
    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      scripts = {
        notification-script = {
          exec = "${script}/bin/swaync-soundscript";
        };
      };
      widgets = [
        "buttons-grid"
        "dnd"
        "title"
        "notifications"
        ## TODO: mpris errors out
        # "mpris"
      ];
      widget-config = {
        buttons-grid.actions = [
          {
            label = "󰐥";
            command = "systemctl poweroff";
          }
          {
            label = "󰑐";
            command = "systemctl reboot";
          }
          {
            label = "󰌿";
            # TODO: make this use a nix variable so we can change it here and in the hyprland config at the same time
            command = "loginctl terminate-user ${config.home.username}";
          }
        ];
        dnd = {
          text = "Do not disturb";
        };

        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "󰆴";
        };
      };
    };
  };
}
