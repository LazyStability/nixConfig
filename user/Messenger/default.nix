{pkgs, ...}: {
  home.packages = [pkgs.vesktop pkgs.element-desktop];
  stylix.targets.vesktop.enable = true;

  xdg.configFile."vesktop/settings.json" = {
    text = builtins.readFile ./vesktop/vesktop_settings.json;
    force = true;
  };
  xdg.configFile."vesktop/settings/settings.json" = {
    text = builtins.readFile ./vesktop/vencord_settings.json;
    force = true;
  };
}
