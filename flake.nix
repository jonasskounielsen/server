{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      sops-nix,
      ...
    }:
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
            sops-nix.nixosModules.sops
            ./configuration.nix
          ];
          specialArgs = inputs;
        };
      };
      packages.${system}.playit-agent = import ./packages/playit/playit-agent.nix { inherit pkgs; };
    };
}
