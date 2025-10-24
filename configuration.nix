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

  users.users.SILDE = {
    isNormalUser = true;
    description = "Server I Lokale D2367 er Elendig";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMTandOAfqY3qomHdTmHSgWz7mM2I2X/HaB28Eo7hKj jonathan@laptop" # Jonathan
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4Zqri3qqyHhkboqJefXoW8uDHx55zh4i9k3SYDWx7J jonas@jonas-laptop" # Jonas
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF/MMrpoPMM2Exj+WazhonE/lTKawPiwc3vJEmXsmH1 SILDE" # Lucas
    ];
    packages = with pkgs; [
      self.packages.${system}.playit-agent
    ];
    # ++ [
    #];
  };

  programs = {
    git = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  services = {
    fail2ban = {
      enable = true;
    };
    openssh = {
      enable = true;
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
