{ config, ... }:
{
  sops.templates."eduroam-certificate" = {
    content = ''
      [connection]
      id=eduroam
      uuid=906422a9-468b-4505-8a6d-b42fffcd1141
      type=wifi
      interface-name=wlp2s0

      [wifi]
      mode=infrastructure
      ssid=eduroam

      [wifi-security]
      auth-alg=open
      key-mgmt=wpa-eap

      [802-1x]
      eap=peap;
      identity=${config.sops.placeholder."at/username"}
      password=${config.sops.placeholder."at/password"}
      phase2-auth=mschapv2

      [ipv4]
      method=auto

      [ipv6]
      addr-gen-mode=default
      method=auto

      [proxy]
    '';
  };

  environment.etc."NetworkManager/system-connections/eduroam.nmconnection" = {
    source = config.sops.templates."eduroam-certificate".path;
    mode = "0600";
  };
}
