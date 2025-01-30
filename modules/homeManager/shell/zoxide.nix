{ inputs, lib, config, ... }:

with lib;

{
  options = {
    zoxide.enable = mkEnableOption "enable zoxide module";
    zoxide.replacecd = mkEnableOption "enable `cd` being aliased to `z`";
  };
  
  config = mkIf config.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        ( mkIf config.zoxide.replacecd "--cmd cd" )
      ];
    };
  };
}