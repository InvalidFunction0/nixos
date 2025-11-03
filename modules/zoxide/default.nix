self:
{
  mainUser,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;

  cfg = config.shell.zoxide;
in
{
  options.shell.zoxide = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    replacecd = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config.home-manager.users.${mainUser} = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        (mkIf cfg.replacecd "--cmd cd")
      ];
    };
  };
}
