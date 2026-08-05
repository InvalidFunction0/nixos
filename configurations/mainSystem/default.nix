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
in
{
  imports = [
    (import ./packages self)
    self.configs.base
    ./hardware-configuration.nix

    ../../hosts/linux/configuration.nix

    self.modules.niri
    self.modules.hypr.hyprland
  ];

  # state version
  # DO NOT CHANGE
  system.stateVersion = "24.05";

  # base config
  configs.base.enable = true;

  hypr.hyprland.enable = true;

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
      "user"
      "uid=1000"
      "gid=100"
    ];
  };

  # nixpkgs.overlays = [ inputs.audio.overlays.default ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.nix-gaming-edge.overlays.proton-cachyos
  ];

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;

  # for protonvpn
  networking.firewall.checkReversePath = false;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts =
    # Ark SE
    [ 27020 ]
    # bun dev
    ++ [ 5173 ];
  networking.firewall.allowedUDPPorts =
    # Ark SE
    [
      27015 # Steam server browser query
      7777 # Game client
      7778 # Raw UDP (always client + 1)
    ];

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  hardware.graphics.enable = true;

  qt.enable = true;

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "524288";
    }
    {
      domain = "root";
      item = "nofile";
      type = "-";
      value = "524288";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "-";
      value = "524288";
    }
  ];
  systemd.services."user@".serviceConfig.LimitNOFILE = "524288";
  systemd.settings.Manager = {
    DefaultLimitNOFILE = "8192:524288";
  };
  systemd.user.settings.Manager = {
    DefaultLimitNOFILE = "8192:524288";
  };
  boot.kernel.sysctl = {
    "fs.file-max" = 2097152;
    "fs.nr-open" = 1048567;
  };

  programs.nix-ld = {
    enable = true;
    # libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    libraries = with pkgs; [
      libxcursor
      libxrandr
      libxi
      libx11
      libxtst
      libxcb
      libglvnd
      glfw
    ];
  };

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo     ";
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

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

    qt.enable = true;
    programs.quickshell.enable = true;
    home.packages = [
      pkgs.kdePackages.qtdeclarative
    ];

    programs.prismlauncher = {
      enable = true;
    };

    #   programs.vesktop = {
    #     enable = true;
    #     #
    #     # vencord.settings = {
    #     #   autoUpdate = false;
    #     #   autoUpdateNotification = true;
    #     #   notifyAboutUpdates = true;
    #     # };
    #     #
    #     # plugins = {
    #     #   PinDMs.enabled = true;
    #     # };
    #   };
  };

  services.udev = {
    packages = with pkgs; [
      qmk
      qmk-udev-rules
      qmk_hid
      via
      vial
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
