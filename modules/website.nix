{ pkgs, config, ... }:

{
  systemd.services.port_update_ssh = {
    description = "A systemd-service to update the current ssh port shown on the website.";
    enable = true;
    after = [ "network-online.target" "natpmp_ssh.service" ];
    wants = [ "network-online.target" "natpmp_ssh.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      sleep 10
      PORT=$(${pkgs.systemd}/bin/journalctl -u natpmp_ssh.service -n 12 -o cat | grep "Mapped public port" | ${pkgs.gawk}/bin/awk '{print $4}')
      echo "$PORT" > /var/lib/website/port.txt
    '';
  };

  services.caddy = {
    enable = true;
    virtualHosts."silde.dk:80".extraConfig = ''
      root * /etc/nixos/modules/website/

      file_server

      handle /api/port {
        root * /var/lib/website
        rewrite * /port.txt
	header Content-Type "text/plain; charset=utf-8"
	file_server
      }
      
      header /api/* Cache-Control "no-store, no-cache, must-revalidate"
   '';
  };
}
