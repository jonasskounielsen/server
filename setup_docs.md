# Setting Up Silde

## Prerequisites

Before you begin, make sure you have:

- A NixOS live USB with a graphical environment installed.
- Access to the `FiskeNettet` Wi-Fi network.
- A USB device containing:
  - The private `age` key.
  - The `disko` configuration.
- The SSD UUID referenced in the NixOS and `disko` configurations.
- Access to the GitHub repository containing the server configuration.

## Installation Instructions

### 1. Configure the UEFI/BIOS Settings

Boot into the system’s UEFI/BIOS settings and configure the following:

- Enable **Secure Boot**.
- Create a BIOS/UEFI administrator password.
- Enable **fTPM**.
- Ensure that **TPM 2.0** is enabled.

### 2. Boot into the NixOS Live Environment

Insert the NixOS live USB and boot from it.

### 3. Verify the SSD UUID

Check that the SSD UUID matches the UUID specified in the configuration.

If the UUID does not match:

1. Update it in the GitHub repository.
2. Update it in the local `disko` configuration.

### 4. Mount the Configuration USB Device

Mount the USB device containing:

- The `disko` configuration.
- The private `age` key.

### 5. Connect to the Network

Connect to the following Wi-Fi network:

```text
FiskeNettet
```

### 6. Partition, Format, and Mount the Disk

Replace `/path/to/disko-config.nix` with the actual path to the local `disko` configuration:

```bash
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  /path/to/disko-config.nix
```

> **Warning:** The `destroy,format,mount` mode will erase and reformat the configured disk. Verify the target disk and configuration carefully before running this command.

### 7. Enroll the TPM2 Key

Replace `YOUR_UUID` with the UUID of the encrypted disk:

```bash
sudo systemd-cryptenroll \
  --wipe-slot=tpm2 \
  --tpm2-device=auto \
  --tpm2-pcrs=0+2+7 \
  /dev/disk/by-uuid/YOUR_UUID
```

### 8. Clone the Server Configuration

Create the NixOS configuration directory:

```bash
sudo mkdir -p /etc/nixos
```

If Git is not available, start a temporary shell containing Git:

```bash
nix-shell -p git
```

Clone the repository:

```bash
sudo git clone https://github.com/jonasskounielsen/server /etc/nixos
```

Enter the configuration directory:

```bash
cd /etc/nixos
```

### 9. Import the Private `age` Key

Copy the private `age` key from the USB device to:

```text
/etc/sops/age/keys.txt
```

Example:

```bash
sudo mkdir -p /etc/sops/age
sudo cp /path/to/private-age-key /etc/sops/age/keys.txt
sudo chmod 600 /etc/sops/age/keys.txt
```

### 10. Configure SOPS

Start a temporary shell containing SOPS:

```bash
nix-shell -p sops
```

Set the environment variable pointing to the private key:

```bash
export SOPS_AGE_KEY_FILE="/etc/sops/age/keys.txt"
```

### 11. Install NixOS

From the repository directory, install the `silde` system configuration:

```bash
sudo nixos-install --flake .#silde
```

Follow any prompts displayed during the installation.

### 12. Retrieve the Holepunch SSH Key

Inspect the Holepunch SSH service:

```bash
journalctl -u holesail_ssh.service
```

Import the displayed public key into GitHub, then securely save the corresponding private key.

## Final Checklist

Before rebooting or disconnecting the USB device, verify that:

- [ ] Secure Boot, fTPM, and TPM 2.0 are enabled.
- [ ] The SSD UUID matches the configuration.
- [ ] The disk was partitioned and mounted successfully.
- [ ] The private `age` key is located at `/etc/sops/age/keys.txt`.
- [ ] `SOPS_AGE_KEY_FILE` points to the correct key file.
- [ ] The `silde` flake installs without errors.
- [ ] The Holepunch SSH public key has been added to GitHub.
- [ ] The corresponding private key has been stored securely.

