{...}:
{
  disko = {
    enableConfig = true;
    devices = {
      disk.nvme = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HBHQ-000H1_S4GNNE0N638105";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "1G";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "tpm2-device=auto" ];
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" "-f" ];
                  mountpoint = "/";
                  subvolumes = {
                    "/@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                    "/@nix" = {
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                      mountpoint = "/nix";
                    };
                    "/@var" = {
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                      mountpoint = "/var";
                    };
                    "/@snapshots" = {
                      mountpoint = "/snapshots";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
