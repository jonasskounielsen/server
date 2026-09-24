{config, ...}:

{
  services.cloudflared = {
    enable = true;
    certificateFile = config.sops.secrets."cloudflared/certificate".path;
    tunnels = {
      "920968d4-6e99-4c22-ac4b-03928fbaf77b" = {
        credentialsFile = config.sops.secrets."cloudflared/credentials".path;
        default = "http_status:404";
        ingress = {
          "silde.dk" = "http://localhost:80";
	  "www.silde.dk" = "http://localhost:80";
        };
      };
    };
  };
  sops.secrets = {
    "cloudflared/credentials" = {};
    "cloudflared/certificate" = {};
  };
}
