{
  self ? { },
}:
{
  zsh = import ./zsh self;
  zoxide = import ./zoxide self;
  starship = import ./starship self;
  eza = import ./eza self;

  nvim = import ./nvim self;

  _file = ./default.nix;
}
