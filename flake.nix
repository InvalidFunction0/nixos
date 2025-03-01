{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # upgrade with
    #   nix flake lock --update-input nixpkgs-firefox-darwin
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  }@inputs: {
    darwinConfigurations.default = darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # apple silicon
      specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = pkg: true;
            allowUnsupportedSystem = true;
            allowBroken = true;
          };
        }
        {
          nixpkgs.overlays = [
            # pkgs.firefox-bin
            inputs.nixpkgs-firefox-darwin.overlay

            # use selected unstable packages with pkgs.unstable.xyz
            # https://discourse.nixos.org/t/how-to-use-nixos-unstable-for-some-packages-only/36337
            # "https://github.com/ne9z/dotfiles-flake/blob/d3159df136294675ccea340623c7c363b3584e0d/configuration.nix"
            (final: prev: {
              unstable =
                import inputs.nixpkgs-unstable {
                  system = prev.system;
                };
            })

            (final: prev: {
              # pkgs.unstable-locked.<something>
              unstable-locked =
                import inputs.nixpkgs-locked { system = prev.system; };
            })

            (final: prev: {
              # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
              mkAlias =
                inputs.mkAlias.outputs.apps.${prev.system}.default.program;
            })

          ];
        }
        ./modules/darwin.nix
        ./modules/systemPackages.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            # hack around nix-home-manager causing infinite recursion
            isLinux = false;
          };
          # home-manager.users."ayaan" = import ./hosts/default/home.nix;
        }
      ];
    };

    nixosConfigurations = {

      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      workMachine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
	        ./hosts/workMachine/configuration.nix
	      ];
      };

    };
  };
}
