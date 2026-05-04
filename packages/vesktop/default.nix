{
  fetchFromGitHub,
  vencord,
  vesktop,
}:
let
  patched-vencord = vencord.overrideAttrs (old: {
    version = "unstable-2026-03-25";
    src = fetchFromGitHub {
      owner = old.src.owner;
      repo = old.src.repo;
      rev = "cba0eb9897419432e68277b0b60c301a6f8323cf";
      hash = "sha256-Wl89sRv49os6uRuYQVB/LgsOD7Rz3DPoxqeeELyY/o4=";
    };
  });
in
vesktop.override {
  withSystemVencord = true;
  vencord = vencord;
}
