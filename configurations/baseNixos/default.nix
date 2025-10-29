self:
{
  mainUser,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    attrValues
    ;

  cfg = config.configs.baseNixOS;
in
{
  options.configs.baseNixOS = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      package = pkgs.nh;

      # weekly nix-store cleanup
      clean = {
        enable = true;
        extraArgs = "--keep-since 10d";
      };
    };

    system.fsPackages = attrValues {
      inherit (pkgs)
        nfs-utils
        ntfs3g
        ;
    };

    users.users.${mainUser} = {
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "audio"
        "networkmanager"
        "libvirtd"
      ];
    };
  };
}
