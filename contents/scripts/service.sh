#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
tput setaf 3
echo "#################################################"
echo "#                  Fixes/Tweaks                 #"
echo "#################################################"
tput sgr0
echo
echo "Hello $USER, what would you like to do today ?"
echo
echo "1. Install & Activate Firewald."
echo "2. Clear Pacman Cache (Free Space)."
echo "3. Restart PipeWire/PipeWire-Pulse."
echo "4. Unlock Pacman DB (In case of DB error)."
echo "5. Activate Flatpak Theming (Required If used)."
echo "6. Fix Grub & Install the Hooks (XeroLinux Repo)."
echo "7. Activate OS-Prober to detect for Dual-Booting."
echo
echo "Type Your Selection. To Exit, just close Window."
echo

while :; do

read CHOICE

case $CHOICE in

    1 )
      echo
	  sleep 2
      sudo pacman -S --needed --noconfirm firewalld python-pyqt5 python-capng
      sudo systemctl enable --now firewalld.service
      sleep 2
      echo
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;

    2 )
      echo
	  sleep 2
      sudo pacman -Scc
      sleep 2
      echo
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;


    3 )
      echo
	  sleep 2
	  echo "#################################"
      echo "       Restarting PipeWire       "
      echo "#################################"
      sleep 1.5
      systemctl --user restart pipewire
      systemctl --user restart pipewire-pulse
      sleep 1.5
      echo
      echo "#################################"
      echo "        All Done, Try now       "
      echo "#################################"
	  sleep 2
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;


    4 )
      echo
	  sleep 2
	  sudo rm /var/lib/pacman/db.lck
	  sleep 2
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;


    5 )
      echo
	  sleep 2
	  echo "#####################################"
      echo "#    Activating Flatpak Theming.    #"
      echo "#####################################"
      sleep 3
      sudo flatpak override --filesystem=$HOME/.themes
      sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
      sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
      sleep 2
      echo
      echo "#####################################"
      echo "#     Flatpak Theming Activated     #"
      echo "#####################################"
	  sleep 3
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;

    6 )
      echo
	  sleep 2
	  echo "Fixing Grub, simply coz ArchInstall is doing it wrong..."
	  echo
	  sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch --recheck --force
	  echo
	  echo "Installing Hooks..."
	  echo
      sudo pacman -S grub-hooks xero-hooks
      sleep 2
      echo
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;

    7 )
      echo
	  sleep 2
	  echo "#####################################"
      echo "#   Activating OS-Prober in Grub.   #"
      echo "#####################################"
      sleep 3
      sudo sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' '/etc/default/grub'
      sudo os-prober
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      sleep 2
      echo
      echo "#####################################"
      echo "#     Flatpak Theming Activated     #"
      echo "#####################################"
	  sleep 3
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;
        
    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
