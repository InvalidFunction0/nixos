{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rustup
    vim neovim
    vscode
    # zed-editor
    zoxide
    lf cmatrix imagemagick htop btop cava
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
  ];
}
