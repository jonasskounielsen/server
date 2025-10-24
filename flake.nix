{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    inputs@{ self, nixpkgs }:
    let
      system = "x86_64-linux";
      nixosSystem = nixpkgs.lib.nixosSystem;
      pkgs = (import nixpkgs { inherit system; });
    in

    {
      nixosConfigurations = {
        SILDE = nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
          specialArgs = inputs;
        };
      };
      packages.${system}.playit-agent = import ./packages/playit/playit-agent.nix { inherit pkgs; };
    };
}
