inputs:
let
  inherit (builtins) mapAttrs;
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
}
