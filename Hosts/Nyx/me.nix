{
  ...
}:
{
  imports = [
    ../../user/home.nix
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";
  myHomeModules = {
    desktopEnvironment.powerSavingMode.enable = true;
  };
  programs.firefox.enable = true;
}
