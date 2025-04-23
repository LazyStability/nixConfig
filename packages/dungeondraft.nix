{
  stdenv,
  lib,
  autoPatchelfHook,
  dpkg,
  libXcursor,
  libXinerama,
  libXext,
  curl,
  jq,
  cacert,
  libXrandr,
  libXi,
  libGL,
  zlib,
  libkrb5,
  udev,
  runCommand,
  makeWrapper,
  zenity,
  purchaseKey,
}:
stdenv.mkDerivation rec {
  pname = "dungeondraft";
  version = "1.1.0.6";

  src =
    runCommand "${pname}-src.deb"
      {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-afo+3iJ19BsUSJ8fomGvjYL5kWFx4XzDCuiVTDGeGCQ=";
        nativeBuildInputs = [
          curl
          jq
        ];
        # Env Variables
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        CURL_CA_BUNDLE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        USERAGENT = builtins.concatStringsSep " " [
          "User-Agent: Mozilla/5.0 (X11; Linux ${stdenv.hostPlatform.linuxArch})"
          "AppleWebKit/537.36 (KHTML, like Gecko)"
          "Chrome/77.0.3865.75"
          "Safari/537.36"
        ];
      }
      ''
        TARGET_URL=$(curl \
          --compressed \
          --header 'Host: www.humblebundle.com' \
          --header 'Accept: application/json, text/plain, */*' \
          --header 'Origin: https://www.humblebundle.com' \
          --header 'Content-Type: application/json;charset=UTF-8' \
          --header "$USERAGENT" \
          --header "Accept-Language: en-US,en;q=0.9" \
          "https://www.humblebundle.com/api/v1/order/${purchaseKey}?wallet_data=true&all_tpkds=true" \
          | jq -r '.subproducts[].downloads[].download_struct[] | select(.name | contains(".deb")) | .url.web | select(. | contains("${version}"))')

        echo "$TARGET_URL"
        curl "$TARGET_URL" > $out
      '';

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  buildInputs = [
    libXcursor
    libXinerama
    libXext
    libXrandr
    libXi
    libGL
    zlib
    libkrb5
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/opt/Dungeondraft
    mv opt/Dungeondraft/* $out/opt/Dungeondraft

    # Can't use wrapProgram because godot seems to load data files based upon executable name
    makeWrapper $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/opt/Dungeondraft/Dungeondraft.x86_64.wrapped \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]} \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}

    mkdir -p $out/share/applications
    mv usr/share/applications/* $out/share/applications

    sed -i "s|Exec=/opt/Dungeondraft/Dungeondraft.x86_64|Exec=$out/opt/Dungeondraft/Dungeondraft.x86_64.wrapped|g" $out/share/applications/Dungeondraft.desktop
    sed -i "s|Path=/opt/Dungeondraft|Path=$out/opt/Dungeondraft|g" $out/share/applications/Dungeondraft.desktop
    sed -i "s|Icon=/opt/Dungeondraft/Dungeondraft.png|Icon=$out/opt/Dungeondraft/Dungeondraft.png|g" $out/share/applications/Dungeondraft.desktop
  '';
}
