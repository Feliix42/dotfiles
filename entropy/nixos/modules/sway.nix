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

      # override VA-API driver
      export LIBVA_DRIVER_NAME=iHD
    '';
  };

  programs.waybar.enable = true;

  services.redshift = {
    enable = true;
    package = pkgs.gammastep;
    temperature.night = 3500;
  };


  # ------------ Display Manager ----------------------------------------------
  services.xserver = {
    # under protest
    enable = true;

    # graphics
    #videoDrivers = [ "modesetting" ];
    useGlamor = true;

    # use sddm for authentication
    displayManager.sddm.enable = true;
  };
  #services.xserver.videoDrivers = [
    #"intel"
    #"amdgpu"
    #"radeon"
    #"nouveau"
    #"modesetting"
    #"fbdev"
  #];
  #services.xserver.displayManager.gdm = {
    #enable = true;
    #wayland = true;
  #};
}
