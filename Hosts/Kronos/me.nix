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
  };
  # programs.zen-browser.enable = true;
  programs.firefox.enable = true;
  # programs.floorp.enable = true;
}
