pacstrap -i /mnt base linux linux-firmware sudo nano --noconfirm
genfstab -U -p /mnt >> /mnt/etc/fstab
cp nastavak.sh /mnt/
arch-chroot /mnt /bin/bash
chmod +x nastavak.sh
./nastavak.sh
