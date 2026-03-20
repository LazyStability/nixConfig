{
  stdenv,
  lib,
  autoPatchelfHook,
  dpkg,
  libXcursor,
  libXinerama,
  libXext,
  libXrandr,
  libXi,
  libGL,
  zlib,
  libkrb5,
  udev,
  requireFile,
  makeWrapper,
  zenity,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dungeondraft";
  version = "1.2.0.1";

  src = requireFile {
    name = "Dungeondraft-${finalAttrs.version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    # hash = "sha256-ffT2zOQWKb6W6dQGuKbfejNCl6dondo4CB6JKTReVDs=";
    sha256 = "04gwxwnicfbz75rjrqn5yq63nci6yhqgzbf77h0ir4ji1l4x9ysj";
  };

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

    mkdir -p $out/src
    ln -s $src $out/src

    mkdir -p $out/share/applications
    mv usr/share/applications/* $out/share/applications

    sed -i "s|Exec=/opt/Dungeondraft/Dungeondraft.x86_64|Exec=$out/opt/Dungeondraft/Dungeondraft.x86_64.wrapped|g" $out/share/applications/Dungeondraft.desktop
    sed -i "s|Path=/opt/Dungeondraft|Path=$out/opt/Dungeondraft|g" $out/share/applications/Dungeondraft.desktop
    sed -i "s|Icon=/opt/Dungeondraft/Dungeondraft.png|Icon=$out/opt/Dungeondraft/Dungeondraft.png|g" $out/share/applications/Dungeondraft.desktop
  '';
})
