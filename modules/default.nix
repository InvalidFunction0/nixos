{
  self ? { },
}:
{
  zsh = import ./zsh self;
  zoxide = import ./zoxide self;
  starship = import ./starship self;
  eza = import ./eza self;

  tmux = import ./tmux self;

  nvim = import ./nvim self;

  _file = ./default.nix;
}
