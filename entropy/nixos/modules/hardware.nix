{ config, pkgs, ... }:

{ 
  # Update the CPU microcode
  hardware.cpu.intel.updateMicrocode = true;

  # Enable support for flashing new firmware onto my Moonlander
  hardware.keyboard.zsa.enable = true;

  hardware.nvidia.open = true;

  services.udev.packages = [ pkgs.libu2f-host ];

  # automount usb drives
  services.udisks2.enable = true;

  # enable fingerprint reader
  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  ##security.pam.services.xscreensaver.fprintAuth = true;
  #security.pam.services.sudo.fprintAuth = true;

  environment.systemPackages = with pkgs; [
    # tool for flashing firmware
    wally-cli
  ];

}
