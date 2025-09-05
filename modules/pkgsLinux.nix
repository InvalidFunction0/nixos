{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swww hyprpaper hyprlock hyprshot hyprshade pavucontrol albert catppuccin-cursors.macchiatoSapphire
    openrgb-with-all-plugins
    ( waybar.overrideAttrs
      (oldAttrs: {
         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    ) wlogout wl-clipboard

    # no build on macOS
    nautilus bitwarden krita bibata-cursors ghostty notion

    # gaming
    inputs.nix-citizen.packages.${system}.star-citizen
    winetricks

    virt-manager
    virt-viewer
    spice spice-gtk
    spice-protocol
    win-virtio win-spice
    gnome.adwaita-icon-theme
  ];
}
