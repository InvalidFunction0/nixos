self:
{
  mainUser,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) attrValues;

  zlEq = pkgs.callPackage ./pkgs/zlEqualizer.nix { };
in
{
  imports = [
    self.configs.base
    ./hardware-configuration.nix

    ../../hosts/linux/configuration.nix

    self.modules.niri
  ];

  # state version
  # DO NOT CHANGE
  system.stateVersion = "24.05";

  # base config
  configs.base.enable = true;

  #
  # Module config
  #

  # swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 48 * 1024; # 48GB, my RAM size
    }
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  fileSystems."/mnt/music" = {
    device = "/dev/disk/by-label/music";
    fsType = "exfat";
    options = [
      "nofail"
      "rw"
      "user"
    ];
  };

  # nixpkgs.overlays = [ inputs.audio.overlays.default ];

  # for protonvpn
  networking.firewall.checkReversePath = false;

  environment.systemPackages =
    with pkgs;
    [
      modrinth-app
      wineWowPackages.yabridge
      # (yabridge.override { wine = wineWowPackages.yabridge; })
      # (yabridgectl.override { wine = wineWowPackages.yabridge; })
      yabridge
      yabridgectl
      # wineWowPackages.staging
      # vital
      yazi
      playerctl
      dioxus-cli
      sqlite
      flutter
      devenv
      gamescope
      python314
      cabextract
      android-tools
      android-studio
      inputs.nix-citizen.packages.${system}.star-citizen-umu
      chromium
      pv
      rsync
      protonvpn-gui
      mumble
      typst
      ffmpeg
    ]
    ++ [
      zlEq
      inputs.vicinae.packages.${system}.default
    ]
    ++ (with inputs.audio.packages.${system}; [
      bitwig-studio6-latest
      # grainbow
      # paulxstretch
    ]);

  nixpkgs.config.android_sdk.accept_license = true;

  # yabridge config
  home-manager.users.${mainUser} = {
    xdg.configFile."yabridgectl/config.toml".text = ''
      plugin_dirs = [
        "/home/ayaan/winePlugins/drive_c/Program Files/Common Files/CLAP/",
        "/home/ayaan/winePlugins/drive_c/Program Files/Common Files/VST3/"
      ]
      vst2_location = 'centralized'
      no_verify = false
      blacklist = []
    '';

    home.sessionVariables = {
      ANDROID_HOME = "$HOME/Android/Sdk/";
    };

    home.sessionPath = [
      "$ANDROID_HOME/platform-tools"
      "$ANDROID_HOME/tools"
      "$ANDROID_HOME/tools/bin"
      "$ANDROID_HOME/emulator"
    ];
  };

  networking.hostName = "mainSystem";

  # audio
  musnix.enable = true;
  musnix.rtcqs.enable = true;
  # musnix.kernel.realtime = true;

  niri.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };
  };

  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings.default = [ "ghostty.desktop" ];

  _file = ./default.nix;
}
