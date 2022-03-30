
MODE=$([ -d /sys/firmware/efi ] && echo UEFI || echo BIOS)
if [ $MODE == UEFI ]; then
    mkfs.fat -F32 /dev/sda1
else
  mkfs.ext4 /dev/sda1 
fi
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda2 /mnt && mkdir /mnt/home/ && mount /dev/sda3 /mnt/home
pacstrap -i /mnt base linux linux-firmware sudo nano --noconfirm
genfstab -U -p /mnt >> /mnt/etc/fstab
chmod +x nastavak.sh
cp nastavak.sh /mnt/
arch-chroot /mnt /bin/bash && ./nastavak.sh
