{
  systemd.services.networkmanager = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };
}
