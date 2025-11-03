self:
{
  lib,
  ...
}:
{
  imports = [
    self.modules.base
  ];

  # DO NOT CHANGE
  system.stateVersion = "24.05";

  #
  # Base configuration
  #

  configs.base.enable = true;

  #
  # Module config
  #

  #
  # System-specific config
  #

  networking.hostname = "server";

  # swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
