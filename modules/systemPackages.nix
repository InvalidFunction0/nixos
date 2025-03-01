{ pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rustup
    vim neovim
    vscode
    # zed-editor
    zoxide
    lf cmatrix imagemagick htop btop cava
    discord
    nautilus
    rofi
    gradle gcc git gh
    ghostty
    bibata-cursors
    wget
    zsh oh-my-zsh zsh-completions zsh-powerlevel10k zsh-syntax-highlighting zsh-history-substring-search
    libnotify
    krita
    bitwarden
    neofetch
  ] ++
  (
    if pkgs.system == "x86_64-linux" then
      [
        swww hyprpaper hyprlock hyprshot pavucontrol albert catppuccin-cursors.macchiatoSapphire
        ( waybar.overrideAttrs
          (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          })
        ) wlogout wl-clipboard
      ]
    else [ ]
  );
}
