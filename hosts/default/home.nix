{ pkgs, ... }:
{
  imports = [
    ../../modules/homeManager/all.nix
    ../../modules/homeManager/linux.nix
  ];
}
