self:
{
  mainUser,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (self.inputs) home-manager;
  inherit (lib) attrValues;
in
{
  imports = [
    self.configs.baseDarwin

    self.modules.zsh
    self.modules.starship
    self.modules.nvim

    home-manager.darwinModules.home-manager
  ];

  configs.baseDarwin.enable = true;

  shell.zsh.enable = true;
  shell.zsh.enableEzaAliases = true;
  shell.starship.enable = true;
  editors.nvim.enable = true;

  networking.hostName = "macbook";

  system.stateVersion = 6;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      gh
      bun
      ;

    switch = pkgs.writeShellApplication {
      name = "switch";

      # script to switch using the flake output of the device hostName
      text = ''
        exec NH_FLAKE=~/nixos nh darwin switch --hostname ${config.networking.hostName}
      '';
    };
  };

  users.users.${mainUser} = {
    home = "/Users/${mainUser}";
  };

  system.primaryUser = mainUser;

  home-manager.users.${mainUser} = {
    home = {
      stateVersion = "24.05";
      username = mainUser;
    };
  };

  _file = ./default.nix;
}
