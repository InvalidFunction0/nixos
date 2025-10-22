{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    swaync.enable = lib.mkEnableOption "enable swaync";
  };

  config = {
    services.swaync = {
      enable = lib.mkIf config.swaync.enable true;
      style = ./swaync-style.css;
    };
  };
}
