self:
{
  mainUser,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # inherit (inputs) niri;
  inherit (lib) mkOption mkIf types;
  cfg = config.niri;
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.niri = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
      libsecret
      xwayland-satellite-unstable
    ];

    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;
    home-manager.users.${mainUser}.programs.niri.settings = {
      binds = {
        "Mod+X".action.spawn = "ghostty";
      };
    };
  };
}
