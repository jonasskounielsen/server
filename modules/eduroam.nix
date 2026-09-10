{ config, ... }:
{
  sops = {
    templates."eduroam-certificate" = {
      content = ''
        [connection]
        id=eduroam
        uuid=be019416-ad4c-4622-9147-8d1d72e724e4
        type=wifi
        autoconnect-priority=1

        [wifi]
        mode=infrastructure
        ssid=eduroam

        [wifi-security]
        key-mgmt=wpa-eap

        [802-1x]
        eap=peap;
        identity=${config.sops.placeholder."eduroam-username"}
        password=${config.sops.placeholder."eduroam-password"}
        phase2-auth=mschapv2

        [ipv4]
        method=auto

        [ipv6]
        addr-gen-mode=privacy
        method=auto

        [proxy]
      '';
    };

    secrets = {
      eduroam-username = { };
      eduroam-password = { };
    };
  };

  environment.etc."NetworkManager/system-connections/eduroam.nmconnection" = {
    source = config.sops.templates."eduroam-certificate".path;
    mode = "0600";
  };
}
