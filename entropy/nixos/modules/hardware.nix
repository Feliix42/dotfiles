{ config, pkgs, ... }:

{ 
  # Enable support for flashing new firmware onto my Moonlander
  hardware.keyboard.zsa.enable = true;

  services.udev.packages = [ pkgs.libu2f-host ];

  # enable fingerprint reader
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  environment.systemPackages = with pkgs; [
    # tool for flashing firmware
    wally-cli
  ];

}
