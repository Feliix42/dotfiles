{ config, pkgs, ... }:

{ 
  # set up virtualization with virtualbox
  virtualisation.virtualbox.host.enable = true;
  # I'm gonna keep this disabled for the sake of my sanity
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # enable docker on-demand
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  users.extraGroups = {
    docker.members = [ "felix" ];
    vboxusers.members = [ "felix" ];
  };
}
