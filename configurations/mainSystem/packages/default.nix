self:
{ pkgs, inputs, ... }:
let
  zlEq = pkgs.callPackage ./zlEqualizer.nix { };
in
{
  environment.systemPackages =
    with pkgs;
    [
      modrinth-app
      yabridge
      yabridgectl
      wine64
      # vital
      yazi
      playerctl
      dioxus-cli
      sqlite
      flutter
      devenv
      gamescope
      (python314.withPackages (
        python-pkgs: with python-pkgs; [
          discordpy
        ]
      ))
      cabextract
      android-tools
      android-studio
      # (inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.star-citizen-umu.override {
      #   gameScopeEnable = true;
      #   gameScopeArgs = [
      #     "-W"
      #     "1920"
      #     "-H"
      #     "1080"
      #     "--force-grab-cursor"
      #   ];
      # })
      (inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.rsi-launcher-umu.override {
        gameScopeEnable = true;
        gameScopeArgs = [
          "-W"
          "1920"
          "-H"
          "1080"
          "--force-grab-cursor"
        ];
      })
      inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.lug-helper
      chromium
      pv
      rsync
      proton-vpn
      mumble
      typst
      ffmpeg
      cookiecutter
      gcc
      vlc
      r2modman
      qmk
      qmk-udev-rules
      qmk_hid
      via
      vial
      element-desktop
      element-call
      steamcmd
      docker-compose
      protontricks
      vesktop
      vital
      blender
      typstyle
      microsoft-edge
      gamemode
      qbittorrent
      plugdata
      qpwgraph
      libreoffice-fresh
      zellij
      imv
      cloudflared
      waywall
      mcrcon
      gamemode
      mangohud
      vintagestory
      dmenu
      vscode
      affine
      dos2unix
      meow
      lutris
      protonup-qt
      mprime
    ]
    ++ [
      zlEq
      inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default
      # inputs.hyprland-preview-share-picker.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
      # inputs.sone.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (with inputs.audio.packages.${pkgs.stdenv.hostPlatform.system}; [
      bitwig-studio6-latest
      # grainbow
      paulxstretch
    ]);
}
