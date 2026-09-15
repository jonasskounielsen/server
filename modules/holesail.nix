{config, ssh_port, mc_port, ...}:

{
  services.holesail-server = {
    holesail_ssh = {
      enable = true;
      port = ssh_port;
      implementation = "js";
      key-file = config.sops.secrets."holesail/private_key".path;
      public = false;
      user = "silde";
      group = "wheel";
      log = false;
    };
    holesail_minecraft = {
      enable = true;
      port = mc_port; # Minecraft server port.
      implementation = "js";
      key-file = config.sops.secrets."holesail/public_key".path;
      public = true;
      user = "silde";
      group = "wheel";
      log = false;
    };
  };
  sops.secrets."holesail/private_key" = { 
    owner = config.users.users.silde.name;
    mode = "0400";
  };
  sops.secrets."holesail/public_key" = { 
    owner = config.users.users.silde.name;
    mode = "0400";
  };
}

