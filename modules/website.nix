{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."http://localhost:80".extraConfig = ''
      respond "<h1>Hello, World!</h1>"
   '';
  };
}
