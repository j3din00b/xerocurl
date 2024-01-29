#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 1
echo "####################################################################################"
echo "#                               Virtualization Tools                               #"
echo "####################################################################################"
tput sgr0
echo
echo "Hello $USER, Please Select Which VM tool to Install (Req. XeroLinux Repo)."
echo
echo "v. VirtualBox (Full)."
echo "k. Virt-Manager (QEMU/KVM)."
echo
echo "Type Your Selection. Or type q to return to main menu."
echo

while :; do

read CHOICE

case $CHOICE in

    v )
      echo
      sleep 2
      sudo pacman -S virtualbox-meta
      sleep 2
      echo
      echo "#################################"
      echo "        Done, Plz Reboot !       "
      echo "#################################"
      sleep 3
      clear && sh $0

      ;;

    k )
      sleep 2
      sudo pacman -S virt-manager-meta
      sleep 3
      echo
      echo "####################################"
      echo "       Done, Plz Reboot & Run       "
      echo "    sudo virsh net-start default    "
      echo "  sudo virsh net-autostart default  "
      echo "####################################"
      sleep 7
      clear && sh $0

      ;;
    
    q )
      clear && exec ~/.local/bin/xero-cli

      ;;

    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
