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
  inherit (inputs) nixvim;

  cfg = config.editors.nvim;
in
{
  options.editors.nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${mainUser} = {
      imports = [
        nixvim.homeModules.nixvim
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

          conceallevel = 2;

          scrolloff = 6;

          wrap = false;
        };

        diagnostic.settings = {
          virtual_lines.current_line = true;
          virtual_text = true;
        };

        colorschemes.catppuccin = {
          enable = true;

          settings = {
            flavour = "macchiato";
            transparent_background = lib.mkIf (pkgs.system != "aarch64-darwin") true;
          };
        };

        plugins = {
          #
          # mini
          #

          mini.enable = true;
          mini.modules = {
            comment = {
              mappings = {
                comment = "<leader>/";
                comment_line = "<leader>/";
                comment_visual = "<leader>/";
                textobject = "<leader>/";
              };
            };

            indentscope = {
              options = {
                border = "both";
                indent_at_cursor = true;
              };
              symbol = "╎";
            };

            pairs = {
              modes = {
                command = true;
                insert = true;
                terminal = false;
              };
            };

            surround = { };
          };

          #
          # cosmetic
          #

          colorful-menu.enable = true;
          web-devicons.enable = true;
          lualine.enable = true;

          colorizer.enable = true;
          colorizer.settings.user_default_options.names = false;

          #
          # unsorted as of yet
          #

          emmet.enable = true;
          typst-preview.enable = true;

          markview = {
            enable = true;
            settings = {
              typst.enable = false;
            };
          };

          luasnip = {
            enable = true;
            fromLua = [
              {
                paths = ./snippets;
              }
            ];
          };

          treesitter-textobjects.enable = true;
          treesitter = {
            enable = true;
            settings = {
              highlight.enable = true;
              incremental_selection.enable = true;
              indent.enable = true;
            };
          };

          rustaceanvim = {
            enable = true;
            settings = {
              server = {
                default_settings = {
                  rust-analyzer = {
                    check.command = "clippy";
                    inlayHints.lifetimeElisionHints.enable = "always";
                  };
                };
                standalone = false;
              };
            };
          };

          flutter-tools = {
            enable = true;

            settings = {
              decorations.statusline = {
                app_version = true;
                device = true;
              };
              lsp.color.enabled = true;
              widget_guides.enabled = true;
            };
          };

          conform-nvim = {
            enable = true;
            settings = {
              formatters_by_ft = {
                lua = [ "stylua" ];
                python = [ "ruff" ];
                nix = [ "nixfmt" ];
                rust = {
                  __unkeyed-1 = "dioxusfmt";
                  __unkeyed-2 = "rustfmt";
                  stop_after_first = false;
                };
                qml = [ "qmlformat" ];
                typst = [ "typstyle" ];

                "*" = [ "codespell" ];
                "_" = [ "prettier" ];
              };
              default_format_opts = {
                stop_after_first = true;
                lsp_format = "fallback";
              };

              format_on_save = {
                timeout_ms = 300;
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
                dioxusfmt = {
                  command = lib.getExe pkgs.dioxus-cli;
                  args = [
                    "fmt"
                    "-f"
                    "$FILENAME"
                  ];
                  stdin = false;
                };
                stylua.command = lib.getExe pkgs.stylua;
                nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
                rustfmt.command = lib.getExe pkgs.rustfmt;
                ruff.command = lib.getExe pkgs.ruff;
                codespell.command = lib.getExe pkgs.codespell;
                typstyle.command = lib.getExe pkgs.typstyle;
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

              sources.min_keyword_length = 2;

              # sources.providers.luasnip = {
              #   name = "LuaSnip";
              #   module = "blink.cmp.sources.luasnip";
              #   opts = {
              #     snippets = {
              #       preset = "luasnip";
              #     };
              #     sources = {
              #       default = [
              #         "lsp"
              #         "path"
              #         "snippets"
              #         "buffer"
              #       ];
              #     };
              #   };
              # };

              completion = {
                documentation.auto_show = true;
                documentation.auto_show_delay_ms = 300;
                documentation.treesitter_highlighting = false;
                documentation.window.border = "rounded";
                ghost_text.enabled = true;
                menu.border = "rounded";
                menu.draw.components.label.__raw = ''
                  {
                    text = function(ctx)
                        return require("colorful-menu").blink_components_text(ctx)
                    end,
                    highlight = function(ctx)
                        return require("colorful-menu").blink_components_highlight(ctx)
                    end,
                  }
                '';
              };
            };
          };

          obsidian = {
            # enable = lib.mkIf (pkgs.system != "aarch64-darwin") true;
            enable = true;
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

          oil = {
            enable = true;

            settings = {
              default_file_explorer = true;

              keymaps = {
                "<leader>c" = "actions.open_cwd";
              };

              view_options.show_hidden = true;
            };
          };

          telescope = {
            enable = true;

            extensions = {
              fzf-native.enable = true;
              zoxide.enable = true;
            };
          };

          lsp = {
            enable = true;

            inlayHints = true;

            servers = {
              # js/ts
              ts_ls.enable = true;

              # typst
              tinymist.enable = true;
              tinymist.settings.formatterMode = "typstyle";

              # lua
              lua_ls.enable = true;

              cssls.enable = true;

              # emmet
              emmet_language_server = {
                enable = true;
                settings.init_options = {
                  showSuggestionsAsSnippets = true;
                };
              };

              # nix
              nixd.enable = true;

              # markdown
              # marksman.enable = true;

              # python
              pyright.enable = true;

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
