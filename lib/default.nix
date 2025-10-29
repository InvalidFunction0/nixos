{ inputs }:
let
  flake = import ./flake inputs;

  lib = flake;
in
# expose main attrs
lib

# expose all funcs
// {
  inherit flake;
}
