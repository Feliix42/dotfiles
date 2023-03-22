{ pkgs, ... }:

let
  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme "Dracula"
      gsettings set $gnome_schema icon-theme "Paper"
      '';
  };

  greetstyleWrapper = pkgs.writeText "gtkgreet.css" ''
    window {
        background-image: url("file://${pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath}");
        background-size: cover;
        background-position: center;
        color: #dddddd;
    }
  '';

  # configures the sway wrapper for the GTK greeter
  gtkgreetSwayWrapper = pkgs.writeText "gtkgreet-sway" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec configure-gtk
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${greetstyleWrapper}; swaymsg exit"
    bindsym Mod4+shift+q exec swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'
    include /etc/sway/config.d/*
  '';
in
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock-effects
      swayidle
      xwayland # for legacy apps
      waybar
      wl-clipboard
      mako # notification daemon
      kanshi # replacement for autorandr
      sway-contrib.grimshot
      imv # image viewer
      glib # gsettings
      configure-gtk
      #zafiro-icons
      dracula-theme
      paper-icon-theme
      # xdotool type application for inserting keypresses
      wtype

      # wofi as application runner
      wofi
      wofi-emoji
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
      # export LIBVA_DRIVER_NAME=iHD
    '';
  };

  programs.waybar.enable = true;

  services.redshift = {
    enable = true;
    package = pkgs.gammastep;
    executable = "/bin/gammastep";
    temperature.night = 3500;
  };

  # fixes vs code for wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";


  # ------------ Display Manager ----------------------------------------------
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${gtkgreetSwayWrapper}";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    ${pkgs.sway}/bin/sway
    ${pkgs.xorg.xinit}/bin/startx
    ${pkgs.libsForQt5.plasma-workspace}/bin/startplasma-wayland
    ${pkgs.fish}/bin/fish
  '';

}
