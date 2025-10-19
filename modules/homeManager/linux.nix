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
  home.packages = with pkgs; [ adw-gtk3 ];

  gtk = {
    enable = true;
    # Theme = {
    #   name = "catppuccin-macchiato-blue-compact+default";
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = [ "blue" ];
    #     variant = "macchiato";
    #     size = "compact";
    #   };
    # };
  };

  swaync.enable = true;
}
