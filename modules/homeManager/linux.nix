{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-macchiato-sapphire-cursors";
    package = pkgs.catppuccin-cursors.macchiatoSapphire;
    size = 32;
    hyprcursor = {
      enable = true;
      size = 32;
    };
  };

  swaync.enable = true;
}
