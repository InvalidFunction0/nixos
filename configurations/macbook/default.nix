self:
{
  mainUser,
  ...
}:
let
  inherit (self.inputs) home-manager;
in
{
  imports = [
    self.configs.baseDarwin

    home-manager.darwinModules.home-manager
  ];

  configs.baseDarwin.enable = true;

  networking.hostName = "macbook";

  system.stateVersion = 6;

  users.users.${mainUser} = {
    home = "/Users/${mainUser}";
  };

  system.primaryUser = mainUser;

  # home-manager.users.${mainUser} = {
  #   imports = [
  #     ../../modules/homeManager/all.nix
  #   ];

  #   home = {
  #     stateVersion = "24.05";
  #     username = mainUser;
  #   };
  # };

  home-manager.users.${mainUser} = import ../../modules/homeManager/all.nix;

  _file = ./default.nix;
}
