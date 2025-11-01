{
  self ? { },
}:
{
  # the base elements for every NixOS system
  base = import ./base self;

  # the base elements for every Darwin system
  baseDarwin = import ./baseDarwin self;

  # the config for my main PC
  mainSystem = import ./mainSystem self;

  # the config for my MacBook
  macbook = import ./macbook self;

  _file = ./default.nix;
}
