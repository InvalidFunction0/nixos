self:
{
  mainUser,
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption mkIf types;

  cfg = config.editors.nvim;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  options.editors.nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${mainUser} = {
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

          conceallevel = 2;
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
          nvim-autopairs.enable = true;

          conform-nvim = {
            enable = true;
            settings = {
              formatters_by_ft = {
                lua = [ "stylua" ];
                # python = [ "isort" "black" ];
                nix = [ "nixfmt" ];
                rust = [ "rustfmt" ];
                qml = [ "qmlformat" ];

                "*" = [ "codespell" ];
                "_" = [ "prettier" ];
              };
              default_format_opts = {
                stop_after_first = true;
                lsp_format = "fallback";
              };

              format_on_save = {
                timeout_ms = 250;
                lsp_format = "fallback";
              };
              format_after_save = {
                lsp_format = "fallback";
              };

              log_level = "warn";
              notify_on_error = false;
              notify_no_formatters = false;

              formatters = {
                prettier = {
                  command = lib.getExe pkgs.prettier;
                  prepend_args = [
                    "--print-width"
                    "80"
                    "--config-precedence"
                    "prefer-file"
                  ];
                };
                stylua.command = lib.getExe pkgs.stylua;
                nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
                rustfmt.command = lib.getExe pkgs.rustfmt;
                codespell.command = lib.getExe pkgs.codespell;
              };
            };
          };

          bufferline = {
            enable = true;

            settings.options = {
              diagnostics.__raw = "nvim_lsp";
            };
          };

          blink-cmp = {
            enable = true;
            setupLspCapabilities = true;
            settings = {
              keymap.preset = "super-tab";

              sources.min_keyword_length = 1;

              sources.providers.luasnip = {
                name = "LuaSnip";
                module = "blink.cmp.sources.luasnip";
                opts = {
                  snippets = {
                    preset = "luasnip";
                  };
                  sources = {
                    default = [
                      "lsp"
                      "path"
                      "snippets"
                      "buffer"
                    ];
                  };
                };
              };
            };
          };

          obsidian = {
            enable = lib.mkIf (pkgs.system != "aarch64-darwin") true;
            settings = {
              completion = {
                min_chars = 2;
                blink = true;
              };
              new_notes_location = "current_dir";
              workspaces = [
                {
                  name = "main";
                  path = "~/git/notes/Vault";
                }
                {
                  name = "test vault";
                  path = "~/git/notes/test vault";
                }
              ];
              legacy_commands = false;
            };
          };

          comment = {
            enable = true;

            settings.toggler = {
              block = "<leader>f/";
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

              # emmet
              emmet_language_server = {
                enable = true;
                settings.init_options = {
                  showSuggestionsAsSnippets = true;
                };
              };

              # rust
              rust_analyzer = {
                enable = true;
                installCargo = true;
                installRustc = true;
              };

              # nix
              nixd.enable = true;

              # qml
              # qmlls.enable = true;
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

          {
            mode = "v";
            # so that the selection remains
            action = ">gv";
            key = ">";
          }
          {
            mode = "v";
            action = "<gv";
            key = "<";
          }
        ];
      };
    };
  };

  _file = ./default.nix;
}
