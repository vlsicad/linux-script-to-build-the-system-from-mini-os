#!/bin/bash
echo "os-live" > /etc/hostname
apt-get install \
	    --no-install-recommends \
	    --yes \
	    --force-yes \
            linux-image-4.4.0-21-generic

#apt-get install --no-install-recommends --yes --force-yes \

apt-get install \
network-manager \
net-tools \
wireless-tools \
wpagui \
tcpdump \
wget \
openssh-client \
xserver-xorg-core \
xserver-xorg xinit \
xserver-xorg-legacy \
xterm \
pciutils \
usbutils \
gparted \
ntfs-3g \
hfsprogs \
rsync \
dosfstools \
syslinux \
partclone \
nano \
pv \
rtorrent \
chntpw \
tint2 \
nitrogen \
xcompmgr \
openbox \
leafpad \
lxpanel \
lxtask \
lxappearance \
pcmanfm \
volti \
pavucontrol \
terminator \
lxpanel \
viewnior \
ark \
xarchiver \
lxrandr \
galculator \
obmenu 

firefox \
ubuntu-wallpapers \
vlc \
indicator-applet-complete \
language-pack-en

locale-gen en_US.UTF-8

mkdir -pv /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf <<EOL
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin user --noclear tty1 38400 
EOL

useradd -m user
passwd user

cat >  /home/user/.bash_profile <<EOL
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
EOL

systemctl enable getty@tty1.service

passwd root


