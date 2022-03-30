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
    pacman -S grub efibootmgr --noconfirm
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
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
echo "1 - GNOME"
echo "2 - KDE plasma"
echo "3 - XFCE"
echo "4 - Cinamon"
echo "5 - Mate"
echo "6 - i3"
echo "7 - Awesome"
echo "8 - Deepin"
echo "9 - LXDE"
read IZBOR

case $IZBOR in
    1)
    echo "exec gnome-session" > ~/.xinitrc
     pacman -S gnome
    ;;
    2)
    pacman -S --needed  sddm --noconfirm
    pacman -S plasma dolphin konsole --noconfirm
    echo "Current=breeze" >> /usr/lib/sddm/sddm.conf.d/default.conf
     systemctl enable sddm
    ;;
    3)
    pacman -S xfce4 lightdm lightdm-gtk-greeter
    echo "exec startxfce4" > ~/.xinitrc
    systemctl enable lightdm
    ;;
    4)
    echo "exec cinnamon-session" > ~/.xinitrc
     pacman -S cinnamon mdm
    systemctl enable mdm
    ;;
    5)
    echo "exec mate-session" > ~/.xinitrc
     pacman -S mate lightdm lightdm-gtk-greeter
    systemctl enable lightdm
    ;;
    6)
    echo "exec i3"  > ~/.xinitrc
    pacman -S i3 rxvt-unicode dmenu
    ;;
    7)
    echo "exec awesome"  > ~/.xinitrc
     pacman -S awesome
    ;;
    8)
    echo "exec startdde"  > ~/.xinitrc
     pacman -S deepin
    ;;
    9)
    echo "exec startlxde"  > ~/.xinitrc
     pacman -S lxdm-gtk3 lxdm
    ;;
esac