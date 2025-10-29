self:
{
  ...
}:
{
  imports = [
    self.configs.base
    ../../hosts/linux/configuration.nix
  ];
}
