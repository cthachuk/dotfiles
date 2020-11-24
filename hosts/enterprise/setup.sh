#! /usr/bin/env bash

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- mkpart primary 512MiB 100%
parted /dev/sda -- set 1 boot on
mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

mount /dev/sda2 /mnt

mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

nixos-generate-config --root /mnt

cat << EOF > /mnt/etc/nixos/hardware-configuration.nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  swapDevices = [ ]; 
}
EOF

cat << EOF > /mnt/etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = "enterprise";
  time.timeZone = "Americas/Los_Angeles";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  system.stateVersion = "20.09"; 
}
EOF

nixos-install --no-root-passwd
