#!/bin/bash
# Create a directory for the live environment.
mkdir -p $HOME/nosub

sudo debootstrap \
    --arch=i386 \
    --variant=buildd \
    xenial $HOME/nosub/chroot \
   http://archive.ubuntu.com/ubuntu/

sudo chroot $HOME/nosub/chroot

	echo "os-live" > /etc/hostname
	
	apt-get update && \
	apt-get install \
	    --no-install-recommends \
	    --yes \
	    --force-yes \
            linux-image-4.4.0-92-generic \
	    live-boot \
	    systemd-sysv
	
	exit

apt-get install --no-install-recommends --yes --force-yes \
    network-manager net-tools wireless-tools wpagui \
    tcpdump wget openssh-client \
    blackbox xserver-xorg-core xserver-xorg xinit xterm \
    pciutils usbutils gparted ntfs-3g hfsprogs rsync dosfstools \
    syslinux partclone nano pv \
    rtorrent iceweasel chntpw && \
apt-get clean

apt-get install --no-install-recommends --yes --force-yes \
    xserver-xorg-core xserver-xorg xinit xterm \
    pciutils usbutils 

sudo mkdir -p $HOME/live_boot/chroot/var/cache/apt/fornewos

sudo cp $HOME/Documents/fornewos/* $HOME/live_boot/chroot/var/cache/apt/fornewos/

	sudo chroot $HOME/live_boot/chroot
	
	cd /var/cache/apt/fornewos/
	
	dpgk -i ./*.deb
	apt-get install -f
	
	exit

mkdir -p $HOME/nos/image/{live,isolinux}

(cd $HOME/nos && \
    sudo mksquashfs chroot image/live/filesystem.squashfs -e boot
)


(cd $HOME/nos && \
    cp chroot/boot/vmlinuz-4.9.0-3-686 image/live/vmlinuz1
    cp chroot/boot/initrd.img-4.9.0-3-686 image/live/initrd1
)

#cp $HOME/isolinux.cfg $HOME/nos/image/isolinux/isolinux.cfg

(cd $HOME/nos/image/ && \
    cp /usr/lib/ISOLINUX/isolinux.bin isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/menu.c32 isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/hdt.c32 isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/ldlinux.c32 isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/libutil.c32 isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/libmenu.c32 isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/libcom32.c32 isolinux/ && \
    cp /usr/lib/syslinux/modules/bios/libgpl.c32 isolinux/ && \
    cp /usr/share/misc/pci.ids isolinux/ && \
    cp /boot/memtest86+.bin live/memtest
)

(cd $HOME/nos && \
    sudo mksquashfs chroot image/live/filesystem.squashfs -e boot
)


genisoimage \
    -rational-rock \
    -volid "os-live" \
    -cache-inodes \
    -joliet \
    -hfs \
    -full-iso9660-filenames \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -output /pcshare/noslx.iso \
    $HOME/nos/image

--------------------------------------
This is kind of a "Part 2" video which makes an even more barebones GUI system by not installing a desktop manager. 
Annotations will tell you where to skip to if you want to skip some parts. 
The autologin stuff I did is below for you to copy and paste: 

sudo mkdir -pv /etc/systemd/system/getty@tty1.service.d/ 
sudo nano /etc/systemd/system/getty@tty1.service.d/autologin.conf 

In the autologin.conf file, put the following: 

[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin *USERNAME* --noclear tty1 38400 

Then enable the service with this: 

sudo systemctl enable getty@tty1.service 

Now edit/create the following file: 

sudo nano ~/.bash_profile 

And put this text in it: 

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

----------------------------------------------------------------
Doriandotslash
Published on Dec 19, 2016
Use a basic Linux base and install some packages to make a desktop however you want.  See my other videos on further customization! 
(CLICK \/ SHOW MORE \/ FOR A LIST OF COMMANDS!)

The base Ubuntu I installed is the Ubuntu MinimalCD.  You can find the ISO here:
https://help.ubuntu.com/community/Ins...

To install all the packages I'm using "sudo apt install" and the packages I install, in the order I install them are:

lightdm
openbox-gnome-session
openbox
gnome-terminal
obmenu
gedit
tint2
docky
nitrogen
ubuntu-wallpapers
pcmanfm
lxappearance
xcompmgr
firefox
pavucontrol
volti
gconf-editor

The file you want to create/edit for openbox autostart commands is located at ~/.config/openbox/autostart.sh

The file you want to create/edit to automatically login is located at /etc/lightdm/lightdm.conf
(Must be root to edit/create this file). 

https://www.youtube.com/watch?v=IuxhEbzPMVk for screen prob

apt-get install xserver-xorg-input-all 
xserver-xorg-input-libinput
