{ pkgs, ... }:
{
  imports = [
    ../../modules/homeManager/all.nix
    ../../modules/homeManager/linux.nix
  ];

  home.packages = with pkgs; [
    unzip
    cabextract

    wine
  ];
}
