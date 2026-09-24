{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."localhost:80".extraConfig = ''
      respond "<h1>Hello, World!</h1>"
   '';
  };
}
