{ pkgs, ... }:

{
  # ------------ networking ---------------------------------------------------

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
