self:
{
  mainUser,
  pkgs,
  ...
}:
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

  networking.hostName = "mainSystem";

  # audio
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
}
