{ pkgs, ... }:
{
  systemd.services.playit = {
    description = "A systemd-service for starting a playit tunnel.";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    wantedBy = [ "multi-user.target" ];

    path = "${pkgs.playtit-agent}/bin/playit-agent";

    script = "playit-cli";

  };
}
