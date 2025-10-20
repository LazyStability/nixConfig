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
  version = "unstable-2025-10-21";
  src = fetchFromGitHub {
    owner = "LazyStability";
    repo = "kitty-sessionizer";
    rev = "1df3edc32f26e80b1b80a0b8a18051c4aaea964e";
    sha256 = "sha256-4Pr1tOK4jlTkTtIY38VQUIugVgKPJQSi+TiZ3zTKHZo=";
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
