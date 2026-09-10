{ssh_port, ...}:

{
  services.holesail-server.holesail_ssh = {
    enable = true;
    port = ssh_port;
    implementation = "js";
    # key = ""; set up with sops after first use 
    public = false;
    user = "silde";
    group = "wheel";
    log = false;
  };
}

