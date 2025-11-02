{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.caskaydia-cove;
        name = "CakaydiaCove NF";
      };

      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };

    targets = {
      swaync.enable = false;
      starship.enable = false;
      nixvim.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
      qt.enable = false;
      qt.platform = "qtct";
    };
  };
}
