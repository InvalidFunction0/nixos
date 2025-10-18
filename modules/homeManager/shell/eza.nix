{ ... }:
{
  imports = [ ./ezaTheme.nix ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "always";
  };
}
