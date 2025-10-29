{
  inputs = import ./inputs;

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
      "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
    ];
  };

  outputs =
    inputs@{
      self,
      ...
    }:
    let
      inherit (self.lib) mkNixOS mkDarwin;
    in
    {
      lib = import ./lib { inherit inputs; };
      darwinConfigurations = {
        macbook = mkDarwin {
          extraModules = [ self.configs.macbook ];
        };
      };
      # {
      #   nixpkgs.overlays = [
      #     # use selected unstable packages with pkgs.unstable.xyz
      #     # https://discourse.nixos.org/t/how-to-use-nixos-unstable-for-some-packages-only/36337
      #     # "https://github.com/ne9z/dotfiles-flake/blob/d3159df136294675ccea340623c7c363b3584e0d/configuration.nix"
      #     (final: prev: {
      #       unstable = import inputs.nixpkgs-unstable {
      #         system = prev.system;
      #       };
      #     })

      #     (final: prev: {
      #       # pkgs.unstable-locked.<something>
      #       unstable-locked = import inputs.nixpkgs-locked { system = prev.system; };
      #     })

      #     (final: prev: {
      #       # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
      #       mkAlias = inputs.mkAlias.outputs.apps.${prev.system}.default.program;
      #     })

      #   ];
      # }

      nixosConfigurations = {
        mainSystem = mkNixOS {
          extraModules = [
            self.configs.mainSystem
          ];
        };

        # server = mkNixOS {
        #   extraModules = [
        #     ./hosts/server/configuration.nix
        #   ];
        # };
      };

      configs = import ./configurations { inherit self; };

      modules = import ./modules { inherit self; };
    };
}
