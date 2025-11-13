{ config, pkgs, ... }:

{
  # make the screen usable
  #hardware.video.hidpi.enable = true;
  #services.xserver.dpi = 180;

  nixpkgs.config = {
    # enable hardware-accelerated graphics
    packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      # add nixpkgs for unstable package sources
      #unstable = import <nixpkgs> {
        #config = config.nixpkgs.config;
      #};
    };
    # allow unfree licenced packges
    allowUnfree = true;
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      mesa
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # allow brightness control
  services.illum.enable = true;
}
