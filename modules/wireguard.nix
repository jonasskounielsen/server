{ config, ... }:

let
  vpn_ip = "193.29.107.162";
  vpn_port = "51820";
in

{
  sops.secrets."wireguard/private_key" = {
    restartUnits = [ "wireguard-wg0.service" ];
  };

  networking.wg-quick.interfaces."wg0" = {
    privateKeyFile = config.sops.secrets."wireguard/private_key".path;
    address = "10.2.0.2/32";
    dns = "10.2.0.1";
    autostart = true;
    peers = [ {
        publicKey = "sbjnjFtxUz4dxYfNL7WOVf1StMjjAhkiPLCPtVtlhRI=";
        endpoint = "${vpn_ip}:${vpn_port}";
        persistentKeepalive = 25;
        allowedIps = [
          "0.0.0.0/0"
          "::/0"
        ];
    } ];
  };
  networking.nftables = {
    enable = true;
    tables.kill-switch = {
      family = "inet";  # handles IPv4 AND IPv6 with one table
      content = ''
        chain output {
          type filter hook output priority 0; policy drop;

          oifname "lo" accept

          oifname "wg0" accept

          ip daddr ${vpn_ip} udp dport ${vpn_port} accept

          ct state established,related accept
        }
      '';
    };
  };
}
