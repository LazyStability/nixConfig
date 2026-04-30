{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  gnupg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pass-secret-service";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "grimsteel";
    repo = "pass-secret-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cBDGxF1ETyszwHZJwN8n+lwKcpOU8Xt1XTOGbUHj9UI=";
  };

  cargoHash = "sha256-Ko8LlgPG6kl+pZ47jrFnKdc+9i7/eh9DMRtG2SWQGjQ=";

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace systemd/org.freedesktop.secrets.service \
      --replace-fail "/usr" "$out"
    substituteInPlace systemd/pass-secret-service.service \
      --replace-fail "/usr" "$out"
  '';

  postInstall = ''
    wrapProgram "$out/bin/pass-secret-service" \
      --prefix PATH : "${lib.makeBinPath [ gnupg ]}"

    mkdir -p "$out/share/dbus-1/services/" "$out/lib/systemd/user/"
    cp systemd/org.freedesktop.secrets.service "$out/share/dbus-1/services/"
    cp systemd/pass-secret-service.service "$out/lib/systemd/user/"
  '';

  meta = {
    description = "Implementation of org.freedesktop.secrets using `pass";
    homepage = "https://github.com/grimsteel/pass-secret-service";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ LazilyStableProton ];
    mainProgram = "pass-secret-service";
  };
})
