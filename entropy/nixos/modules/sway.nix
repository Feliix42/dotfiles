{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland # for legacy apps
      waybar
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      #dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      bemenu
      kanshi # replacement for autorandr
      sway-contrib.grimshot
      imv # image viewer
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
      # firefox x11 <-> wayland interoperability
      export MOZ_DBUS_REMOTE=1
    '';
  };

  programs.waybar.enable = true;

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    temperature.night = 3500;
  };


  # ------------ Display Manager ----------------------------------------------
  # use sddm for authentication
  services.xserver.enable = true;
  #services.xserver.displayManager.gdm = {
    #enable = true;
    #wayland = true;
  #};
  services.xserver.displayManager.sddm = {
    enable = true;
  };
}