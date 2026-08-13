{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rage";
  version = "unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "rage";
    rev = "b5b68c4f4f7ea5c368bc060f6fe0237549c3a13f";
    hash = "sha256-CNYGypRocOTPj454fLOr0xGA2zFj54PKPEC6opGE9f4=";
  };

  cargoHash = "sha256-aNh7tMTSAqExRsqYGOanV0K56JmdF7+tx3rlh8Fc+WI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  # cargo test has an x86-only dependency
  doCheck = stdenv.hostPlatform.isx86;

  postInstall = ''
    installManPage target/*/release/manpages/man1/*
    installShellCompletion \
      --bash target/*/release/completions/*.bash \
      --fish target/*/release/completions/*.fish \
      --zsh target/*/release/completions/_*
  '';

  patches = [ ./0001-feat-Add-notifcation-after-2-seconds.patch ];
  meta = {
    description = "Simple, secure and modern encryption tool with small explicit keys, no config options, and UNIX-style composability";
    homepage = "https://github.com/str4d/rage";
    changelog = "https://github.com/str4d/rage/blob/v${finalAttrs.version}/rage/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ]; # either at your option
    maintainers = with lib.maintainers; [ ryantm ];
    mainProgram = "rage";
  };
})
