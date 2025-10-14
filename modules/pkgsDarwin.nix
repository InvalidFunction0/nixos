{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    rustup
    vscode
    zoxide
    lf
    cmatrix
    imagemagick
    htop
    btop
    cava
    discord
    gradle
    gcc
    git
    gh
    wget
    zsh
    oh-my-zsh
    zsh-completions
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    libnotify
    neofetch
    unzip

    bun

    pciutils

    ripgrep

    tmux
  ];
}
