self:
{
  mainUser,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;

  cfg = config.shell.eza;
in
{
  options.shell.eza = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config.home-manager.users.${mainUser} = mkIf cfg.enable {
    imports = [ ./ezaTheme.nix ];
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "always";
    };
  };

  _file = ./default.nix;
}
