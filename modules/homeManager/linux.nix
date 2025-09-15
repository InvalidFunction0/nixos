{ pkgs, ... }:
{
  imports = [
    ../../modules/homeManager/sys/swaync.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Afterglow-Recolored-Dracula-Purple";
    package = pkgs.afterglow-cursors-recolored;
    size = 32;
    hyprcursor = {
      enable = true;
      size = 32;
    };
  };

  swaync.enable = true;
}
