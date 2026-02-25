{
  rnote,
  fetchFromGitHub,
  rustPlatform,
}:
rnote.overrideAttrs (previousAttrs: rec {
  version = "unstable-2025-09-30";
  src = fetchFromGitHub {
    owner = "Doublonmousse";
    # branch = "workaround_gtk_pen_down";
    repo = previousAttrs.src.repo;
    rev = "5ab7d7d3f510ba6f27a596f04252cda24b4b6dd4";
    hash = "sha256-1XIJo8JA6vljZjBvMZ6/Q52EfGZtO58lBS2zUYvaSzQ=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (previousAttrs) pname;
    inherit version src; # These now refer to the new version and src
    hash = "sha256-fr1bDTzTKx7TLBqw94CyaB0/Jo2x1BzZcM6dcen1PHc=";
  };
})
