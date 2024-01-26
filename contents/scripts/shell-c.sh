#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
tput setaf 3
echo "###############################################################################"
echo "#                             Shell Customization                             #"
echo "###############################################################################"
tput sgr0
echo
echo "Hello $USER, Please Select which shell you want."
echo
echo "1. Install ZSH+OMZ+Powerlevel10k."
echo "2. Install and Apply Starship Bash Prompt."
echo
echo "Type Your Selection. To Exit, just close Window."
echo

while :; do

read CHOICE

case $CHOICE in

    1 )
      echo
      echo "###########################################"
      echo "     Installing ZSH+OMZ+Powerlevel10k      "
      echo "###########################################"
      sleep 3
      sh $SCRIPTS_PATH/switch_to_zsh.sh
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0
      ;;

    2 )
      echo
      echo "###########################################"
      echo "              Starship Prompt              "
      echo "###########################################"
      sleep 3
      sudo pacman -S starship
      mkdir -p ~/.config/starship && cd ~/.config/starship
      wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/starship.toml
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
      clear && sh $0
      ;;


    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
