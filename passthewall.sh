#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

echo -e "${YELLOW} 
 ____   _    ____ ____ _____ _   _ _______        ___    _     _     
|  _ \ / \  / ___/ ___|_   _| | | | ____\ \      / / \  | |   | |    
| |_) / _ \ \___ \___ \ | | | |_| |  _|  \ \ /\ / / _ \ | |   | |    
|  __/ ___ \ ___) |__) || | |  _  | |___  \ V  V / ___ \| |___| |___ 
|_| /_/   \_\____/____/ |_| |_| |_|_____|  \_/\_/_/   \_\_____|_____|

echo "Running as root..."
sleep 2
clear

### Partition and format the USB disk. ###

DISK="/dev/sda"
parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
DEVICE="${DISK}1"
mkfs.ext4 -L extroot ${DEVICE}
