# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./gnome.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    firewall = {
      checkReversePath = false;
    };
    hostName = "SILDE";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        # networkmanager-wireguard
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
    # useXkbConfig = true; # use xkb.options in tty.
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  virtualisation = {
    docker = {
      # For distrobox.
      enable = true;
    };
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "dk";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.SILDE = {
    isNormalUser = true;
    description = "Server I Lokale D2367 er Elendig";
    extraGroups = [
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxchZyMW1kAGCvKFYHMLYzmrDg3zDy/aCVY91/k/Ydx silde" # Jonathan
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4Zqri3qqyHhkboqJefXoW8uDHx55zh4i9k3SYDWx7J jonas@jonas-laptop" # Jonas
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF/MMrpoPMM2Exj+WazhonE/lTKawPiwc3vJEmXsmH1 SILDE" # Lucas
    ];
    packages = with pkgs; [
      distrobox
      mesa
      waypipe
    ];
  };

  programs = {
    git = {
      enable = true;
    };
    seahorse = {
      # gnome-keyring dependency.
      enable = true;
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim
    wireguard-tools # Dependency for protonvpn-gui.
    protonvpn-gui
    gtk4 # Dependency for protonvpn-gui.
  ];

  # Enable the OpenSSH daemon.
  services = {
    fail2ban = {
      enable = true;
    };
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
    openssh = {
      enable = true;
      ports = [ 2307 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    xserver = {
      videoDrivers = [
        "mesa"
      ];
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 2307 ];
  networking.firewall.allowedUDPPorts = [ ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
