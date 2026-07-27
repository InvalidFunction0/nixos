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
    (import ./packages self)
    home-manager.nixosModules.home-manager

    self.modules.zsh
    self.modules.starship
    self.modules.nvim
    self.modules.tmux
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

    services.displayManager.gdm.enable = false;
    services.displayManager.ly.enable = true;

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

      substituters = [
        "https://cachix.cachix.org"
        "https://nixpkgs.cachix.org"
        "https://vicinae.cachix.org"
        "https://install.determinate.systems"
        "https://cache.nixos.org"
        "https://cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://nix-cache.tokidoki.dev/tokidoki"
      ];
      trusted-public-keys = [
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
      ];
    };

    nixpkgs.config.allowUnfree = true;

    #
    # Module config
    #

    shell.zsh.enable = true;
    shell.zsh.enableEzaAliases = true;
    shell.starship.enable = true;
    shell.tmux.enable = true;

    editors.nvim.enable = true;

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
        "adbusers"
      ];

      shell = mkDefault pkgs.zsh;
    };

    programs.git.enable = true;
    programs.git.config.user = {
      name = "InvalidFunction0";
      email = "ayaan.waqas@outlook.com";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.${mainUser} = {
      imports = [
        {
          programs.zsh.shellAliases.nh = "env -u NH_FLAKE nh";
        }
      ];

      home.stateVersion = mkDefault config.system.stateVersion;

      programs.home-manager.enable = true;
    };
  };

  _file = ./default.nix;
}
