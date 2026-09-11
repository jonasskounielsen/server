{ssh_port, mc_port, ...}:

{
  services.holesail-server = {
    holesail_ssh = {
      enable = true;
      port = ssh_port;
      implementation = "js";
      # key = ""; set up with sops after first use 
      public = false;
      user = "silde";
      group = "wheel";
      log = false;
    };
  };
    holesail_minecraft = {
      enable = true;
      port = mc_port; # Minecraft server port.
      implementation = "js";
      # key = ""; set up with sops after first use 
      public = true;
      user = "silde";
      group = "wheel";
      log = false;
  };
}

