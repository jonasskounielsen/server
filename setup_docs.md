# Setting up silde:

## Prerequesits

Liveusb with nixos-GUI installed.
"FiskeNettet"
A usb-device to hold private age key and disko configuration.

## Instructions
1. Boot into UEFI and toggle secureboot on and create bios password and toggle fTPM on and enable TPM 2.0.
2. Boot from live-nixos-usb
3. Check SSD UUID is matching the one in the configuration and if not, change it on github and in the local disko config.
4. Mount USB device with disko-config and private sops key.
5. Connect to "FiskeNettet".
6. Run: sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /path/to/disko-config.nix
7. Run: sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-uuid/YOUR_UUID
8. Create /etc/nixos, and run(If git is not available create a nix-shell -p git): git clone https://github.com/jonasskounielsen/server
9. Import the age-private into /etc/sops/age/keys.txt
10. Create a nix-shell -p sops and: export SOPS_AGE_KEY_FILE="/etc/sops/age/private_key.txt"
11. Run: sudo nixos-install --flake .#silde
12. Run: journalctl -u holesail_ssh.service and import the public key into the github and save the private key.
