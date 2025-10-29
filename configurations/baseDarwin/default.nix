self:
{
  mainUser,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;
  cfg = config.configs.baseDarwin;
in
{
  options.configs.baseDarwin = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    imports = [
      self.configs.base

      inputs.home-manager.darwinModules.home-manager
    ];

    nixpkgs.hostPlatform = "aarch64-darwin";

    # required for Determinate Nix, which I use on all Darwin systems
    nix.enable = false;

    home-manager.extraSpecialArgs = {
      isLinux = false;
    };

    # https://daiderd.com/nix-darwin/manual/index.html#sec-options

    system = {

      keyboard.enableKeyMapping = true;
      keyboard.remapCapsLockToControl = true;

      defaults = {
        # clock
        menuExtraClock.Show24Hour = true;
        menuExtraClock.ShowSeconds = true;

        # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/trackpad.nix
        trackpad = {
          # tap to click
          Clicking = true;
          # tap-tap-drag to drag
          Dragging = true;
          # two-finger-tap right click
          TrackpadRightClick = true;
        };

        # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/NSGlobalDomain.nix
        NSGlobalDomain = {
          # keyboard navigation in dialogs
          AppleKeyboardUIMode = 3;

          # disable press-and-hold for keys in favor of key repeat
          ApplePressAndHoldEnabled = false;

          AppleShowAllFiles = true;
          AppleShowAllExtensions = true;
          AppleInterfaceStyle = "Dark";

          # fast key repeat rate when hold
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
        };

        # killall Dock to make them have effect
        # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/dock.nix
        dock = {
          autohide = false;
          magnification = true;
          # most recently used spaces
          mru-spaces = false;
          tilesize = 64;
          largesize = 96;
        };

        # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/finder.nix
        finder = {
          # bottom status bar
          ShowStatusBar = true;
          ShowPathbar = true;

          # default to list view
          FXPreferredViewStyle = "Nlsv";
          # full path in window title
          _FXShowPosixPathInTitle = true;
        };

        controlcenter = {
          BatteryShowPercentage = true;
        };
      };
    };

    # touchid for sudo authentication
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
