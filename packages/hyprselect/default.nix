{
  rustPlatform,
  lib,
  fetchFromGitHub,
  hyprland,
}:
rustPlatform.buildRustPackage (previousAttrs: {
  pname = "hyprselect";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "ZauJulio";
    repo = "hyprselect";
    rev = "v${previousAttrs.version}";
    hash = "sha256-zwb5vQ60bxIplZqztqcYWXx53d2Xb3nTaGvTJcUiX48=";
  };
  cargoHash = "sha256-0BT/jhug5uvtXuRBwrTcwoU3qvaECrpIkh9oBWFjovo=";
  runtimeInput = [ hyprland ];

  postInstall = ''
    install -Dm644 config/xdph.conf $out/share/hyprselect/xdph.conf
    install -Dm644 config/portals.conf $out/share/hyprselect/portals.conf
  '';

  meta = with lib; {
    description = "Lightweight TUI screen share picker for Hyprland";
    homepage = "https://github.com/ZauJulio/hyprselect";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "hyprselect";
  };
})
