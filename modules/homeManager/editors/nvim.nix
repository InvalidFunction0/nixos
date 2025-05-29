{ inputs, pkgs, settings, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    colorschemes.catppuccin.settings = {
      flavour = "macchiato";
      transparent_background = true;

      integrations = {
	cmp = true;
	gitsigns = true;
	mini = {
	  enabled = true;
	  indentscope_color = "";
	};
	notify = false;
	nvimtree = true;
	treesitter = true;
      };

      styles = {
	comments = [ "italic" ];
	booleans = [ "bold" "italic" ];
	conditionals = [ "bold" ];
      };

      term_colors = true;
    };

    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };

    plugins = {
      treesitter.enable = true;
      telescope.enable = true;
      mini.enable = true;
      web-devicons.enable = true;
    };

    keymaps = [
      {
	mode = "n";
	key = "<leader>tf";
	options.silent = true;
	action = "<cmd>Telescope find_files<CR>";
      }
    ];

    globals.mapleader = "<space>";
  };
}
