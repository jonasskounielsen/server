{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/playit.nix
    ./modules/eduroam.nix
    ./modules/secrets.nix
    ./modules/minecraft.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "SILDE";
    networkmanager = {
      enable = true;
      settings = {
        connection = {
          autoconnect = true;
        };
      };
    };
  };

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  sops.secrets = {
    rootPasswordHash = {
      neededForUsers = true;
    };
    SILDEPasswordHash = {
      neededForUsers = true;
    };
  };

  users.users.root.hashedPasswordFile = config.sops.secrets.rootPasswordHash.path;

  users.users.SILDE = {
    isNormalUser = true;
    description = "Server I Lokale D2367 er Elendig";
    hashedPasswordFile = config.sops.secrets.SILDEPasswordHash.path;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMTandOAfqY3qomHdTmHSgWz7mM2I2X/HaB28Eo7hKj jonathan@laptop" # Jonathan
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4Zqri3qqyHhkboqJefXoW8uDHx55zh4i9k3SYDWx7J jonas@jonas-laptop" # Jonas
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF/MMrpoPMM2Exj+WazhonE/lTKawPiwc3vJEmXsmH1 SILDE" # Lucas
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkxNYWyd6zpLE/Fms9n16jGqk/8OMKk17ifIHZ/8NmZ SILDE" # Lucas-WSL
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1JZCU26uUHHZonQLaz5014ZkkFgT6v3KG+li64H/dg jonathan@ritchie" # jonathansvaerke-laptop
    ];
    packages = with pkgs; [
      self.packages.${system}.playit-agent
    ];
  };

  programs = {
    git = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim

    # sops-nix
    age
    sops
  ];

  services = {
    fail2ban = {
      enable = true;
    };
    ollama = {
      enable = true;
      loadModels = [
        "mistral:7b"
        "gemma3:4b"
        "gemma3:270m"
      ];
    };
    openssh = {
      enable = true;
      extraConfig = ''
        ClientAliveInterval 30

        ClientAliveCountMax 3
      '';
      ports = [ 2307 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 2307 ];
  networking.firewall.allowedUDPPorts = [ ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
