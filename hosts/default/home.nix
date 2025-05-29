{ pkgs, ... }:
{
  imports = [
    ../../modules/homeManager/all.nix
  ];
  # (
  #   if pkgs.system == "aarch64-darwin"
  #   then [ ]
  #   else [ ../../modules/homeManager/linux.nix ]
  # );
}
