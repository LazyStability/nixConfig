{
  fetchFromGitHub,
  vencord,
  vesktop,
  fetchPnpmDeps,
  pnpm_10_29_2,
}:
let
  patched-vencord = vencord.overrideAttrs (previousAttr: {
    version = "unstable-2026-05-05";
    src = fetchFromGitHub {
      owner = previousAttr.src.owner;
      repo = previousAttr.src.repo;
      rev = "2fbe267499205d0854a1d0b7079f39db1d5dbc40";
      hash = "sha256-sx3CGdOxkm4O0eM5s3K6N+FClNG6f6Jup1r86w0SaT8=";
    };
  });
in
vesktop.override {
  withSystemVencord = true;
  vencord = patched-vencord;
}
# .overrideAttrs
#   (previousAttr: {
#     version = "unstable-2026-05-05";
#     src = fetchFromGitHub {
#       owner = previousAttr.src.owner;
#       repo = previousAttr.src.repo;
#       rev = "61ecf66936ed5069b661306781e396edf26b1e01";
#       hash = "sha256-pNBiH6TsyBiw+QAgBwGZO8f+bnth6bl5WGc7rt4QTcI=";
#     };
#     pnpmDeps = fetchPnpmDeps {
#       inherit (previousAttr)
#         pname
#         version
#         src
#         patches
#         ;
#       pnpm = pnpm_10_29_2;
#       fetcherVersion = 2;
#       hash = "sha256-o9dxtqXfCKTQpvNrbD/h0F3Hh39TEEA1qqYA9tN3j5I=";
#     };
#   })
