{ pkgs, ... }:
{
  imports = [
    ../../modules/homeManager/sys/swaync/swaync.nix
    ../../modules/homeManager/sys/wlogout/wlogout.nix
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
