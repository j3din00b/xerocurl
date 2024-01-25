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
echo "Hello $USER, which rice would you like to apply today ?"
echo
echo "################# Rice Selector #################"
echo
echo "1. The O.G Layan Rice (DarkXero)."
echo "2. The Catppuccin Rice (Teddy)."
echo "3. The Dunes Rice (GamerKing)."
echo "4. The Nord Rice (DarkXero)."
echo "5. The Sweet Rice (Teddy)."
echo
echo "############## Ricing/Other Tweaks ##############"
echo
echo "6. Reset config back to Pure Vanilla KDE."
echo "7. Apply AppMenu Meta-Key Fix (For KDE-Plasma Only)."
echo "8. Apply Wayland Screen/Window Sharing Fix (Flatpak PKG)."
echo
echo "Type Your Selection. To Exit, just close Window."
echo

while :; do

read CHOICE

case $CHOICE in

    1 )
      echo
      echo "#################################################"
      echo "#             Applying Selected Rice            #"
      echo "#################################################"
      echo
			sleep 2
			cd ~ && git clone https://github.com/xerolinux/xero-layan-git && cd ~/xero-layan-git/ && ./install.sh
			sleep 3
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

    2 )
      echo
      echo "#################################################"
      echo "#             Applying Selected Rice            #"
      echo "#################################################"
      echo
			sleep 2
			cd ~ && git clone https://github.com/xerolinux/xero-catppuccin-git && cd ~/xero-catppuccin-git/ && ./install.sh
			sleep 3
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

    3 )
      echo
      echo "#################################################"
      echo "#             Applying Selected Rice            #"
      echo "#################################################"
      echo
			sleep 2
			cd ~ && git clone https://github.com/xerolinux/xero-dunes-git.git && cd ~/xero-dunes-git/ && ./install.sh
			sleep 3
      echo
      # Prompt the user to reboot
        tput setaf 4
        read -p "Customization Restored. Reboot recommended. Reboot now? (y/n): " reboot_response
        tput sgr0
      echo
        # Check the user's response
        if [[ $reboot_response == "y" || $reboot_response == "yes" ]]; then
          sudo reboot
        else
          echo
          echo "Please manually reboot your system to apply changes."
        fi
        exit 0

      ;;

    4 )
      echo
      echo "#################################################"
      echo "#             Applying Selected Rice            #"
      echo "#################################################"
      echo
			sleep 2
			cd ~ && git clone https://github.com/xerolinux/xero-nord-git.git && cd ~/xero-nord-git/ && ./install.sh
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

    5 )
      echo
      echo "#################################################"
      echo "#             Applying Selected Rice            #"
      echo "#################################################"
      echo
			sleep 2
			cd ~ && git clone https://github.com/xerolinux/xero-sweet-git.git && cd ~/xero-sweet-git/ && ./install.sh
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

    6 )
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

    7 )
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

    8 )
      echo
	  sleep 2
	  echo "Installing XWayland Bridge..."
	  echo
      flatpak remote-add --if-not-exists kdeapps https://distribute.kde.org/kdeapps.flatpakrepo
      sleep 3
      flatpak install org.kde.xwaylandvideobridge
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
