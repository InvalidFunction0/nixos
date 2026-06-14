self:
{ pkgs, lib, ... }:
let
  inherit (lib) attrValues remove;
in
{
  environment.systemPackages =
    remove null (attrValues {
      # file management
      inherit (pkgs)
        unzip
        zip
        p7zip
        which
        imagemagick
        ;

      # networking
      inherit (pkgs)
        openssh
        rsync
        wget
        ;

      # dev
      inherit (pkgs)
        cargo
        # gcc
        # gradle
        nodejs
        rustup
        bun
        git
        gh
        prettier
        ruff
        nixfmt
        ;

      # audio
      inherit (pkgs)
        alsa-utils
        ;

      # misc cli
      inherit (pkgs)
        cmatrix
        cava
        btop-rocm
        htop
        lf
        fzf
        ripgrep
        fastfetch
        libnotify
        pciutils
        ;

      inherit (pkgs.rocmPackages)
        rocm-smi # for amd gpu on btop
        ;

      # temp while I set up nixos modules for them
      inherit (pkgs)
        ;
    })
    ++ (with pkgs; [
      # (discord.override {
      #   withOpenASAR = true;
      #   withVencord = true;
      # })
    ]);
}
