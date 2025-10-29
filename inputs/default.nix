let
  mainInputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  gaming = {
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };
  };

  desktopInputs = {
    hypr = {
      hyprland = {
        url = "github:hyprwm/Hyprland";
      };
    };

    system = {
      musnix = {
        url = "github:musnix/musnix";
      };
    };

    applications = {
      nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      zen-browser = {
        url = "github:0xc000022070/zen-browser-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };

in
{
  flakegen = {
    url = "github:jorsn/flakegen";
  };
}
// mainInputs
// gaming
// desktopInputs.hypr
// desktopInputs.system
// desktopInputs.applications
