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

    self.modules.zsh
    ../../hosts/linux/configuration.nix
  ];

  # state version
  # DO NOT CHANGE
  system.stateVersion = "24.05";

  # base config
  configs.base.enable = true;

  # module config

  shell.zsh.enable = true;
  shell.zsh.enableEzaAliases = true;

  nixpkgs.overlays = [
    (
      final: prev:
      let
        nixpkgs-wine94 =
          import
            (prev.fetchFromGithub {
              owner = "NixOS";
              repo = "nixpkgs";
              rev = "f60836eb3a850de917985029feaea7338f6fcb8a"; # wineWow64Packages 9.3 -> 9.4
              sha256 = "Ln3mD5t96hz5MoDwa8NxHFq76B+V2BOppYf1tnwFBIc=";
            })
            {
              system = "x86_64-linux";
            };
      in
      {
        inherit (nixpkgs-wine94) yabridge yabridgectl;
      }
    )
  ];

  # swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 48 * 1024; # 48GB, my RAM size
    }
  ];

  environment.systemPackages = with pkgs; [
    modrinth-app
    winePackages.yabridge
  ];

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
