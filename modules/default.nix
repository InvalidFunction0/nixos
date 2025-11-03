{
  self ? { },
}:
{
  zsh = import ./zsh self;
  starship = import ./starship self;

  nvim = import ./nvim self;

  _file = ./default.nix;
}
