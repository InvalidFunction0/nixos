{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlock
    hyprshot
    hyprsunset
    albert
    rofi
    openrgb-with-all-plugins
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    wl-clipboard

    gnome-themes-extra
    kdePackages.qtdeclarative
    bottles
    wpsoffice
    onlyoffice-bin

    bitwig-studio
    vital

    obs-studio

    obsidian

    docker

    pwvucontrol
    pavucontrol
    alsa-firmware
    bluez
    bluez-tools
    bluez-alsa
    pamixer
    libcamera
    bluez5

    # no build on macOS
    nautilus
    bitwarden
    krita
    bibata-cursors
    ghostty
    notion
    figma-linux

    # gaming
    inputs.nix-citizen.packages.${system}.star-citizen
    winetricks

    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme

    quickshell

    inputs.zen-browser.packages."${system}".twilight

    teams-for-linux
    exfatprogs

    prettier
    prettierd
    stylua
    nixfmt-rfc-style
    rustfmt
    codespell

    jre21_minimal
    jre17_minimal
    jre8
  ];
}
