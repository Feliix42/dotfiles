{ config, pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  # configure pulseaudio to work with bluetooth headsets using aptx
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # the full package is necessary for BT support
    package = pkgs.pulseaudioFull;
    # switch to bluetooth automatically if they are connected
    extraConfig = "
      load-module module-switch-on-connect
      load-module module-bluetooth-policy auto_switch=2
    ";
  };
  nixpkgs.config.pulseaudio = true;

  # enable bluetooth in general and add a simple tool for connecting devices
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    # enable A2DP
    settings = {
      General = {
        Enable = "Source,Sink,Media"; 
        Disable = "Socket";
      };
    };
  };
  services.blueman.enable = true;
}
