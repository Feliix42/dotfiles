{ ... }:

{
  # ------------ networking ---------------------------------------------------
  networking.hostName = "entropy"; # Define your hostname.
  networking.wireless = {
    enable = true;  # Enables wireless support via wpa_supplicant.
    interfaces = [ "wlp0s20f3" ];
  };

  # NOTE(feliix42): This option set was the default prior to 22.05 but is now replaced by the `networking.useDHCP` setting in the hardware config.
  ## The global useDHCP flag is deprecated, therefore explicitly set to false here.
  ## Per-interface useDHCP will be mandatory in the future, so this generated config
  ## replicates the default behaviour.
  #networking.useDHCP = false;
  #networking.interfaces.enp0s31f6.useDHCP = true;
  ## USB-C dock
  #networking.interfaces.enp0s20f0u2u1.useDHCP = true;
  #networking.interfaces.wlp0s20f3.useDHCP = true;

  # enable OpenVPN for connecting to the TUD network
  services.openvpn.servers.tud = {
    config = '' config /home/felix/.config/vpn/TUD.ovpn '';
    autoStart = false; #true;
    updateResolvConf = true;
  };

  networking.openconnect.interfaces = {
    ccc = {
      user = "s6525655@vpn-cfaed-cpb-ma";
      protocol = "anyconnect";
      gateway = "vpn2.zih.tu-dresden.de";
      passwordFile = "/home/felix/.config/vpn/openconnect.txt";
      extraOptions = {
        authgroup = "A-Tunnel-TU-Networks";
        compression = "stateless";
        no-dtls = true;
        no-http-keepalive = true;
        pfs = true;
      };
      autoStart = false;
    };
  };

  # for SAMBA file shares
  services.gvfs.enable = true;


}
