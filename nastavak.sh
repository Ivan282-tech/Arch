#!/bin/bash
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen 
echo "LANG=en_US.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc --utc
echo ivan > /etc/hostname
echo "127.0.1.1 localhost.localdomain ivan" >> /etc/hosts
pacman -S networkmanager --noconfirm
systemctl enable NetworkManager 
passwd
MODE=$([ -d /sys/firmware/efi ] && echo UEFI || echo BIOS)
if [ $MODE == UEFI ]; then
    mkdir /boot/efi
    mount /dev/sda1 /boot/efi
    grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi --removable
    grub-mkconfig -o /boot/grub/grub.cfg
else
    pacman -S grub --noconfirm
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
fi
fallocate -l 3G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
useradd -m -g users -G wheel -s /bin/bash ivan
passwd ivan
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
pacman -S pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server --noconfirm
pacman -S --needed  sddm --noconfirm
pacman -S plasma dolphin konsole --noconfirm
sudo systemctl enable sddm
echo "Current=breeze" >> /usr/lib/sddm/sddm.conf.d/default.conf