{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #home-manager = {
      #url = "github:nix-community/home-manager";
      #inputs.nixpkgs.follows = "nixpkgs";
    #};
    mlir = {
      url = "github:Feliix42/mlir.nix/main";
      #url = "github:Feliix42/mlir.nix/circt";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO: define nixos-unstable and nixos-hardware as dependencies here

  # outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, mlir, ... }: {
  outputs = inputs@{ self, nixpkgs, unstable, nixos-hardware, mlir, ... }: {
    nixosConfigurations = {
      entropy = nixpkgs.lib.nixosSystem rec {
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
          ({ config, ... }: {
              nixpkgs.overlays = [ mlir.overlays.default ];
              _module.args = {
                unstable = import inputs.unstable {
                  inherit (config.nixpkgs) config;
                  inherit system;
                };
              };
          })
        ];
      };
    };

    hydraJobs.entropy."x86_64-linux" = self.nixosConfigurations.entropy.config.system.build.toplevel;
  };
}
