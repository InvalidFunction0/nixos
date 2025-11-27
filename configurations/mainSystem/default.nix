self:
{
  mainUser,
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

  environment.systemPackages =
    with pkgs;
    [
      modrinth-app
      wineWowPackages.yabridge
      (yabridge.override { wine = wineWowPackages.yabridge; })
      (yabridgectl.override { wine = wineWowPackages.yabridge; })
      vital
      yazi
      playerctl
      dioxus-cli

      sqlite
    ]
    ++ [
      # zlEq
    ];

  # yabridge config
  home-manager.users.${mainUser}.xdg.configFile."yabridgectl/config.toml".text = ''
    plugin_dirs = [
      "/home/ayaan/winePlugins/drive_c/Program Files/Common Files/CLAP/",
      "/home/ayaan/winePlugins/drive_c/Program Files/Common Files/VST3/"
    ]
    vst2_location = 'centralized'
    no_verify = false
    blacklist = []
  '';

  networking.hostName = "mainSystem";

  # audio
  # musnix.enable = true;
  musnix.rtcqs.enable = true;
  # musnix.kernel.realtime = true;

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
