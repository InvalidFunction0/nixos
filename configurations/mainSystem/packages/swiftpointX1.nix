{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {
  pname = "swiftpoint-x1-control-panel";
  version = "3.1.2.0"; # Adjust this to your specific version

  # Points to your downloaded local Linux tarball or extracted folder
  src = pkgs.fetchzip {
    url = "https://swiftpointdrivers.blob.core.windows.net/pro/beta/linux/Swiftpoint%20X1%20Control%20Panel%203.1.2.0-75bd9042.tar.xz";
    hash = "sha256-aOc8fXAeFWUytGhGjoTX9990/cfVKmOI/BkXN7jaMbg=";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    # wrapGAppsHook3 # Automatically wraps the binary for GTK graphic themes
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland

    udev
    gtk3
    glib
    nss
    nspr
    atk
    at-spi2-atk
    cups
    libdrm
    mesa
    expat
    libxkbcommon
    pango
    cairo
    alsa-lib
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxrender
    libxtst
  ];

  # # Feed the absolute Qt5 system library paths straight into
  # # auto-patchelf's internal scanner arguments before it runs the global patch sweep.
  # preFixup = ''
  #   autoPatchelfOptions+=(
  #     --libs "${pkgs.qt5.qtbase}/lib"
  #     --libs "${pkgs.qt5.qtsvg}/lib"
  #     --libs "${pkgs.qt5.qtwayland}/lib"
  #     --libs "${pkgs.qt5.qtx11extras}/lib"
  #   )
  # '';

  # Ignore internal, un-linkable window compositor private objects
  # appendAutoPatchelfIgnoreLibs = [
  #   "libQt5XcbQpa.so.5"
  #   "libQt6WaylandEglClientHwIntegration.so.6"
  # ];

  autoPatchelfIgnoreMissingDeps = true;

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "swiftpoint-x1-control-panel";
      exec = "swiftpoint-control-panel";
      icon = "preferences-desktop-peripherals";
      comment = "Control Panel for Swiftpoint mice";
      desktopName = "Swiftpoint X1";
      genericName = "Mouse Configuration Utility";
      categories = [
        "Settings"
        "HardwareSettings"
      ];
      terminal = false;
    })
  ];

  # # Disables source unpacking steps if 'src' points directly to a pre-extracted directory
  # dontUnpack = false;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Create the output binary destination folder
    mkdir -p $out/bin
    mkdir -p $out/share/swiftpoint

    # Copy all original unpacked assets to an isolated share directory
    cp -r * $out/share/swiftpoint/

    # make sure the udev rules folder exists
    mkdir -p $out/lib/udev/rules.d

    # AUTOMATIC RULE PROCESSING:
    # 1. Copies the actual file included in the tarball into the target NixOS directory path.
    # 2. Uses 'sed' to strip out administrative shell script paths inside comments to prevent Nix build blocks.
    sed -e 's|/bin/sh|${pkgs.bash}/bin/sh|g' \
        -e 's|/usr/bin/cat|${pkgs.coreutils}/bin/cat|g' \
        60-Swiftpoint.rules > $out/lib/udev/rules.d/60-swiftpoint.rules

    # CLEANUP: Remove the legacy Qt5 plugins that are crashing auto-patchelf.
    # These folders are redundant since the core app runs natively on Qt6.
    rm -rf $out/share/swiftpoint/plugins/bearer
    rm -rf $out/share/swiftpoint/plugins/platforminputcontexts
    rm -rf $out/share/swiftpoint/plugins/iconengines
    rm -rf $out/share/swiftpoint/plugins/imageformats
    rm -rf $out/share/swiftpoint/plugins/xcbglintegrations

    # # delete the remaining symlinks
    # find $out/share/swiftpoint -type l ! -exec test -e {} \; -delete

    # Symlink or copy the main executable into the binary directory
    # Replace 'ControlPanel' with the actual binary file name inside the tarball
    ln -s "$out/share/swiftpoint/Swiftpoint X1 Control Panel" $out/bin/swiftpoint-control-panel

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Control Panel configuration utility for Swiftpoint Mice";
    homepage = "https://swiftpoint.com";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
