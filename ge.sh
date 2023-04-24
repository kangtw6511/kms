#!/bin/bash

# 파티션 정보를 확인합니다.
echo "파티션 정보를 확인합니다..."
fdisk -l

# 파티션을 생성합니다.
echo "파티션을 생성합니다..."
parted -a optimal /dev/sda mklabel msdos
parted -a optimal /dev/sda mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sda1

# 젠투 리눅스를 설치합니다.
echo "젠투 리눅스를 설치합니다..."
mount /dev/sda1 /mnt/gentoo
cd /mnt/gentoo
wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-20230423T214502Z.tar.xz
tar xvf stage3*
rm stage3*
wget http://distfiles.gentoo.org/releases/snapshots/current/portage-latest.tar.xz
tar xvf portage*
rm portage*
cp /etc/resolv.conf /mnt/gentoo/etc/
mount -t proc none /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
chroot /mnt/gentoo /bin/bash
env-update && source /etc/profile
echo "Asia/Seoul" > /etc/timezone
emerge-webrsync
emerge --sync
eselect profile set 1
emerge --ask --verbose --update --deep --newuse @world
emerge --ask --verbose sys-kernel/gentoo-sources
emerge --ask --verbose sys-kernel/linux-firmware
emerge --ask --verbose sys-apps/util-linux
emerge --ask --verbose sys-fs/e2fsprogs
emerge --ask --verbose sys-fs/btrfs-progs
emerge --ask --verbose sys-fs/dosfstools
emerge --ask --verbose sys-fs/eudev
emerge --ask --verbose sys-fs/lvm2
emerge --ask --verbose sys-fs/mdadm
emerge --ask --verbose net-misc/dhcpcd
emerge --ask --verbose net-misc/ntp
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
eselect locale set 3
env-update && source /etc/profile
echo "hostname=\"gentoo\"" > /etc/conf.d/hostname
emerge --ask --verbose net-misc/netifrc
cd /etc/init.d/
ln -s net.lo net.eth0
rc-update add net.eth0 default
passwd
exit

# 설치 완료 메시지를 표시합니다.
echo "젠투 리눅스 설치가 완료되었습니다. 컴퓨터를 재부팅하세요."
