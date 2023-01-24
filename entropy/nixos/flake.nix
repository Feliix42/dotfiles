{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #home-manager = {
      #url = "github:nix-community/home-manager";
      #inputs.nixpkgs.follows = "nixpkgs";
    #};
    mlir = {
      url = "./mlir";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: define nixos-unstable and nixos-hardware as dependencies here

  # outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, mlir, ... }: {
  outputs = inputs@{ nixpkgs, nixos-hardware, mlir, ... }: {
    nixosConfigurations = {
      entropy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t14
          #home-manager.nixosModules.home-manager
          #{
            #home-manager.useGlobalPkgs = true;
            #home-manager.useUserPackages = true;
            #home-manager.users.jdoe = import ./home.nix;

            ## Optionally, use home-manager.extraSpecialArgs to pass
            ## arguments to home.nix
          #}
          (_: {
              nixpkgs.overlays = [ mlir.overlay ];
          })
        ];
      };
    };
  };
}
