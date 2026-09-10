{ config, ... }:

{
  sops.secrets = {
    "eduroam/username" = { };
    "eduroam/password" = { };
    "eduroam/certificate" = { };
  };

  sops.templates."eduroam.nmconnection" = {
    content = ''
      [connection]
      id=eduroam
      permissions=
      type=wifi

      [wifi]
      mode=infrastructure
      ssid=eduroam

      [wifi-security]
      key-mgmt=wpa-eap

      [802-1x]
      eap=peap
      ca-cert=${config.sops.secrets."eduroam/certificate".path}
      identity=${config.sops.placeholder."eduroam/username"}
      password=${config.sops.placeholder."eduroam/password"}
      phase2-auth=mschapv2

      [ipv4]
      method=auto

      [ipv6]
      addr-gen-mode=privacy
      method=auto

      [proxy]
    '';
    restartUnits = [ "NetworkManager.service" ];
  };

  environment.etc."NetworkManager/system-connections/eduroam.nmconnection" = {
    source = config.sops.templates."eduroam.nmconnection".path;
    mode = "0600";
  };
}
