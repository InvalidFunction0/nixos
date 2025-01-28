{ inputs, lib, config, pkgs, ... }:

{
  options = {
    zoxide.enable = lib.mkEnableOption "enable zoxide module";
    zoxide.replacecd = lib.mkEnableOption "enable `cd` being aliased to `z`";
  };
  
  config = lib.mkIf config.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        ( lib.mkIf config.zoxide.replacecd "--cmd cd" )
      ];
    };
  };
}