#########################################################
# bootstrap script for 2020 Dell XPS 13", with 1TB SSD.
#
# Created by: Chris Thachuk
# Created on: December 7, 2020
#########################################################

create_partitions() {
    # Create partitions, set bootable flag.
    parted -s /dev/nvme0n1 -- mklabel gpt
    parted -s /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
    parted -s /dev/nvme0n1 -- mkpart primary 512MiB 100%
    parted -s /dev/nvme0n1 -- set 1 boot on
}

setup_boot_partition() {
    mkfs.fat -F32 -n BOOT /dev/nvme0n1p1
}

setup_lvm_partitions() {
    echo    
    echo "=================================================="
    echo "Choose a strong password to encrypt main partition"
    echo "=================================================="
    echo
    cryptsetup luksFormat /dev/nvme0n1p2
    cryptsetup open /dev/nvme0n1p2 cryptlvm

    pvcreate /dev/mapper/cryptlvm
    vgcreate vg0 /dev/mapper/cryptlvm
    lvcreate -L 32G vg0 -n swap
    lvcreate -L 256G vg0 -n nixos
    lvcreate -l 100%FREE vg0 -n home
    
    mkfs.ext4 -L nixos /dev/vg0/nixos
    mkfs.ext4 -L home /dev/vg0/home
    mkswap -L swap /dev/vg0/swap
}

mount_partitions_for_install() {
    # Mount partitions ahead of NixOS install
    mount /dev/vg0/nixos /mnt
    mkdir /mnt/home
    mount /dev/vg0/home /mnt/home
    mkdir /mnt/boot
    mount /dev/nvme0n1p1 /mnt/boot
    swapon /dev/vg0/swap
}

install_nixos_from_flake() {
    # requires nixUnstable currently
    nix build /var/tmp/dotfiles#nixosConfigurations.enterprise.config.system.build.toplevel --experimental-features "flakes nix-command" --store "/mnt" --impure
    # then install the build system...
    nixos-install --root /mnt --system ./result 
}

read -p "Proceeding will erase your disk(s).  Type YES (uppercase) if you are sure: " 
echo
if [[ $REPLY =~ "YES" ]]
then
    ( create_partitions \
    && setup_boot_partition \
    && setup_lvm_partitions \
    && mount_partitions_for_install \
    && install_nixos_from_flake \
    && echo && echo "System has been bootstrapped." && echo ) \
    || ( echo && echo "Error bootstrapping system." && echo )
fi
