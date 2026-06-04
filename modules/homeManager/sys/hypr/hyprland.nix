{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;

    # configType = "lua";

    settings = {
      # "$mod" = "SUPER";

      # binds even when locked
      bindl = [
        ", XF86AudioPlay, exec, playerctl -i chromium play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bind = [
        "SUPER, X, exec, ghostty"
        "SUPER, B, exec, zen-twilight"
        "SUPER, E, exec, nautilus"
        "SUPER, R, exec, ~/.config/rofi/launchers/type-1/launcher.sh"
        # "ALT, SPACE, exec, albert toggle"
        "ALT, SPACE, exec, vicinae toggle"
        "SUPER, ESCAPE, exec, wlogout"

        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"
        "SUPER, SPACE, togglefloating"
        "SUPER, G, togglegroup"
        "SUPER, T, layoutmsg, togglesplit"

        "SUPER, PRINT, exec, hyprshot --freeze -m region -o ~/screenshots"
        "SUPER, HOME, exec, hyprshot --freeze -m region -o ~/screenshots"

        "SUPER SHIFT, S, movetoworkspace, special"
        "SUPER, S, togglespecialworkspace,"
      ]
      ++ (
        # bind `SUPER shift {1..9}` to `move to {1..9}`
        builtins.concatLists (
          builtins.genList (
            i:
            let
              workspace = i + 1;
            in
            [
              "SUPER, code:1${toString i}, workspace, ${toString workspace}"
              "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString workspace}"
            ]
          ) 9
        )
      );

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      monitor = [
        "HDMI-A-1, 1920x1080@60, 0x0,    1"
        "DP-3,     1920x1080@60, 1920x0, 1"
      ];

      input = {
        kb_layout = "gb";
        numlock_by_default = true;
        follow_mouse = 1;
        sensitivity = -0.12;
        accel_profile = "flat";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        # vfr = true;
      };

      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 3;
        # "col.active_border" = "rgba(0384fcbb) rgba(03fcadbb) 45deg";
        # "col.inactive_border" = "rgba(ff006fbb) rgba(ff4d1cbb) 45deg";
        "col.active_border" = "rgb(8aadf4)";
        "col.inactive_border" = "rgb(ed8796)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;
        shadow.enabled = false;

        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          noise = 0.25;
          new_optimizations = true;
          xray = false;
          vibrancy = 0.3;
        };
      };

      windowrule = [
        "opacity 1.0 override 1.0 override, match:class zen.*"

        "workspace 2, match:class zen.*"
        "workspace 3, match:class vesktop"
        "workspace 4, match:class steam"

        # "no_blur 1, match:class quickshell"

        # fix for Bitwig losing focus when changing values
        "no_initial_focus 1,match:class ^$,match:title ^$,match:xwayland 1,match:float 1,match:fullscreen 0,match:pin 0"
      ];

      layerrule = [
        "match:namespace logout_dialog, blur off"
        "match:namespace swaync.*, blur off"
      ];

      exec-once = [
        "swaync"
        # "albert"
        "vesktop"
        "steam"
        "zen-twilight"
        "hypridle"
        "hyprsunset"
        "hyprpaper"
        "quickshell"
        "vicinae server"
      ];

      workspace = [
        "1, monitor:DP-3"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
      ];

      # bezier = [
      #   "easeOQuart, 0.25, 1, 0.5, 1"
      #   "easeIOQuad, 0.45, 0, 0.55, 1"
      # ];
      #
      # animation = [
      #   "windows, 1, 8, easeOQuart, popin 80%"
      #   "fadeIn, 1, 8, easeOQuart"
      #   "windowsOut, 1, 3, easeOQuart, popin 80%"
      #   "fadeOut, 1, 3, easeOQuart"
      # ];

      dwindle = {
        preserve_split = true;
        # pseudotile = true;

        special_scale_factor = 0.75;
      };
    };
  };
}
