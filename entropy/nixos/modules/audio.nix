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
    #alsa.enable = true;
    #alsa.support32Bit = true;
    #pulse.enable = true;
    ## If you want to use JACK applications, uncomment this
    ##jack.enable = true;

    ## use the example session manager (no others are packaged yet so this is enabled by default,
    ## no need to redefine it in your config for now)
    ##media-session.enable = true;
    #media-session.config.bluez-monitor.rules = [
      #{
        ## Matches all cards
        #matches = [ { "device.name" = "~bluez_card.*"; } ];
        #actions = {
          #"update-props" = {
            #"bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            ## mSBC is not expected to work on all headset + adapter combinations.
            #"bluez5.msbc-support" = true;
            ## SBC-XQ is not expected to work on all headset + adapter combinations.
            #"bluez5.sbc-xq-support" = true;
          #};
        #};
      #}
      #{
        #matches = [
          ## Matches all sources
          #{ "node.name" = "~bluez_input.*"; }
          ## Matches all outputs
          #{ "node.name" = "~bluez_output.*"; }
        #];
        #actions = {
          #"node.pause-on-idle" = false;
        #};
      #}
    #];
    ##media-session.config.v4l2-monitor.rules = [
        ### An array of matches/actions to evaluate.
        ##{
            ### Rules for matching a device or node. It is an array of
            ### properties that all need to match the regexp. If any of the
            ### matches work, the actions are executed for the object.
            ##matches = [
                ##{
                    ### This matches all devices.
                    ##device.name = "~v4l2_device.*";
                ##}
            ##];
            ##actions = {
                ### Actions can update properties on the matched object.
                ##update-props = {
                    ###device.nick = "My Device"
                ##};
            ##};
        ##}
        ##{
            ##matches = [
                ##{
                    ### Matches all sources.
                    ##node.name = "~v4l2_input.*";
                ##}
                ##{
                    ### Matches all sinks.
                    ##node.name = "~v4l2_output.*";
                ##}
            ##];
            ##actions = {
                ##update-props = {
                    ###node.nick                       = "My Node"
                    ###node.nick                       = null
                    ###priority.driver                 = 100
                    ###priority.session                = 100
                    ##node.pause-on-idle               = false;
                    ###session.suspend-timeout-seconds = 5        # 0 disables suspend
                ##};
            ##};
        ##}
    ##];

  };

  #sound.mediaKeys.enable = true;


  # configure pulseaudio to work with bluetooth headsets using aptx
  hardware.pulseaudio = {
    enable = true;
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
