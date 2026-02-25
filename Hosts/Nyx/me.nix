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
    dataLinks.enable = false;
    desktopEnvironment.powerSavingMode.enable = true;
  };
  programs.firefox.enable = true;
}
