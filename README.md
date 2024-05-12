# After Installing PASSWALL 
### 1. Plug in USB Drive to the router
### 2. UNMOUNT THE USB DRIVE From passwall > system > mounts
### 3. Run commands below in openwrt remote ssh.
#
### Partition and format the USB disk.
```
DISK="/dev/sda"
parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
DEVICE="${DISK}1"
mkfs.ext4 -L extroot ${DEVICE}
```

### Configure the extroot mount entry.
```
eval $(block info ${DEVICE} | grep -o -e 'UUID="\S*"')
```
```
eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
```
```
uci -q delete fstab.extroot
uci set fstab.extroot="mount"
uci set fstab.extroot.uuid="${UUID}"
uci set fstab.extroot.target="${MOUNT}"
uci commit fstab
```

### Transfer the content of the current overlay to the external drive.
```
mount ${DEVICE} /mnt
```
```
tar -C ${MOUNT} -cvf - . | tar -C /mnt -xf -
```

### Configure a mount entry for the the original overlay.
```
DEVICE="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"
```
```
uci -q delete fstab.rwm
uci set fstab.rwm="mount"
uci set fstab.rwm.device="${DEVICE}"
uci set fstab.rwm.target="/rwm"
uci commit fstab
```

### Reboot the device to apply the changes.
```
reboot
```

### Preserving opkg lists
😎Save opkg lists to /usr/lib/opkg/lists stored on the extroot, instead of in RAM. This makes package lists survive reboot and saves some RAM.
```
sed -i -e "/^lists_dir\s/s:/var/opkg-lists$:/usr/lib/opkg/lists:" /etc/opkg.conf
opkg update
```

# Done !

### Run this auto command (Cmmands above but automatic 😊)
```
rm -f passthewall.sh && wget https://raw.githubusercontent.com/ThyArt-IsMurder/passthewall/main/passthewall.sh && chmod 777 passthewall.sh && sh passthewall.sh 
```
