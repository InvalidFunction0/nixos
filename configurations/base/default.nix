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
    attrValues
    mkDefault
    mkIf
    mkOption
    types
    ;
  inherit (self.inputs) home-manager;

  cfg = config.configs.base;
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.configs.base = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.variables.NH_FLAKE = mkDefault "/home/${mainUser}/nixos";

    nix.settings = {
      # store
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
      http-connections = 0;
      show-trace = true;

      trusted-users = [
        "ayaan"
        "nixremote"
      ];
    };

    programs.nh = {
      enable = true;
      package = pkgs.nh;

      clean = {
        enable = true;
        extraArgs = "--keep-since 10d";
      };
    };

    environment.systemPackages = attrValues {
      switch = pkgs.writeShellApplication {
        name = "switch";
        text = ''
          exec nh os switch --hostname ${config.networking.hostName}
        '';
      };
    };

    system.fsPackages = attrValues {
      inherit (pkgs)
        nfs-utils
        ntfs3g
        ;
    };
  };
}
