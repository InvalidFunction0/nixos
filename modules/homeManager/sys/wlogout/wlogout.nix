{ ... }:
{
  programs.wlogout = {
    enable = true;

    style = ./style.css;

    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shut down";
        keybind = "u";
        width = 0.75;
        height = 0.6;
      }
      {
        label = "sleep";
        action = "systemctl suspend";
        text = "Sleep";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
  };
}
