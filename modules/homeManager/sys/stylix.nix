{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.cakaydia-cove;
        name = "CakaydiaCove NF";
      };

      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
