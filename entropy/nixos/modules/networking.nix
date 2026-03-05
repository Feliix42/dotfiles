{ pkgs, ... }:

{
  # ------------ networking ---------------------------------------------------
  networking.hostName = "entropy"; # Define your hostname.
  # networking.wireless = {
  #   enable = true;  # Enables wireless support via wpa_supplicant.
  #   interfaces = [ "wlp0s20f3" ];
  # };

  # use network manager
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "wpa_supplicant";
      powersave = true;
    };
    # necessary to allow eduVPN to function correctly
    plugins = with pkgs; [ networkmanager-openvpn ];
  };

  users.users.felix.extraGroups = [ "networkmanager" ];


  # NOTE(feliix42): This option set was the default prior to 22.05 but is now replaced by the `networking.useDHCP` setting in the hardware config.
  ## The global useDHCP flag is deprecated, therefore explicitly set to false here.
  ## Per-interface useDHCP will be mandatory in the future, so this generated config
  ## replicates the default behaviour.
  #networking.useDHCP = false;
  #networking.interfaces.enp0s31f6.useDHCP = true;
  ## USB-C dock
  #networking.interfaces.enp0s20f0u2u1.useDHCP = true;
  #networking.interfaces.wlp0s20f3.useDHCP = true;

  # statistics
  services.vnstat.enable = true;

  # for SAMBA file shares
  services.gvfs.enable = true;
  # for manual mounting of SMB shares
  environment.systemPackages = [
    pkgs.cifs-utils
    pkgs.eduvpn-client
  ];

}
