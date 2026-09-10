{
  config,
  pkgs,
  ssh_port,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/eduroam.nix
    ./modules/secrets.nix
    ./modules/wireguard.nix
    ./modules/holesail.nix
    ./modules/cloudflared.nix
    #./modules/minecraft.nix
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/lanzaboote/";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        includeMicrosoftKeys = false;
        allowBrickingMyMachine = true;
      };
    };
    loader = {
      systemd-boot.enable = lib.mkForce false; # Lanzaboote overwrites this.
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    initrd = {
      systemd.enable = true;
    };
    tmp.cleanOnBoot = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "03:00";
    runGarbageCollection = true;
    allowReboot = true;
    rebootWindow = { lower = "04:00"; upper = "05:00"; };
    persistent = true;
    operation = "switch";
    upgrade = true;
  };

  networking = {
    hostName = "silde";
    networkmanager = {
      enable = true;
      settings = {
        connection = {
          autoconnect = true;
        };
        wifi = {
          cloned-mac-address = "stable";
          scan-rand-mac-address = "yes";
        };
      };
    };
    firewall = {
      allowedTCPPorts = [ ssh_port ];
      allowedUDPPorts = [ ];
      checkReversePath = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
  };

  nix = {
    optimise = {
      automatic = true;
      dates = "06:00";
      persistent = true;
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [ 
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  sops.secrets = {
    root_password_hash = {
      neededForUsers = true;
    };
    silde_password_hash = {
      neededForUsers = true;
    };
  };

  users.users.root.hashedPasswordFile = config.sops.secrets.root_password_hash.path;

  users.users.silde = {
    isNormalUser = true;
    description = "Serveren I Lokale D2366 er Elendig";
    hashedPasswordFile = config.sops.secrets.silde_password_hash.path;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMTandOAfqY3qomHdTmHSgWz7mM2I2X/HaB28Eo7hKj jonathan@laptop" # Jonathan
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4Zqri3qqyHhkboqJefXoW8uDHx55zh4i9k3SYDWx7J jonas@jonas-laptop" # Jonas
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF/MMrpoPMM2Exj+WazhonE/lTKawPiwc3vJEmXsmH1 SILDE" # Lucas
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkxNYWyd6zpLE/Fms9n16jGqk/8OMKk17ifIHZ/8NmZ SILDE" # Lucas-WSL
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1JZCU26uUHHZonQLaz5014ZkkFgT6v3KG+li64H/dg jonathan@ritchie" # jonathansvaerke-laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0bPTKetZQKKuuqh3VqJPMCHARx1XE6gUvHM8cNighH mads@nixos" #Mads laptop
    ];
  };

  programs = {
    git = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wireguard-tools
    age
    sops
    libnatpmp
  ];

  services = {
    fail2ban = {
      enable = true;
    };
    openssh = {
      enable = true;
      extraConfig = ''
        ClientAliveInterval 30

        ClientAliveCountMax 3
      '';
      ports = [ ssh_port ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    fwupd.enable = true;

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
