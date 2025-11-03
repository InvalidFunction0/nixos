self:
{
  mainUser,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.shell.zsh;
in
{
  options.shell.zsh = {
    enable = mkEnableOption "enables zsh module";
    enableEzaAliases = mkEnableOption "enables Eza aliases for ls and ll";
  };

  config = mkIf cfg.enable {
    home-manager.users.${mainUser}.programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      envExtra =
        # --color=bg+:#363a4f,bg:#24273a \
        ''
          export FZF_DEFAULT_OPTS=" \
          --color=spinner:#f4dbd6,hl:#ed8796 \
          --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
          --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
          --color=selected-bg:#494d64 \
          --multi"

          export PATH="/Users/ayaanwaqas/.bun/bin/:$PATH"
        '';

      shellAliases = {
        cl = "clear";
      }
      // mkIf cfg.enableEzaAliases {
        ll = "eza -alF";
        ls = "eza --color";
      };
    };
  };
}
