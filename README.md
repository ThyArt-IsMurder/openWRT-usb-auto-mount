## After Installing PASSWALL : Run this command in openwrt remote ssh
Partition and format the USB disk.
```
DISK="/dev/sda"
parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
DEVICE="${DISK}1"
mkfs.ext4 -L extroot ${DEVICE}
```


Done !
