{ inputs, pkgs, settings, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
