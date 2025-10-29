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
  # inherit (self.inputs) home-manager;

  cfg = config.configs.base;
in
{
  imports = [
    (import ./packages self)
  ];

  options.configs.base = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # set the flake location for nh to use
    environment.variables.NH_FLAKE = mkDefault "/home/${mainUser}/nixos";

    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    time.timeZone = "Europe/London";

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

      # remote builds
      trusted-users = [
        "ayaan"
        "nixremote"
      ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = attrValues {
      switch = pkgs.writeShellApplication {
        name = "switch";

        # script to switch using the flake output of the device hostName
        text = ''
          exec nh os switch --hostname ${config.networking.hostName}
        '';
      };
    };

    users.users.${mainUser} = {
      shell = mkDefault pkgs.zsh;
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.${mainUser} = {
      imports = [
        {
          programs.zsh.shellAliases.nh = "env -u NH_FLAKE nh";
        }
      ];

      home.stateVersion = mkDefault config.system.stateVersion;
    };
  };

  _file = ./default.nix;
}
