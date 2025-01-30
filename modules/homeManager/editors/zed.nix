{ inputs, lib, config, ... }:

with lib;

{`
  options = {
    zed = {
      enable = mkEnableOption "enable Zeditor";
      vim_mode.enable = mkEnableOption "enable Zed vim-mode";
      extensions = {
        type = set;
      }
    };
  };

  config = {
    programs.zed = {
      enable = mkIf config.zed.enable true;
      extensions = config.zed.extensions;
      load_direnv = "shell_hook";

      vim_mode = mkIf config.zed.vim_mode.enable true;
      show_whitespaces = "all";
      hour_format = "hour24";

      font_family = "Cascadia Code";
      ui_font_size = 16;
      buffer_font_size = 16;

      theme = {
        mode = "dark";
        dark = "Catppuccin Macchiato";
      };

      userSettings = {
        assistant = {
          enable = true;
          
          default_model = {
            provider = "zed.dev";
            model = "claude-3.5-sonnet-latest";
          };
        };
      };
    }
  };
}