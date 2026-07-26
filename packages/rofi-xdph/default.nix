{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  qt6,
  cmake,
  hyprutils,
  nix-update-script,
  rofi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-xdph";
  version = "unstable-2026-07-26";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "alba4k";
    repo = "rofi-xdph";
    # tag = finalAttrs.version;
    rev = "4fe5171aafdd54bf7326a7fe8525c7726c93910b";
    hash = "sha256-2pqqEeG+eZCjj2r47IjcdMzWasffX6zcmbI97BmlXTI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    cmake
  ];
  buildInputs = [
    hyprutils
    qt6.qtbase
  ];
  runtimeInput = [ rofi ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Use Rofi to pick what to share with XDPH";
    homepage = "https://github.com/alba4k/rofi-xdph";
    changelog = "https://github.com/alba4k/rofi-xdph/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rofi-xdph";
    platforms = lib.platforms.all;
  };
})
