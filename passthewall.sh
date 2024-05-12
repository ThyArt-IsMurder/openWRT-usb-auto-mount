#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${YELLOW} 
 _____ _____ _____ _____ _____ _____ _____ _ _ _ _____ __    __    
|  _  |  _  |   __|   __|_   _|  |  |   __| | | |  _  |  |  |  |   
|   __|     |__   |__   | | | |     |   __| | | |     |  |__|  |__ 
|__|  |__|__|_____|_____| |_| |__|__|_____|_____|__|__|_____|_____|
${NC}"

echo "Running as root..."
sleep 2
clear

### Partition and format the USB disk. ###

DISK="/dev/sda"
parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
DEVICE="${DISK}1"
mkfs.ext4 -L extroot ${DEVICE}

sleep 2

### Configure the extroot mount entry. ###

eval $(block info ${DEVICE} | grep -o -e 'UUID="\S*"')
eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
uci -q delete fstab.extroot
uci set fstab.extroot="mount"
uci set fstab.extroot.uuid="${UUID}"
uci set fstab.extroot.target="${MOUNT}"
uci commit fstab

sleep 2

### Transfer the content of the current overlay to the external drive. ###

mount ${DEVICE} /mnt
tar -C ${MOUNT} -cvf - . | tar -C /mnt -xf -

sleep 5

### Configure a mount entry for the the original overlay. ###

DEVICE="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"
uci -q delete fstab.rwm
uci set fstab.rwm="mount"
uci set fstab.rwm.device="${ORIG}"
uci set fstab.rwm.target="/rwm"
uci commit fstab


sed -i -e "/^lists_dir\s/s:/var/opkg-lists$:/usr/lib/opkg/lists:" /etc/opkg.conf
opkg update

echo -e "${GREEN}Done ! Your Router Will Be reboot After 5 Seconds ... ${NC}"

echo -e "${MAGENTA} Afshin ${NC}"
sleep 5

reboot
