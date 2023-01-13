{ pkgs, ... }:

{
  services.xserver = {
    enable = false;
    autorun = false;

    desktopManager.plasma5 = {
      enable = true;
    };

    # use startx to run plasma
    displayManager.startx.enable = true;

    # I'd like a log please
    logFile = "/var/log/Xorg.0.log";
  };

  environment.etc."X11/xinit/xinitrc".text = ''
    export DESKTOP_SESSION=plasma
    exec ${pkgs.libsForQt5.plasma-workspace}/bin/startplasma-x11
  '';

  #environment.variables = {
    #GDK_SCALE = "2";
    #GDK_DPI_SCALE = "0.5";
    #_JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  #};


}
