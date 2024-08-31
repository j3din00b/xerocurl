#!/usr/bin/env bash

for i in 2 30; do
    echo -en "\033]${i};XeroLinux Toolkit\007"
done

##################################################################################################################
# Written to be used on 64 bits computers
# Author   :   DarkXero
# Website  :   http://xerolinux.xyz
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

# Check if figlet is installed; if not, install it
if ! command -v figlet &> /dev/null; then
  echo "Figlet not found, installing it..."
  sudo pacman -S --noconfirm figlet
fi

source /etc/os-release

rerun_script="1" # Initialize a variable to control the loop

while [[ "$rerun_script" == "1" ]]; do
  if [ "$ID" != "arch" ] && [ "$ID" != "XeroLinux" ]; then
    # Display the message with color
    clear           # Clear the terminal window

    # Use figlet to create large ASCII text for the main message
    figlet -c "Invalid Distro Plz use with"

    # Set colors for "Vanilla Arch" and "XeroLinux"
    tput bold
    tput setaf 2  # Set text color to green for "Vanilla Arch"
    figlet -c "Vanilla Arch"

    tput setaf 4  # Set text color to blue for "&"
    tput bold
    figlet -c "& XeroLinux"

    # Reset all attributes
    tput sgr0

    # Wait for user to press ENTER
    read -p "Press ENTER to quit... " # Wait for user input
    rerun_script="0" # Exit loop after user presses Enter
  else
    # If the distro is compatible, exit the loop
    rerun_script="0"
  fi
done

aur_helpers=("yay" "paru")
echo

# Function to add the XeroLinux repository if not already added
add_xerolinux_repo() {
    if ! grep -q "\[xerolinux\]" /etc/pacman.conf; then
        echo "Adding XeroLinux Repository..."
        echo
        echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
        sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
    else
        echo
        echo "XeroLinux Repository already added."
        echo
    fi
}

# Function to install and start the toolkit
install_and_start_toolkit() {
    sudo pacman -Syy --noconfirm xlapit-cli && clear && exec /usr/bin/xero-cli -m
}

aur_helper="NONE"
for helper in "${aur_helpers[@]}"; do
    if command -v "$helper" &> /dev/null; then
        aur_helper="$helper"
        echo
        echo "AUR Helper detected, shall we proceed?"
        echo ""
        echo "y. Yes Please."
        echo "n. No thank you."
        echo ""
        echo "Type y or n to continue."
        echo ""

        read -rp "Enter your choice: " CHOICE

        case $CHOICE in
            y)
                add_xerolinux_repo
                install_and_start_toolkit
                ;;
            n)
                exit 0
                ;;
            *)
                echo "Invalid choice."
                exit 1
                ;;
        esac
    fi
done

if [[ $aur_helper == "NONE" ]]; then
    echo
    echo "No AUR Helper detected, required by the toolkit."
    echo ""
    echo "1 - Yay + Toolkit"
    echo "2 - Paru + Toolkit"
    echo ""
    read -rp "Choose your Helper: " number_chosen

    case $number_chosen in
        1)
            echo
            echo "###########################################"
            echo "           You Have Selected YaY           "
            echo "###########################################"
            add_xerolinux_repo
            echo
            echo "Installing YaY & Toolkit..."
            echo
            sudo pacman -Syy --noconfirm yay-bin xlapit-cli && yay -Y --devel --save && yay -Y --gendb
            install_and_start_toolkit
            ;;
        2)
            echo
            echo "###########################################"
            echo "          You Have Selected Paru           "
            echo "###########################################"
            add_xerolinux_repo
            echo
            echo "Installing Paru & Toolkit..."
            echo
            sudo pacman -Syy --noconfirm paru-bin xlapit-cli && paru --gendb
            install_and_start_toolkit
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
fi
