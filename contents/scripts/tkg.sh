#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
tput setaf 1
echo "#############################################################"
echo "#                      TKG Scripts Tool.                    #"
echo "#                                                           #"
echo "#                For Avanced Users/Tinkerers                #"
echo "#             Who Like To Fuck Around & Find Out            #"
echo "#       No Support Whatsoever Will Be Provided by us.       #"
echo "#      Keeping PKGs Up-to-date is up to you, the user.      #"
echo "#     Freedom of Choice comes with Great Responsibility     #"
echo "#  It is Arch After-All, where Knowledge is a Super Power.  #"
echo "#############################################################"
tput sgr0
echo
echo "Hello $USER, Please Select Script To Run."
echo
echo "k. TKG Kernel Script."
echo "n. TKG nVidia-All Script."
echo
echo "Type Your Selection. Not too late to change your mind, to Exit, just close Window."
echo

while :; do

read CHOICE

case $CHOICE in

    k )
      echo
      sleep 2
      cd ~ && git clone https://github.com/Frogging-Family/linux-tkg
      cd ~/linux-tkg/ && makepkg -si
      sleep 2
      sudo rm -Rf ~/linux-tkg/
      echo
      echo "#################################"
      echo "        Done, Plz Reboot !       "
      echo "#################################"
      sleep 3
      clear && sh /usr/share/xerotool/scripts/tkg.sh

      ;;

    n )
      sleep 2
      cd ~ && git clone https://github.com/Frogging-Family/nvidia-all
      cd ~/nvidia-all/ && makepkg -si
      sleep 2
      sudo rm -Rf ~/nvidia-all/
      echo
      echo "#################################"
      echo "        Done, Plz Reboot !       "
      echo "#################################"
      sleep 3
      clear && sh /usr/share/xerotool/scripts/tkg.sh

      ;;
    
    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
