{ pkgs, ... }:
{
  imports = [
    ../../modules/homeManager/sys/swaync/swaync.nix
    ../../modules/homeManager/sys/wlogout/wlogout.nix
    ../../modules/homeManager/sys/hypr/hyprland.nix
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

  # set dark modes globally
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  swaync.enable = true;
}
