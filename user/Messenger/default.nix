{
  pkgs,
  config,
  ...
}: let
  # https://github.com/nix-community/home-manager/issues/3090#issuecomment-2010891733
  hm-file-copy-configfile = source: dest: {
    "/hm_initials/${dest}" = {
      text = builtins.toString source;
      onChange = ''
        rm -f ${config.xdg.configHome}/${dest}
        cp ${config.xdg.configHome}/hm_initials/${dest} {config.xdg.configHome}/${dest}
        chmod u+w ${config.xdg.configHome}/${dest}
      '';
    };
  };
in {
  home.packages = [pkgs.vesktop pkgs.element-desktop];
  stylix.targets.vesktop.enable = true;

  xdg.configFile."vesktop/hm_initial_settings.json" = {
    text = builtins.readFile ./vesktop/vesktop_settings.json;
    onChange = ''
      rm -f ${config.xdg.configHome}/vesktop/settings.json
      cp ${config.xdg.configHome}/vesktop/hm_initial_settings.json ${config.xdg.configHome}/vesktop/settings.json
      chmod u+w ${config.xdg.configHome}/vesktop/settings.json
    '';
  };
  xdg.configFile."vesktop/settings/hm_initial_settings.json" = {
    text = builtins.readFile ./vesktop/vencord_settings.json;
    onChange = ''
      rm -f ${config.xdg.configHome}/vesktop/settings/settings.json
      cp ${config.xdg.configHome}/vesktop/settings/hm_initial_settings.json ${config.xdg.configHome}/vesktop/settings/settings.json
      chmod u+w ${config.xdg.configHome}/vesktop/settings/settings.json
    '';
  };
  # xdg.configFile = builtins.listToAttrs [
  #   (hm-file-copy-configfile "./vesktop/vencord_settings.json" "vesktop/settings/settings.json")
  #   (hm-file-copy-configfile "./vesktop/vesktop_settings.json" "vesktop/settings.json")
  # ];
}
