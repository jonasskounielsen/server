{ config, mc_port, ssh_port, pkgs, ... }:
let
  vpn_ip = "193.29.107.162";
  vpn_port = "51820";
  dns_rule = "10.2.0.1";
  natpmp_service = name: port: {
    description = "A systemd-service to autostart a port-forward request from a VPN-server.";
    name = "natpmp_${name}.service";
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
    };
    script = ''
      ${pkgs.libnatpmp}/bin/natpmpc -a 1 ${builtins.toString port} tcp 60 -g 10.2.0.1 || { echo -e "ERROR with natpmpc command \a" ; }
    '';
  };
in

{
  sops.secrets = {
   "wireguard/private_key_moderate_nat_pmp" = {
     restartUnits = [ "wireguard-wg0.service" ];
   };
  };

  networking.wg-quick.interfaces = {
    "wg0" = {
      privateKeyFile = config.sops.secrets."wireguard/private_key_moderate_nat_pmp".path;
      address = [ "10.2.0.2/32" ];
      dns = [ dns_rule ];
      autostart = true;
      peers = [ 
        {
          publicKey = "sbjnjFtxUz4dxYfNL7WOVf1StMjjAhkiPLCPtVtlhRI=";
 	  endpoint = "${vpn_ip}:${vpn_port}";
 	  persistentKeepalive = 25;
 	  allowedIPs = [
 	    "0.0.0.0/0"
 	    "::/0"
 	  ];
        }
      ];
    };
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
  systemd.services.natpmp_mc = natpmp_service "mc" mc_port;
  systemd.services.natpmp_ssh = natpmp_service "ssh" ssh_port;
}
