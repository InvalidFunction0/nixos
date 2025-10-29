{
  self ? { },
}:
{
  base = import ./base self;

  mainSystem = import ./mainSystem self;
}
