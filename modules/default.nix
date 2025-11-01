{
  self ? { },
}:
{
  zsh = import ./zsh self;

  _file = ./default.nix;
}
