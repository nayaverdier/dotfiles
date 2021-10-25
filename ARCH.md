# Arch Installation

These are my notes for installing Arch Linux on a Dell XPS 15 7590 Laptop, dual
booting with the existing windows installation.

General references:

- [Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
- [Another dual boot guide](https://github.com/arminc/dell-xps-15-7590-dual-boot-arch-linux)
- [Install to virtualbox](https://medium.com/@gevorggalstyan/how-to-install-arch-linux-on-virtualbox-93bc83ded692)

## Prepare Windows

1. Reduce the windows partitions to the desired size (likely at least 100GB
  depending on how much data is expected there)
2. Change the SATA mode from RAID/IDE to AHCI ([reference](https://triplescomputers.com/blog/uncategorized/solution-switch-windows-10-from-raidide-to-ahci-operation/)):
   - Run `cmd` as administrator
   - `bcdedit /set {current} safeboot minimal`
   - Reboot into BIOS
   - Change the SATA Operation mode to AHCI
   - Save changes and reboot
   - Run `cmd` as administrator again
   - `bcdedit /deletevalue {current} safeboot`

## Install Arch

Note that most of this is just a simplification of the contents of the Arch
Installation Guide for my specific use case.

1. Download the Arch ISO image from the Arch Installation Guide, write it to a
   USB, and boot into it
2. Connect to internet
   - `ip link` to make sure the network interface is enabled
   - [`iwctl`](https://wiki.archlinux.org/title/Iwd#iwctl) to connect to your network
   - Alternatively, just plug in an ethernet cable
   - Verify connection with `ping archlinux.org` (or any other site)
3. Sync the system clock with `timedatectl set-ntp true`
4. Partition disks as desired using `fdisk /dev/nvme0n1`, for example:

   | Partition      | Usage           | Size      |
   | -------------- | --------------- | --------- |
   | /dev/nvme0n1p1 | EFI             | 190M      |
   | /dev/nvme0n1p2 | Used by Windows | ???       |
   | /dev/nvme0n1p3 | Used by Windows | ???       |
   | /dev/nvme0n1p4 | /boot           | 260M      |
   | /dev/nvme0n1p5 | \<swap\>        | 20G       |
   | /dev/nvme0n1p6 | Arch            | Remaining |

   - EFI partition needs the `EFI` type (`1` for GPT)
   - The boot partition must be marked as bootable (use the `a` command in `fdisk`)
   - Use `w` to save the partition map

5. Format the partitions
   - `mkfs.ext4 /dev/nvme0n1p4` (boot)
   - `mkfs.fat -F16 /dev/nvme0n1p1` (EFI)
   - `mkswap /dev/nvme0n1p5` (swap)
   - `mkfs.ext4 /dev/nvme0n1p6` (arch)
6. Mount the partitions
   - `mount /dev/nvme0n1p6 /mnt`
   - `/mkdir /mnt/boot`
   - `mount /dev/nvme0n1p4 /mnt/boot`
   - `mkdir /mnt/boot/efi`
   - `mount /dev/nvme0n1p1 /mnt/boot/efi`
   - `swapon /dev/nvme0n1p5`
7. Install arch

   ```bash
   pacstrap /mnt base base-devel linux linux-firmware dialog wpa_supplicant
   ```

8. Generate an fstab to automate mounting all of your new partitions

   ```bash
   genfstab -U /mnt > /mnt/etc/fstab
   ```

   Make sure the file looks good before continuing

9. `arch-chroot /mnt` to enter the new installation
10. Prepare for networking (once the live boot is gone):
    - `pacman -Syu dhcpcd iwd`
    - `systemctl enable dhcpcd`
    - `systemctl enable iwd`
11. `hwclock --systohc` to set the hardware clock
12. `passwd` to set a root password
13. Install GRUB bootloader
    - See the relevant section of the [virtualbox installation guide](https://medium.com/@gevorggalstyan/how-to-install-arch-linux-on-virtualbox-93bc83ded692)
    - `pacman -S grub efibootmgr`
    - `grub-install /dev/nvme0n1 --target=x86_64-efi --efi-directory=/boot/efi/ --bootloader-id=GRUB`
    - Update `/etc/default/grub` with the following settings:

      ```bash
      GRUB_TIMEOUT=0
      GRUB_HIDDEN_TIMEOUT=0
      GRUB_HIDDEN_TIMEOUT_QUIET=true
      GRUB_TIMEOUT_STYLE=hidden
      GRUB_CMDLINE_LINUX_DEFAULT="mem_sleep_default=deep resume=/dev/nvme0n1p5"
      ```

      Making sure that the `resume` partition is your swap partition.

      The timeout settings prevent the GRUB menu from ever appearing, and just
      immediately booting into Arch. This may not be what you want.
    - `grub-mkconfig -o /boot/grub/grub.cfg` to configure GRUB
14. `exit` to go back to the live ISO
15. `unmount -R /mnt` to unmount the arch installation
16. `reboot now` to reboot, hopefully into your real arch installation
17. You should be able to unplug the Arch USB now. See the [README](README.md)
    to fully configure the user space
