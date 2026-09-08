{ config, pkgs, ... }:

{
  # Enable sound.
  #sound.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  ## use Pipewire instead.
  #hardware.pulseaudio.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

      wireplumber.extraConfig."10-bluez" = {
          "monitor.bluez.properties" = {
              
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.roles" = [
                  "a2dp_sink"
                  "a2dp_source"
                  "bap_sink"
                  "bap_source"
                  "hsp_hs"
                  "hsp_ag"
                  "hfp_hf"
                  "hfp_ag"
              ];
          };
      };
  };

  # enable bluetooth in general and add a simple tool for connecting devices
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
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

