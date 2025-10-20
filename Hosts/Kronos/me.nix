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
    dataLinks.enable = true;
    gaming.screenRecording = {
      enable = true;
      shadowplay.enable = true;
    };
  };
  programs.yazi.enable = true;
  # programs.zen-browser.enable = true;
  programs.firefox.enable = true;
  # programs.floorp.enable = true;
}
