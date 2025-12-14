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
      prefer-no-csd = true;

      input = {
        focus-follows-mouse.enable = true;
      };

      window-rules = [
        {
          geometry-corner-radius =
            let
              r = 10.0;
            in
            {
              top-left = r;
              top-right = r;
              bottom-right = r;
              bottom-left = r;
            };

          clip-to-geometry = true;
        }
      ];

      layout = {
        gaps = 10;

        focus-ring = {
          enable = true;
          width = 3;
          active.color = "#8aadf4";
          inactive.color = "#ed8796";
        };
      };

      spawn-at-startup = [
        { sh = "vicinae server"; }
        { sh = "quickshell"; }
      ];

      binds =
        with config.lib.niri.actions;
        let
          sh = spawn "sh" "-c";
        in
        {
          "Mod+Q".action = "close-window";
          "Mod+Q".repeat = false;

          "Mod+H".action = focus-column-left;
          "Mod+J".action = focus-column-down;
          "Mod+K".action = focus-column-up;
          "Mod+L".action = focus-column-right;

          "Mod+F".action = maximize-column;

          "Print".action.screenshot = [ ];

          "Mod+Escape".action.spawn = "wlogout";

          # Apps
          "Mod+X".action = spawn "ghostty";
          "Mod+B".action = spawn "zen";
          "Mod+E".action = spawn "nautilus";
          "Mod+R".action = sh "~/.config/rofi/launchers/type-1/launcher.sh";
          "Alt+Space".action = sh "vicinae toggle";
        };
    };
  };
}
