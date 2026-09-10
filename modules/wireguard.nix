{ config, ... }:
{
  sops.secrets."wireguard/public_key" = { };
  sops.secrets."wireguard/private_key" = { };

  networking.wg-quick.interfaces."wg0" = {
    privateKey = config.sops.secrets."wireguard/private_key";
    address = "10.2.0.2/32";
    dns = "10.2.0.1";
    autostart = true;
    peers = [ {
        publicKey = config.sops.secrets."wireguard/public_key";
        endpoint = "193.29.107.162:51820";
        allowedIps = [
          "0.0.0.0/0"
          "::/0"
        ];
    } ];
  };
}
