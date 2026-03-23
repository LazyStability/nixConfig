{
  ...
}:
{
  imports = [
    ../../user/home.nix

  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  # programs.zen-browser.enable = true;
  programs.floorp.enable = true;

  myHomeModules = {
  };
  # programs.zen-browser.enable = true;
  # programs.floorp.enable = true;
  programs.firefox.enable = true;
}
