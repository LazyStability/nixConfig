{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.ags ];
  home.file = {
    ".config/ags/config.js" = ./config.js;
    ".config/ags/applauncher.js" = ./applauncher.js;
  };
}
