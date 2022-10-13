{ config, pkgs, ... }:

{
  # make the screen usable
  #hardware.video.hidpi.enable = true;
  #services.xserver.dpi = 180;

  nixpkgs.config = {
    # enable hardware-accelerated graphics
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      # add nixpkgs for unstable package sources
      #unstable = import <nixpkgs> {
        #config = config.nixpkgs.config;
      #};
    };
    # allow unfree licenced packges
    allowUnfree = true;
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      mesa.drivers
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # allow brightness control
  services.illum.enable = true;
}
