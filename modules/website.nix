{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."silde.dk:80".extraConfig = ''
      respond "<h1>Hello, World!</h1>"
   '';
  };
}
