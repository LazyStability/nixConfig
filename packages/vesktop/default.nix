{
  fetchFromGitHub,
  vencord,
  vesktop,
}:
let
  patched-vencord = vencord.overrideAttrs (old: {
    version = "unstable-2026-02-08";
    src = fetchFromGitHub {
      owner = old.src.owner;
      repo = old.src.repo;
      rev = "50c5124e1cc95062a883c58fc2551b302bd5994f";
      hash = "sha256-1459x8G0++jH6NO5n4B5LVjDFjAFkLKFAQygVdqgOAk=";
    };
  });
in
vesktop.override {
  withSystemVencord = true;
  vencord = patched-vencord;
}
