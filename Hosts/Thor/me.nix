{
  ...
}:
{
  imports = [
    ../../user/home.nix

  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  programs.kitty.enable = true;
  programs.yazi.enable = true;
  # programs.zen-browser.enable = true;
  programs.floorp.enable = true;

  myHomeModules = {
    dataLinks.enable = false;
    gaming.screenRecording = {
      enable = false;
    };
  };
  # programs.zen-browser.enable = true;
  # programs.floorp.enable = true;
  programs.firefox.enable = true;
}
