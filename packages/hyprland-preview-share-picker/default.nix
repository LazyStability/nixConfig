{
  lib,
  glib,
  gtk4,
  gtk4-layer-shell,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,

}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-preview-share-picker";

  version = "unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "WhySoBad";
    repo = "hyprland-preview-share-picker";
    rev = "90ee200c6876174e434fefa124a9ce9a721e01b1";
    hash = "sha256-C9GCiIYatCWHA1qwGir4o9bOJngQ4UWV8w52kOVhdWY=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    gtk4
    gtk4-layer-shell
  ];

  strictDeps = true;
  # cargoLock.lockFile = src/Cargo.lock;
  cargoHash = "sha256-4nd0X6Ii6pbpQgzFCw2yXhl2+C5FyqDsHtbzKNpGW5o=";

  meta = {
    homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    license = lib.licenses.mit;
    maintainers = lib.maintainers.faukah;
  };
})
