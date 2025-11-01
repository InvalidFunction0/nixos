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
    wl-clipboard

    gnome-themes-extra
    kdePackages.qtdeclarative
    bottles
    wpsoffice
    onlyoffice-desktopeditors

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
    bitwarden-desktop
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
    virtio-win
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
