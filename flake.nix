# Do not modify! This file is generated.
# One exception: If you use a different template than "flake.in.nix" set
#                its relative path through the first argument to inputs.flakegen.

{
  inputs = {
    audio = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:polygon/audio.nix";
    };
    flakegen.url = "github:jorsn/flakegen";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    musnix.url = "github:musnix/musnix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nh";
    };
    niri.url = "github:sodiboo/niri-flake";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-citizen = {
      inputs.nix-gaming.follows = "nix-gaming";
      url = "github:LovingMelody/nix-citizen";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming-edge = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:powerofthe69/nix-gaming-edge";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
    qml-niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:imiric/qml-niri";
    };
    sidra = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wimpysworld/sidra";
    };
    sone = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lullabyX/sone";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/stylix";
    };
    vicinae = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:vicinaehq/vicinae";
    };
    zen-browser = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:0xc000022070/zen-browser-flake";
    };
  };
  outputs = inputs: inputs.flakegen ./_outputs.nix inputs;
}