{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    serverProperties = {
      server-port = 42069;
      difficulty = 3;
      gamemode = 1;
      max-players = 30;
      motd = "NixOS Minecraft server!";
      white-list = true;
    };
    whitelist = {
      username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    };
  };
}
