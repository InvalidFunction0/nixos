{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";

      # binds even when locked
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bind = [
        "$mod, X, exec, ghostty"
        "$mod, B, exec, zen"
        "$mod, E, exec, nautilus"
        "$mod, R, exec, ~/.config/rofi/launchers/type-1/launcher.sh"
        # "ALT, SPACE, exec, albert toggle"
        "ALT, SPACE, exec, vicinae toggle"
        "$mod, ESCAPE, exec, wlogout"

        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, SPACE, togglefloating"
        "$mod, G, togglegroup"
        "$mod, T, layoutmsg, togglesplit"

        "$mod, PRINT, exec, hyprshot --freeze -m region -o ~/screenshots"

        "$mod SHIFT, S, movetoworkspace, special"
        "$mod, S, togglespecialworkspace,"
      ]
      ++ (
        # bind $mod [shift] {1..9} to [move to] {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
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
        vfr = true;
      };

      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 5;
        "col.active_border" = "rgba(0384fcbb) rgba(03fcadbb) 45deg";
        "col.inactive_border" = "rgba(ff006fbb) rgba(ff4d1cbb) 45deg";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          noise = 0.25;
          new_optimizations = "on";
          xray = false;
        };
      };

      windowrulev2 = [
        "opacity 1.0 override 1.0 override, class:zen.*"

        "workspace 2, class:zen.*"
        "workspace 3, class:discord"
        "workspace 4, class:steam"

        # fix for Bitwig losing focus when changing values
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      layerrule = [
        # "blur, swaync-control-center"
        # "blur, swaync-notification-window"
        "blur, logout_dialog"
        "blur, class:swaync"
      ];

      exec-once = [
        "swaync"
        # "albert"
        "discord"
        "steam"
        "zen"
        "hypridle"
        "hyprsunset"
        "hyprpaper"
        "quickshell"
      ];

      exec = [
        "vicinae server"
      ];

      workspace = [
        "1, monitor:DP-3"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
      ];

      bezier = [
        "easeOQuart, 0.25, 1, 0.5, 1"
        "easeIOQuad, 0.45, 0, 0.55, 1"
      ];

      animation = [
        "windows, 1, 8, easeOQuart, popin 80%"
        "fadeIn, 1, 8, easeOQuart"
        "windowsOut, 1, 3, easeOQuart, popin 80%"
        "fadeOut, 1, 3, easeOQuart"
      ];

      dwindle = {
        preserve_split = true;
        pseudotile = true;

        special_scale_factor = 0.75;
      };
    };
  };
}
