{
  fetchFromGitHub,
  vencord,
  vesktop,
  fetchPnpmDeps,
  pnpm_11,
}:
let
  pnpm = pnpm_11;
  patched-vencord = vencord.overrideAttrs (previousAttr: rec {
    version = "unstable-2026-11-07";
    src = fetchFromGitHub {
      owner = previousAttr.src.owner;
      repo = previousAttr.src.repo;
      rev = "383409e6a6ec9008ee8a7496500f1e75f17824d1";
      hash = "sha256-aUJubLJpyLAZWiOezqFxPY6oVPgWVPQpajFqrJvrO9U=";
    };
    pnpmDeps = fetchPnpmDeps {
      inherit (previousAttr)
        pname
        ;
      inherit pnpm src;
      fetcherVersion = 4;
      hash = "sha256-HS8uZNepvDefjrsG3buVLFCVv7sHvazcwdpcT3EQ/78=";
    };
    patches = [ ];
    postPatch = "";
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
