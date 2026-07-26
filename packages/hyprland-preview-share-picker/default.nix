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
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
    hash = "sha256-XE6RD/4Mhw/ZRBj0v94kLOERElat5V+e/X0L9eUGf7M=";
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
  cargoHash = "sha256-AqX9jKj7JLEx1SLefyaWYGbRdk0c3H/NDTIsZy6B6hY=";

  meta = {
    homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    license = lib.licenses.mit;
    maintainers = lib.maintainers.faukah;
  };
})
