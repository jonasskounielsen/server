{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      nixosSystem = nixpkgs.lib.nixosSystem;
    in

    {
      nixosConfigurations = {
        default = nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
