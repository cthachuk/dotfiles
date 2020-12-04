parted -s /dev/nvme0n1 -- mklabel gpt
parted -s /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted -s /dev/nvme0n1 -- mkpart primary 512MiB 100%

parted -s /dev/nvme0n1 -- set 1 boot on
mkfs.fat -F32 -n BOOT /dev/nvme0n1p1

echo "Choose a strong password to encrypt main partition"
echo "=================================================="
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptlvm

mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home
mkswap /dev/vg0/swap

mount /dev/vg0/root /mnt
mkdir /mnt/home
mount /dev/vg0/home /mnt/home
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/vg0/swap

nixos-generate-config --root /mnt

cat << EOF > /mnt/etc/nixos/pre-configuration.nix
{ config, pkgs, ... }:

{
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # set an empty root password for now
  users.users.root.initialHashedPassword = "";
}
EOF

# N.B. This only works if imports statement is on a single line.
sed -i "/.*imports.*/  imports = [ ./hardware-configuration.nix ./pre-configuration.nix ];/" /mnt/etc/nixos/configuration.nix

nixos-install --no-root-passwd
