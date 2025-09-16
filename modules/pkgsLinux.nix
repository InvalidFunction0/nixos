{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    swww hyprpaper hyprlock hyprshot hyprsunset pavucontrol albert
    rofi
    openrgb-with-all-plugins
    ( waybar.overrideAttrs
      (oldAttrs: {
         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    ) wl-clipboard

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
    adwaita-icon-theme

    quickshell

    inputs.zen-browser.packages."${system}".twilight

    teams-for-linux
  ];
}
