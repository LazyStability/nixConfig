{ config, pkgs, pkgs-unstable, inputs, userSettings, ... }:
{
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
