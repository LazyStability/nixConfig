{
  symlinkJoin,
  sioyek,
  makeWrapper,
}:
symlinkJoin {
  name = "sioyek";
  paths = [ sioyek ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/sioyek \
      --set QT_QPA_PLATFORM xcb
  '';
}
