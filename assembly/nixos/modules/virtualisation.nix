{ config, pkgs, ... }:

{ 
  # set up virtualization with virtualbox
  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   package = unstable.virtualbox;
  # };
  # I'm gonna keep this disabled for the sake of my sanity
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # enable podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
