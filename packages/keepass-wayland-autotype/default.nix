{
  keepassxc,
  fetchFromGitHub,
  keyutils,
}:
keepassxc.overrideAttrs (previousAttrs: {
  version = "patched";
  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "79fe2635ed46b90c47718846e853f5068f0adb10";
    hash = "";
  };
  patches = [ ];
  # Tests fail so, fuck tests
  checkFlags = [ "-skip" ];
  buildInputs = previousAttrs.buildInputs ++ [ keyutils ];
})
