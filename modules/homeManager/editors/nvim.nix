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

    highlight = {
      MacchiatoRed.fg = "#ed8796";
      MacchiatoMaroon.fg = "#ee99a0";
      MacchiatoPeach.fg = "#f5a87f";
      MacchiatoYellow.fg = "#eed49f";
      MacchiatoGreen.fg = "#a6da95";
      MacchiatoTeal.fg = "#8bd5ca";
      MacchiatoSky.fg = "#91d7e3";
      MacchiatoSapphire.fg = "#7dc4e4";
      MacchiatoBlue.fg = "#8aadf4";
      MacchiatoLavender.fg = "#b7bdf8";
    };

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
      luasnip.enable = true;
      treesitter.enable = true;
      web-devicons.enable = true;
      colorizer.enable = true;
      colorful-menu.enable = true;
      emmet.enable = true;

      bufferline = {
        enable = true;

        settings.options = {
          diagnostics.__raw = "nvim_lsp";
        };
      };

      cmp = {
        enable = true;

        autoEnableSources = true;
        settings.sources = [
          { name = "cmdline"; }
          { name = "nvim_lsp"; }
          { name = "treesitter"; }
        ];

        setings.mapping = {
          "<CR>" =
            "cmp.mapping(function(fallback)
              if cmp.visible() then
                if luasnip.expandable() then
                  luasnip.expand()
                else
                  cmp.confirm({
                    select = true,
                  })
                end
              else
                fallback()
              end
            end)";

          "<Tab>" =
            "cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { \"i\", \"s\" })";

          "<S-Tab>" =
            "cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { \"i\", \"s\" })";
        };
      };
      
      comment = {
        enable = true;

        settings.toggler = {
          block = "<leader>b/";
          line = "<leader>/";
        };
      };

      oil = {
        enable = true;

        settings = {
          default_file_explorer = true;

          keymaps = {
            "<leader>c" = "actions.open_cwd";
          };
        };
      };

      telescope = {
        enable = true;

        extensions = {
          fzf-native.enable = true;
          zoxide.enable = true;
        };
      };

      indent-blankline = {
        enable = true;
        autoLoad = true;

        settings = {
          scope.enabled = true;
          
          indent.highlight = [
            "MacchiatoRed"
            # "MacchiatoMaroon"
            "MacchiatoPeach"
            "MacchiatoYellow"
            "MacchiatoGreen"
            "MacchiatoTeal"
            # "MacchiatoSky"
            "MacchiatoSapphire"
            "MacchiatoBlue"
            "MacchiatoLavender"
          ];
        };
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

    keymaps = [
      {
        action = "<cmd>nohl<CR>";
        key = "<leader>h";
      }

      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>g";
      }

      {
        action = "<cmd>Oil<CR>";
        key = "<leader>e";
      }

      {
        action = "<cmd>bnext<CR>";
        key = "<M-k>";
      }
      {
        action = "<cmd>bprev<CR>";
        key = "<M-j>";
      }
    ];
  };
}
