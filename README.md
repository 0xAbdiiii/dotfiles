## Installing Packages



### Pacman
```sh
sudo pacman -Syu archlinux-xdg-menu ark bc brightnessctl btop cliphist dolphin evince fastfetch feh github-cli gnome-keyring grim hypridle hyprland hyprlock hyprpicker hyprpolkitagent imagemagick jq playerctl qt5ct qt6ct rofi satty sddm slurp starship tesseract udiskie ufw unzip uwsm vim vlc wl-clip-persist xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs
```



### Yay
```sh
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && yay -Syu auto-cpufreq visual-studio-code-bin downgrade github-desktop-bin google-chrome hyprls-git localsend-bin matugen-bin noctalia-shell spotify wlogout
```

# Arch Linux Installation
```sh
------------------Live USB------------------

1. Connecting to internet:

• iwctl station wlan0 scan
• iwctl station wlan0 connect SSID


2. Disk operations:

(i) Wiping the disk

• gdisk /dev/sda
• press x for expert mode
• press z for wiping


(ii) Partitioning

• cgdisk /dev/sda
• boot 1024MiB EF00
• swap 8GiB 8200
• root 40GiB 8300
• home 40GiB 8300
• storage (remaining) 8300


(iii) formatting

• mkfs.fat -F 32 /dev/sda1
• mkswap /dev/sda2
• swapon /dev/sda2
• mkfs.ext4 /dev/sda3
• mkfs.ext4 /dev/sda4
• mkfs.ext4 /dev/sda5


(iv) Mounting

• mount /dev/sda3 /mnt
• mkdir /mnt/boot or /mnt/efi
• mkdir /mnt/home
• mkdir /mnt/storage
• mount /dev/sda1 /mnt/boot or /mnt/efi
• mount /dev/sda4 /mnt/home
• mount /dev/sda5 /mnt/storage


4. Sorting mirror list:

• cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
• reflector --latest 20 --protocol https --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist.backup ›› /etc/pacman.d/mirrorlist


5. Installing Linux:

• pacstrap -K /mnt base linux-lts linux-lts-headers linux-firmware base-devel
• genfstab -U /mnt >> /mnt/etc/fstab


6. Chrooting:

(i) Installing essential packages
• arch-chroot /mnt
• pacman -S intel-ucode pacman-contrib nano networkmanager grub efibootmgr os-prober
• systemctl enable fstrim.timer
• systemctl enable NetworkManager.service
• nano /etc/pacman.conf (uncomment multilib)

(ii) Localization
• ln -sf /usr/share/zoneinfo/Asia/Karachi /etc/localtime
• hwclock --systohc
• nano /etc/locale.gen (en_US.UTF-8)
• locale-gen
• echo "LANG=en_US.UTF-8" ›› /etc/locale.conf

(iii) System administration
• echo empire › /etc/hostname
• passwd (root)
• useradd -m -G wheel,storage,power -s /bin/bash nightwing
• passwd nightwing
• EDITOR=nano visudo
• uncomment  %wheel
• append "Defaults rootpw" at the end


7. Installing bootloader

(i) GRUB (dual boot)
• mkdir /windows
• mount /dev/wbp /windows
• nano /etc/default/grub
• change timeout duration and OS Prober
• grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
• grub-mkconfig -o /boot/grub/grub.cfg

OR

(ii) Systemd-boot (Arch only)
• mount -t efivarfs none /sys/firmware/efi/efivars/
• ls /sys/firmware/efi/efivars/
• bootctl install
• nano /boot/loader/entries/arch.conf

--  title           Arch                --
--  linux         /vmlinuz-linux        --
--  initrd        /intel-ucode.img      --
--  initrd        /initramfs-linux.img  --

echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda3) rw" ›› /boot/loader/entries/arch.conf


8. Finishing it up
• exit
• umount -a
• reboot and you're done!!

--------------------Arch----------------------
```
