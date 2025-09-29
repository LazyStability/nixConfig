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
    rev = "bff958214fef6a171fdaf2766bbdc0f315d01c0b";
    sha256 = "sha256-Uf8rWl/gKWlh3fXejMthyxv7z2DyizwaFsIGpnDZ274=";
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
