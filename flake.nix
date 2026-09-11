{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    holesail = {
     url = "github:jjacke13/holesail-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      sops-nix,
      holesail,
      disko,
      lanzaboote,
      nix-minecraft,
      ...
    }:
    let
      system = "x86_64-linux";
      nixosSystem = nixpkgs.lib.nixosSystem;
    in

    {
      nixosConfigurations = {
        silde = nixosSystem {
          inherit system;
          modules = [
            sops-nix.nixosModules.sops
            holesail.nixosModules.x86_64-linux.holesail-server
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            nix-minecraft.nixosModules.minecraft-servers
            ./configuration.nix
          ];
          specialArgs = {
            inherit inputs;
            ssh_port = 2307;
          };
        };
      };
    };
}
