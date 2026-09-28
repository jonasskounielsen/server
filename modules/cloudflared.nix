{config, pkgs, ...}:

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
        };
      };
    };
  };
  sops.secrets = {
    "cloudflared/credentials" = {};
    "cloudflared/certificate" = {};
  };
systemd.services.port_update_mc = {
  description = "A systemd-service to update minecraft server port on DNS-server.";
  enable = true;
  after = [ "network-online.target" "natpmp_mc.service" ];
  wants = [ "network-online.target" "natpmp_mc.service" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type = "oneshot";
  };
  script = ''
    sleep 10
    TOKEN=$(cat ${config.sops.secrets."cloudflared/api_token".path})
    PORT=$(${pkgs.systemd}/bin/journalctl -u natpmp_mc.service -n 12 -o cat | grep "Mapped public port" | ${pkgs.gawk}/bin/awk '{print $4}')

    ${pkgs.cloudflare-cli}/bin/cfcli -k "$TOKEN" -ttl 60 -d silde.dk -t SRV -n SRV edit _minecraft._tcp.mc "10 0 $PORT mc.silde.dk"
  '';
};

sops.secrets."cloudflared/api_token" = { };
  sops.secrets."cloudflared/api_token" = { };
}
