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
echo "#######################################################################"
echo "#          Welcome to XeroLinux Arch Toolkit install script.          #"
echo "#                                                                     #"
echo "# This will add the XeroLinux repository required to install the tool #"
echo "#     AUR helper and more. Just close window if you do not agree.     #"
echo "#######################################################################"
tput sgr0
echo

aur_helpers=("yay" "paru")

aur_helper="NONE"
for i in ${aur_helpers[@]}; do
  if command -v $i; then
    aur_helper="$i"
    echo
    echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf && sudo pacman -Syy --noconfirm xlapit-cli && clear && exec /usr/bin/xero-cli
  fi
done

if [[ $aur_helper == "NONE" ]]; then
  echo "No AUR Helper detected, required by the toolkit."
  echo ""
  echo "1 - Yay + Toolkit"
  echo "2 - Paru + Toolkit"
  echo ""
  read -p "Choose your Helper : " number_chosen

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
