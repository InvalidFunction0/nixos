inputs:
let
  inherit (builtins) mkIf mkMerge;
in
{
  mkNixOS =
    {
      extraModules ? [ ],
      mainUser ? "ayaan",
    }:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs mainUser; };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.musnix.nixosModules.musnix
      ]
      ++ extraModules;
    };

  mkDarwin =
    {
      extraModules ? [ ],
      mainUser ? "ayaanwaqas",
    }:
    inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs mainUser; };

      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.stylix.darwinModules.stylix
      ]
      ++ extraModules;
    };

  mkIfElse =
    cond: yes: no:
    mkMerge [
      (mkIf cond yes)
      (mkIf (!cond) no)
    ];
}
