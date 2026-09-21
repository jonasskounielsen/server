{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/minecraft/server";
    servers."24htcd" = {
      enable = true;
      autoStart = true;
      jvmOpts = "-Xms6144M -Xmx8192M";
      package = pkgs.fabricServers.fabric-26_2.override {
        loaderVersion = "0.19.3";
	jre_headless = pkgs.openjdk25_headless;
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
      files."white-list.txt" = {
      	value = [
	  "nutr1a"
	  "jnas4242"
	  "Bot_Blueberry"
	  "madskrigeren"
	  "ufo000"
	  "amros88"
	  "KatXC"
	  "Dupdup01"
	  "xset_guggi"
	  "marbrn"
	  "DamageWasTaken"
	  "Awj1n"
	  "maxrumraket"
	  "_Matio"
	  "LeFlatfish"
	  "CarlO_Moystilen"
	  "Dr_Julo"
	  "ZnoahO_O"
	  "Science118"
	  "Kamma50"
	  "r3d5o"
	  "LostXC"
	];
      };
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          Fabric-API = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/UWwhUX3k/fabric-api-0.160.0%2B26.2.jar?mr_download_reason=standalone";
            sha512 = "sha512-Ggi2iywskPYAXvRBq3G2X0ZL6WQAW5wNGOb8bF7FP+NG5912GJxPCa3lnvm8O4NjdqLMcdTObpvkcSJHfRu9Hg==";
         };
         Distant-Horizons = pkgs.fetchurl {
           url = "https://cdn.modrinth.com/data/uCdwusMi/versions/gBf0SaV1/DistantHorizons-3.2.0-b-26.2-fabric-neoforge.jar?mr_download_reason=standalone";
           sha512 = "sha512-wbiFd3agAsIjKIfYkb1JGV88MSenq+EkI3atIDceMVVNi6bHySoZW3B4LK2U/pcJQUh/KvUwmI2biBlFXIWecg==";
         };
	 Lithium = pkgs.fetchurl {
	   url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/f7vZ0VWU/lithium-fabric-0.25.3%2Bmc26.2.jar?mr_download_reason=standalone";
           sha512 = "sha512-FItjjzxiKfuvSHEgojRKCvXkEaWqZTPV25112gqMDYME9j60zKE/TQOyybTCPVWd10wdgyQi74owh70AXmKovQ==";
	 };
	 C2ME = pkgs.fetchurl {
	   url = "https://cdn.modrinth.com/data/VSNURh3q/versions/LmKTn6Yc/c2me-fabric-mc26.2-0.4.2-alpha.0.52.jar?mr_download_reason=standalone";
	   sha512 = "sha512-dqfFLqmyIpXBXQK+fxykto/Gc2hGXxvTz/tHzTa/O/a53ZJbygLMssfLLCbfEjVTjZjdusQ/hZhcOf0YPJ80aA==";
	 };
	 ScalableLux = pkgs.fetchurl {
	   url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/EKLUURiy/ScalableLux-fabric-0.3.0-alpha.0.3-all.jar?mr_download_reason=standalone";
	   sha512 = "sha512-6hVRyHKKcm9u6C/tMECvUnkZQ++Z9rY0KO13B5f2BnfgFgl1rVmtD1G81KTsK12jnGkTqyN58uJdI5cTLUaalA==";
	 };
	 Krypton = pkgs.fetchurl {
	   url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/5WeL0Nkz/krypton-0.3.1.jar?mr_download_reason=standalone";
	   sha512 = "sha512-uNmvNM0AUEk6+4piMsuPeF2qnYiHtwRfbmpTxrubX/xDGP2bA0epQOrP66R3PxDLgK4L4eec5MGIj5btoh5WTg==";
	 };
	 FerriteCore = pkgs.fetchurl {
	   url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar?mr_download_reason=standalone";
	   sha512 = "sha512-2B+pfhF4TBnUL4nC9DODHQB2A91xk87kX6F35KapxSs4SxmFhuBKD39jzZlv7XEzIleL3pqNtX4RiIVK5cvlhA==";
	 };

	  #lazydfu - not available for 26.2 yet
	  #memory leak fix - not available for 26.2 yet
        });
      };
    };
  };
}
