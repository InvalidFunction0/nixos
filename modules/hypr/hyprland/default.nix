self:
{
  mainUser,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.hypr.hyprland;
in
{
  options.hypr.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    home-manager.users.${mainUser}.wayland.windowManager.hyprland =
      let
        lua = lib.generators.mkLuaInline;
        mod = "SUPER";
      in
      {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;

        configType = "lua";

        settings = {
          bind =
            let
              bindf = key: action: flags: {
                _args = [
                  key
                  (lua action)
                  flags
                ];
              };
              bind = key: action: (bindf key action { });

              execf =
                key: command: flags:
                (bindf key "hl.dsp.exec_cmd(\"${command}\")" flags);
              exec = key: command: (execf key command { });
            in
            [
              (exec "SUPER + X" "ghostty")
              (exec "SUPER + B" "zen-twilight")
              (exec "SUPER + E" "nautilus")
              (exec "SUPER + R" "~/.config/rofi/launchers/type-1/launcher.sh")
              (exec "ALT + SPACE" "vicinae toggle")
              (exec "SUPER + ESCAPE" "wlogout")

              (bind "SUPER + Q" "hl.dsp.window.close()")
              (bind "SUPER + F" "hl.dsp.window.fullscreen()")
              (bind "SUPER + SPACE" "hl.dsp.window.float()")

              (exec "SUPER + HOME" "hyprshot --freeze -m region -o ~/screenshots/")

              (bindf "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
              (bindf "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })

              (bind "SUPER + SHIFT + S" "hl.dsp.window.move({ workspace = \"special:switch\" })")
              (bind "SUPER + S" "hl.dsp.workspace.toggle_special(\"switch\")")

              (execf "XF86AudioPlay" "playerctl -i chromium play-pause" { locked = true; })
              (execf "XF86AudioNext" "playerctl next" { locked = true; })
              (execf "XF86AudioPrev" "playerctl previous" { locked = true; })
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  mod = a: b: a - (b * (a / b));
                  ws = i + 1;
                  key = mod (i + 1) 10; # so 0 maps to ws 10
                in
                [
                  (bind "SUPER + ${toString key}" "hl.dsp.focus({ workspace = ${toString ws} })")
                  (bind "SUPER + SHIFT + ${toString key}" "hl.dsp.window.move({ workspace = ${toString ws} })")
                ]
              ) 10 # 0..9
            ));

          monitor =
            let
              monitor = output: mode: position: {
                _args = [
                  {
                    output = output;
                    mode = mode;
                    position = position;
                  }
                ];
              };
            in
            [
              (monitor "HDMI-A-1" "1920x1080@60" "0x0")
              (monitor "DP-1" "1920x1080@60" "1920x0")
            ];

          config = {
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
            };

            general = {
              gaps_in = 10;
              gaps_out = 10;
              border_size = 3;
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

            dwindle = {
              preserve_split = true;

              special_scale_factor = 0.75;
            };
          };

          window_rule =
            let
              rule = name: matches: effects: {
                _args = [
                  (
                    {
                      name = name;
                      match = matches;
                    }
                    // effects
                  )
                ];
              };
            in
            [
              (rule "zen-full-opacity" { class = "zen.*"; } { opacity = "1.0 override 1.0 override"; })
              (rule "zen-ws" { class = "zen.*"; } { workspace = "2"; })
              (rule "vesktop-ws" { class = "vesktop"; } { workspace = "3"; })
              (rule "steam-ws" { class = "steam"; } { workspace = "4"; })

              (rule "fix-xwayland-drags" {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              } { no_initial_focus = true; })
            ];

          layer_rule =
            let
              rule = name: matches: effects: {
                _args = [
                  (
                    {
                      name = name;
                      match = matches;
                    }
                    // effects
                  )
                ];
              };
            in
            [
              (rule "wlogout-noblur" { namespace = "logout_dialog"; } { blur = false; })
            ];

          on = {
            _args = [
              "hyprland.start"
              (lua ''
                function ()
                  hl.exec_cmd("hyprpaper")
                  hl.exec_cmd("quickshell")
                  hl.exec_cmd("vicinae server")
                  hl.exec_cmd("vesktop")
                  hl.exec_cmd("steam")
                  hl.exec_cmd("zen-twilight")
                end
              '')
            ];
          };

          workspace_rule =
            let
              rule = ws: effects: { _args = [ ({ workspace = toString ws; } // effects) ]; };
            in
            [
              (rule "2" { monitor = "HDMI-A-1"; })
              (rule "3" { monitor = "HDMI-A-1"; })
              (rule "4" { monitor = "HDMI-A-1"; })
              (rule "5" { monitor = "HDMI-A-1"; })
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
        };
      };
  };
}
