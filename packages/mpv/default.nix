{
  mpv,
  mpv-unwrapped,
  mpvScripts,
}:
mpv.override {
  mpv-unwrapped = mpv-unwrapped.override {
    waylandSupport = true;
    sdl2Support = true;
  };
  scripts = with mpvScripts; [
    modernz
    mpris
    mpv-discord
    sponsorblock
  ];
}
