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
pacman -S grub --noconfirm
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt
reboot
