{
  ...
}:
{
  imports = [
    ../../user/home.nix

  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  programs.yazi.enable = true;
  # programs.zen-browser.enable = true;
  programs.floorp.enable = true;

  myHomeModules = {
    dataLinks.enable = false;
  };
  # programs.zen-browser.enable = true;
  # programs.floorp.enable = true;
  programs.firefox.enable = true;
}
