{
  rustPlatform,
  fetchFromSourcehut,
}:
rustPlatform.buildRustPackage (_finalAttrs: {

  pname = "filter-youtube-shorts";
  version = "0.0.1";

  src = fetchFromSourcehut {

    owner = "~naglis";
    repo = "nbytf";
    rev = "0f487e954c778151d243e91cc1e13e25b40dd4b8";
    hash = "sha256-WzKkcuQWmqNTz05DnChrHU4sMjRi/SC6mozgYEU1UUI";
  };

  cargoHash = "sha256-6mEXGo1awQKL5QnIAu7s4Zy43sKNLhU0U4y1O3uhGGg";
})
