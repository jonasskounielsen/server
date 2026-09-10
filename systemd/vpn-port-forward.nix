{
  describtion = "A systemd-service to autostart a port-forward request from a VPN-server.";
  enable = true;
  after = [ "network-online.target"];

  serviceConfig = {
    execStart = ''
      wg-quick up /home/SILDE/.config/SILDE-DK-140.conf;
      while true ; do date ; natpmpc -a 1 2307 udp 60 -g 10.2.0.1 && natpmpc -a 1 2307 tcp 60 -g 10.2.0.1 || { echo -e "ERROR with natpmpc command \a" ; break ; } ; sleep 5 ; done
    '';
  };
  wantedBy = [ "multi-user.target" ];
}
