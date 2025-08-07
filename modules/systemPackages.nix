{ pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rustup
    vim neovim
    vscode
    # zed-editor
    zoxide
    lf cmatrix imagemagick htop btop cava nvtop
    discord
    rofi
    gradle gcc git gh
    wget
    zsh oh-my-zsh zsh-completions zsh-powerlevel10k zsh-syntax-highlighting zsh-history-substring-search
    libnotify
    neofetch
    unzip

    bun

    pciutils
  ] ++
  (
    if pkgs.system == "x86_64-linux" then
      [
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
      ]
    else [ ]
  );
}
