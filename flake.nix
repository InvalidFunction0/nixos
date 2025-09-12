{
  description = "Nixos config flake";

  nixConfig = {
    trusted-substituters = [
      "https://xixiaofinland.cachix.org"
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
    ];
    trusted-public-keys = [
      "xixiaofinland.cachix.org-1:GORHf4APYS9F3nxMQRMGGSah0+JC5btI5I3CKYfKayc="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  }@inputs: {
    darwinConfigurations."Ayaans-MacBook-Air" = nix-darwin.lib.darwinSystem {
      # users.users.ayaanwaqas = {
      #     name = "$USER";
      #     home = "/Users/$USER";
      # };

      #   # Create /etc/zshrc that loads the nix-darwin environment.
      #   programs.zsh.enable = true;
      # specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = pkg: true;
            allowUnsupportedSystem = true;
            allowBroken = true;
          };

          nixpkgs.hostPlatform = "aarch64-darwin";

          system.stateVersion = 6;
          system.primaryUser = "ayaanwaqas";
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
        ./modules/pkgsDarwin.nix
        home-manager.darwinModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.extraSpecialArgs = {
        #     inherit inputs;
        #     # hack around nix-home-manager causing infinite recursion
        #     isLinux = false;
        #   };
        #   home-manager.users."ayaanwaqas" = import ./hosts/linux/home.nix;
        # }
      ];
    };

    nixosConfigurations = {

      linux = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
	      system = "x86_64-linux";
        modules = [
          ./hosts/linux/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      workMachine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
	      system = "aarch64-darwin";
        modules = [
	        ./hosts/workMachine/configuration.nix
	      ];
      };
    };
  };
}
