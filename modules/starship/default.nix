self:
{
  mainUser,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    ;

  cfg = config.shell.starship;
in
{
  options.shell.starship = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Starship for prompt customisation";
    };
    tomlPath = mkOption {
      type = types.path;
      default = ./starship.toml;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${mainUser} = {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      home.file.".config/starship.toml".source = cfg.tomlPath;
    };
  };
}
