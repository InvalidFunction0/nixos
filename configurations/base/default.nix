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

    programs.nh = {
      enable = true;
      package = pkgs.nh;

      # weekly nix-store cleanup
      clean = {
        enable = true;
        extraArgs = "--keep-since 10d";
      };
    };

    environment.systemPackages = attrValues {
      switch = pkgs.writeShellApplication {
        name = "switch";

        # script to switch using the flake output of the device hostName
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

    users.users.${mainUser} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "audio"
        "networkmanager"
        "libvirtd"
      ];

      shell = mkDefault pkgs.zsh;
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.${mainUser} = {
      imports = [
        {
          programs.zsh.shellAliases.nh = "env -u NH_FLAKE nh";
        }
      ];

      home.stateVersion = config.system.stateVersion;
    };
  };
}
