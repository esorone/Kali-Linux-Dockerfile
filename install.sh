#!/bin/bash
#
# This is script intended for provisioning vanilla Kali installation with a bunch
# of additional packages, tools and dictionaries. Basically useful for not-so-quick (+/- 4hours)
# provisioning of Kali distro intended for some heavy pentesting purposes.
# 
# Assumptions made:
#	- script must be totally non-interactive, capable of provisioning Kali system without any
#		further user interaction (especially true for apt-get Y/n prompts)
#	- issues with tool installation/setup are acceptable, after all need arise - the pentester
#		will have to carry off the setup himself
#	- issues with unavailable repositories/packages are NOT acceptable. I need to either take care of
#		keeping tools list more or less up-to-date, or to remove tool's pull down entirely from the script
#	- only tools that I've found useful at least once are landing in this script.
#
# Well, entire Kali installation assume that we are normally working as root on our Kali.
# I know that assumption sucks to its root, but I wanted to avoid every "permission denied" issue and I was too lazy
# to get it done properly as a non-root.
if [ $EUID -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# ------------------------------------------------------ 
ROOT_DIR=/root

cd $ROOT_DIR/tools

sudo apt install kali-tools-identify kali-tools-protect kali-tools-detect kali-tools-respond kali-tools-recover -y

# =======================================================================================

#reinstalling menu to get the new tools
sudo apt install --reinstall kali-menu
