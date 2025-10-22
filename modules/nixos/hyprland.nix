{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

{
  options = {
    hyprland.enable = lib.mkEnableOption "enable hyprland";
  };

  config = {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;

      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
