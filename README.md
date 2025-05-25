# After Installing openWRT 
### 1. Plug in USB Drive to the router
![image_2024-05-12_03-41-56](https://github.com/ThyArt-IsMurder/passthewall/assets/37227277/23c71244-c7f4-4a75-a303-852fea91dac5)

### 2. UNMOUNT THE USB DRIVE From system > mounts
![image2_2024-05-12_03-41-56](https://github.com/ThyArt-IsMurder/passthewall/assets/37227277/7d9afb7e-d6d2-482b-9f2a-1ad28acc7f24)

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
😎Save opkg lists to ```/usr/lib/opkg/lists``` stored on the extroot, instead of in RAM. This makes package lists survive reboot and saves some RAM.
```
sed -i -e "/^lists_dir\s/s:/var/opkg-lists$:/usr/lib/opkg/lists:" /etc/opkg.conf
opkg update
```

# Done !

### Run this auto command (Cmmands above but automatic 😊)
```
rm -f passthewall.sh && wget https://raw.githubusercontent.com/ThyArt-IsMurder/passthewall/main/passthewall.sh && chmod 777 passthewall.sh && sh passthewall.sh 
```
![image3_2024-05-12_03-51-01](https://github.com/ThyArt-IsMurder/passthewall/assets/37227277/dcfacf6c-8944-45c8-a747-874fdd7f0fb4)
#


### compare packages
```
opkg list-installed
```
