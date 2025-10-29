{
  self ? { },
}:
{
  # the base elements I'll want in every device I use
  base = import ./base self;

  # the base elements for ever Darwin system
  baseDarwin = import ./baseDarwin self;

  # the config for my main PC
  mainSystem = import ./mainSystem self;
}
