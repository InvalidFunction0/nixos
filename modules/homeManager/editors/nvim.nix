{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.neovim = {
    enable = false;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
    ];
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2; # tab width = 2
      expandtab = true;

      tabstop = 8; # so tabs don't masquerade as spaces
      softtabstop = 0;
    };

    diagnostic.settings = {
      virtual_lines.current_line = true;
      virtual_text = true;
    };

    colorschemes.catppuccin = {
      enable = true;

      settings = {
        flavour = "macchiato";

	transparent_background = true;
      };
    };

    plugins = {
      lualine.enable = true;
      treesitter.enable = true;

      indent-blankline = {
        enable = true;
        autoLoad = true;
      };

      lsp = {
        enable = true;

        inlayHints = true;
        
        servers = {
          # js/ts
          ts_ls.enable = true;

          # lua
          lua_ls.enable = true;

          # rust
	  rust_analyzer = {
	    enable = true;
	    installCargo = true;
	    installRustc = true;
          };

	  # nix
	  nixd.enable = true;
	};
      };
    };

  };
}
