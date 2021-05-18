{ pkgs, ... }:

{
  services.xserver.dpi = 192;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  # Configure X Server
  services.xserver.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      dmenu
      #(i3status-rust.overrideAttrs ( oldAttrs: { cargoBuildFlags = [ "--features=notmuch" ]; }))
      i3status-rust
      i3lock-fancy
      libnotify
      dunst
      feh
      scrot
      ## automatic detection of display changes
      # autorandr
    ];
    # extraSessionCommands = "feh --bg-scale /home/felix/wall.jpg";
  };
  # login window options
  services.xserver.displayManager.lightdm = {
    background = "/etc/nixos/extra/login.jpg";
    # should be enabled by selecting i3
    # enable = true;
    greeters.gtk = {
      cursorTheme.name = "Adwaita-dark";
      iconTheme.name = "Adwaita-dark";
      theme.name = "Adwaita-dark";
    };
  };

  services.xserver.xautolock = {
    enable = true;
    extraOptions = [ "-detectsleep" ];
    locker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    nowlocker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    time = 10;
  };

  # use redshift
  services.redshift = {
    enable = true;
    temperature.night = 3500;
  };
}
