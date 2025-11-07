self:
{
  mainUser,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) attrValues;
in
{
  imports = [
    self.configs.base

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

  environment.systemPackages = with pkgs; [
    modrinth-app
    wineWowPackages.yabridge
    yabridge
    yabridgectl
  ];

  networking.hostName = "mainSystem";

  # audio
  musnix.enable = true;
  musnix.rtcqs.enable = true;
  musnix.kernel.realtime = true;

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

  _file = ./default.nix;
}
