{ self, ... }:
let
  system = "x86_64-linux";
in
{
  systemd.services.playit = {
    description = "A systemd-service for starting a playit tunnel.";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    wantedBy = [ "multi-user.target" ];

    script = "${self.packages.${system}.playit-agent}/bin/playit-agent";
  };
}
