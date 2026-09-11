{ pkgs, ... }:
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.fabric = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_1.override {
        loaderVersion = "0.16.10";
      };
      serverProperties = { # https://minecraft.wiki/w/Server.properties
        server-port = 7270;
        difficulty = "hard";
        view-distance = 10;
        simulation-distance = 10;
        spawn-protection = 0;
        enforce-secure-profile = false;
        white-list = true;
        enforce-whitelist = true;
        max-players = 35;
        motd = "24htcd";
        pause-when-empty-seconds = 60;
      };
      symlinks = {
        "whitelist.json" = [
          {
            uuid = "uuid goes here";
          }
        ];
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          Fabric-API = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/9YVrKY0Z/fabric-api-0.115.0%2B1.21.1.jar";
            sha512 = "e5f3c3431b96b281300dd118ee523379ff6a774c0e864eab8d159af32e5425c915f8664b1cd576f20275e8baf995e016c5971fea7478c8cb0433a83663f2aea8";
          };
          Distant-Horizons = pkgs.fetchurl {
            url = "https://www.curseforge.com/api/v1/mods/508933/files/8389148/download";
            sha512 = "hash goes here";
          };
        });
      };
    };
  };
}
