#!/usr/bin/env bash

for i in 2 30; do
    echo -en "\033]${i};XeroLinux Toolkit\007"
done

##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
clear
tput setaf 5
echo "██╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░██╗███╗░░██╗██╗░░░██╗██╗░░██╗
╚██╗██╔╝██╔════╝██╔══██╗██╔══██╗██║░░░░░██║████╗░██║██║░░░██║╚██╗██╔╝
░╚███╔╝░█████╗░░██████╔╝██║░░██║██║░░░░░██║██╔██╗██║██║░░░██║░╚███╔╝░
░██╔██╗░██╔══╝░░██╔══██╗██║░░██║██║░░░░░██║██║╚████║██║░░░██║░██╔██╗░
██╔╝╚██╗███████╗██║░░██║╚█████╔╝███████╗██║██║░╚███║╚██████╔╝██╔╝╚██╗
╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚════╝░╚══════╝╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝"
tput sgr0
echo

aur_helpers=("yay" "paru")

aur_helper="NONE"
echo "Success AUR Helper found in " &&
echo
for i in ${aur_helpers[@]}; do
  if command -v $i; then
    aur_helper="$i"
    echo
    echo "Adding XeroLinux Repo & Installing Toolkit..."
    echo
    echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf && sudo pacman -Syy --noconfirm xlapit-cli && clear && exec /usr/bin/xero-cli
  fi
done

if [[ $aur_helper == "NONE" ]]; then
  echo "Welcome to XeroLinux Arch Toolkit install script. No AUR Helper detected, please select the one you prefer."
  echo "This will add the XeroLinux repository required to install the tool, AUR helper and much much more."
  echo ""
  echo "1 - Yay"
  echo "2 - Paru"
  echo ""
  read -p "Choose number: " number_chosen

  case $number_chosen in
    1)
      echo
      echo "###########################################"
      echo "           You Have Selected YaY           "
      echo "###########################################"
      echo
      echo "Adding XeroLinux Repository..."
      echo
      sudo cp /etc/pacman.conf /etc/pacman.conf.backup && \
      echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
      sleep 2
      echo
      echo "Installing YaY & Toolkit..."
      echo
      sudo pacman -Syy --noconfirm yay-bin xlapit-cli && yay -Y --devel --save && yay -Y --gendb
      echo
      echo "Launching toolkit..."
      clear && exec /usr/bin/xero-cli
    ;;
    2)
      echo
      echo "###########################################"
      echo "          You Have Selected Paru           "
      echo "###########################################"
      echo
      echo "Adding XeroLinux Repository..."
      echo
      sudo cp /etc/pacman.conf /etc/pacman.conf.backup && \
      echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
      sleep 2
      echo
      echo "Installing Paru & Toolkit..."
      echo
      sudo pacman -Syy --noconfirm yay-bin xlapit-cli && paru --gendb
      echo
      echo "Launching toolkit..."
      clear && exec /usr/bin/xero-cli
    ;;
    *)
      echo "Invalid option"
    ;;
  esac
fi
