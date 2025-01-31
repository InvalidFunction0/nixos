{ inputs, lib, config, ... }:

with lib;

{
  options = {
    zed = {
      enable = mkEnableOption "enable Zeditor";
      vim_mode.enable = mkEnableOption "enable Zed vim-mode";
      extensions = mkOption {
        type = types.listOf types.str;
        description = "List of extensions for Zed to install";
      };
    };
  };

  config = {
    programs.zed-editor = {
      enable = mkIf config.zed.enable true;
      extensions = config.zed.extensions;

      userSettings = {
        load_direnv = "shell_hook";

        vim_mode = mkIf config.zed.vim_mode.enable true;
        autosave = {
          after_delay = {
            milliseconds = 500;
          };
        };
        autoscroll_on_clicks = true;
        relative_line_numbers = true;
        # show_whitespaces = "all";
        hour_format = "hour24";

        font_family = "Cascadia Code";
        ui_font_size = 16;
        buffer_font_size = 16;

        theme = {
          mode = "dark";
          light = "One Light";
          dark = "Catppuccin Macchiato";
        };

        assistant = {
          enable = true;

          default_model = {
            provider = "zed.dev";
            model = "claude-3.5-sonnet-latest";
          };
        };
      };
    };
  };
}
