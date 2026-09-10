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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      sops-nix,
      holesail,
      disko,
      lanzaboote,
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
            holesail.nixosModules.x86_64-linux.holesail-server
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            ./configuration.nix
          ];
          specialArgs = {
            inherit inputs;
            ssh_port = 2307;
            nvme_id = "2ac9654f-80be-419d-ada1-8da089ff1f94";
          };
        };
      };
    };
}
