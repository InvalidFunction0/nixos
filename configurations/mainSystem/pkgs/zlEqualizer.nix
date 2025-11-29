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
  version = "2-1.0.3";
  src = requireFile {
    message = "run nix-store add-file ZL.Equalizer.2-1.0.3-Linux-x86.zip";
    name = "ZL.Equalizer.2-1.0.3-Linux-x86.zip";
    sha256 = "7de672a9193733e13bdcd72fe8e275ce762d42713fdf934ce927aaef14fe0b03";
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
