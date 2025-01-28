{ inputs, lib, config, ... }:

{
  options = {
    zsh.enable = lib.mkEnableOption "enables zsh module";
  };
  
  config = {
    programs.zsh = {
      enable =
        lib.mkIf config.zsh.enable true;
      
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
        '';
      
      shellAliases = {
        ll = "ls -alF";
        ls = "ls --color";
        cl = "clear";
        vim = "nvim";
        
      };
      
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "fzf"
        ];
        theme = "awesomepanda";
        
        extraConfig = 
          ''
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
            zstyle ':completion:*' menu no
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
            zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
          '';
      };
    };
  };
}