{
  fetchFromGitHub,
  vencord,
  vesktop,
}:
let
  patched-vencord = vencord.overrideAttrs (old: {
    version = "unstable-2026-05-04";
    src = fetchFromGitHub {
      owner = old.src.owner;
      repo = old.src.repo;
      rev = "14508c1537611d2bb9567380dec21c82139a8434";
      hash = "sha256-OKUTvIv/7eidSdhxGVr2XNdrhBCokLCIvH9NunzFi1I=";
    };
  });
in
vesktop.override {
  withSystemVencord = true;
  vencord = patched-vencord;
}
