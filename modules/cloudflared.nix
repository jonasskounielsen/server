{config, ...}:

{
  services.cloudflared = {
    enable = true;
    certificateFile = config.sops.secrets."cloudflared/certificate".path;
    tunnels = {
      "31b2a335-222c-4d4e-83b6-2efcad0f34b3" = {
        credentialsFile = config.sops.secrets."cloudflared/credentials".path;
        default = "http_status:404";
        #ingress = {
        #
        # };
      };
    };
  };
  sops.secrets = {
    "cloudflared/credentials" = {};
    "cloudflared/certificate" = {};
  };
}
