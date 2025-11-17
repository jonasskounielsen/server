{ ... }:
{
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/private_key.txt";
  };
}
