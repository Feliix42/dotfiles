{ config, pkgs, unstable, ... }:

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

  # enable docker on-demand
  # virtualisation.docker.enable = true;
  # virtualisation.docker.enableOnBoot = false;
  # users.extraGroups = {
  #   docker.members = [ "felix" ];
  #   vboxusers.members = [ "felix" ];
  # };
}
