#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
tput setaf 3

echo "#################################################"
echo "#          The XeroLinux Rice Installer         #"
echo "#      The Following Script is for KDE Only     #"
echo "#################################################"
tput sgr0
echo
echo "Hello $USER, please select a rice to apply..."
echo
echo "#################################################"
echo "#             Currently Unavailable.            #"
echo "#      In Process Of Migrating to Plasma 6      #"
echo "#################################################"
echo
echo "################# Ricing Tweaks #################"
echo
echo "r. Reset config back to Pure Vanilla KDE."
echo "m. Apply AppMenu Meta-Key Fix (For KDE-Plasma Only)."
echo "w. Apply xWayland Screen/Window Sharing Fix (xWaylandVideoBridge)."
echo
echo "Type Your Selection. To Exit, just close Window."
echo

while :; do

read CHOICE

case $CHOICE in

    r )
      echo
      echo "#################################################"
      echo "#            Resetting to Vanilla KDE           #"
      echo "#                                               #"
      echo "#     Warning, will undo current settings !     #"
      echo "# This will revert settings to Pure Vanilla KDE #"
      echo "#################################################"
      echo
			sleep 6
			cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && rm -Rf ~/.config/
			sudo sed -i "s/GRUB_THEME/#GRUB_THEME/g" /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
			sleep 3
			echo
        # Prompt the user to reboot
        tput setaf 4
        read -p "Customization Restored. Reboot recommended. Reboot now? (y/n): " reboot_response
        tput setaf 0
         echo
        # Check the user's response
        if [[ $reboot_response == "y" || $reboot_response == "yes" ]]; then
          sudo reboot
        else
          echo
          tput setaf 4
          echo "Please manually reboot your system to apply changes."
          tput sgr0
        fi
        exit 0

      ;;

    m )
      echo
	  sleep 2
	  echo "Applying Meta-Key AppMenu fix..."
      echo
      kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
      sleep 3
      echo "Relaunching Kwin..."
      qdbus org.kde.KWin /KWin reconfigure
      echo
      echo "All done, should work now !"
	  sleep 3
      clear && sh /usr/share/xerotool/scripts/xero_rices.sh

      ;;

    w )
      echo
	  sleep 2
	  echo "Installing XWayland Bridge..."
	  echo
      sleep 3
      sudo pacman -S --noconfirm xwaylandvideobridge
      echo
      sleep 2
      echo "All done, please reboot for good measure !"
	  sleep 3
      clear && sh /usr/share/xerotool/scripts/xero_rices.sh

      ;;
    
    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
