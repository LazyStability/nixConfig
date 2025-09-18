{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  fzf,
  coreutils,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "kitty-sessionizer";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "LazyStability";
    repo = "kitty-sessionizer";
    rev = "f04ea0bc7c690944180ad34c7c40f354527697fc";
    sha256 = "sha256-prg3kmL6sHNqMgV98GHZXhQOmFVSsDk4yAot0wHgonw=";
  };
  buildInputs = [
    bash
    coreutils
    fzf
  ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp kitty-sessionizer.sh $out/bin/kitty-sessionizer
    wrapProgram $out/bin/kitty-sessionizer \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          fzf
          coreutils
        ]
      }
  '';
}
