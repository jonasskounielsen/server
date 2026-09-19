{ config, mc_port, pkgs, ... }:

let
  vpn_ip = "193.29.107.162";
  vpn_port = "51820";
  dns_rule = "10.2.0.1";
  external_mc_port = "25566";
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
  systemd.services.natpmp = {
    description = "A systemd-service to autostart a port-forward request from a VPN-server.";
    name = "natpmp.service";
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    script = ''
        while true ; do date ; ${pkgs.libnatpmp}/bin/natpmpc -a ${external_mc_port} ${builtins.toString mc_port} tcp 60 -g 10.2.0.1 || { echo -e "ERROR with natpmpc command \a" ; break ; } ; sleep 5 ; done
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
