self:
{
  ...
}:
{
  imports = [
    self.configs.baseDarwin
  ];

  configs.baseDarwin.enable = true;

  networking.hostName = true;

  system.stateVersion = 6;
}
