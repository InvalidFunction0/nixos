self:
{
  mainUser,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) attrValues mkForce;
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
  services.displayManager.ly.enable = mkForce false;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.sddm.enable = false;

  #
  # Module config
  #

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

  virtualisation.docker.enable = true;

  console.keyMap = "uk";

  programs.zsh.enable = true;
  users.users."${mainUser}" = {
    isNormalUser = true;
    shell = mkForce pkgs.zsh;
  };

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.caskaydia-cove
      material-symbols
      material-icons
      fira
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "CaskaydiaCove NF" ];
      };
    };
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # nixpkgs.overlays = [ inputs.audio.overlays.default ];

  # for protonvpn
  networking.firewall.checkReversePath = false;

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  environment.systemPackages = with pkgs; [
    jdk25
    jre25_minimal
  ];

  programs.java.enable = true;
  programs.java.package = pkgs.jdk25;

  home-manager.users.${mainUser} = {
    programs.java.enable = true;
    programs.java.package = pkgs.jdk25;
  };

  networking.hostName = "server";

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
