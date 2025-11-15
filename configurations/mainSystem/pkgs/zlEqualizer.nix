{
  lib,
  stdenv,
  pkgs,

  # build inputs
  unzip,
  makeWrapper,
  alsa-lib,
  freetype,
  fontconfig,
  ...
}:
let
  inherit (pkgs) requireFile;
in
stdenv.mkDerivation rec {
  pname = "zlEqualizer";
  version = "2-1.0.2";
  src = requireFile {
    message = "run nix-store add-file ZL.Equalizer.2-1.0.2-Linux-x86.zip";
    name = "ZL.Equalizer.2-1.0.2-Linux-x86.zip";
    sha256 = "e737d86a7c72235225bcdbcb6ae0d0251665c9ff770da414fda0888ad289755b";
  };
  nativeBuildInputs = [
    unzip
    makeWrapper
  ];
  buildInputs = [
    alsa-lib
    freetype
    fontconfig
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/lib
    cp -r VST3/ $out/lib/vst3
  '';

  postFixup = ''
    for file in \
      "$out/lib/vst3/ZL Equalizer 2.vst3/Contents/x86_64-linux/ZL Equalizer 2.so"
    do
      patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" "$file"
    done
  '';
}
