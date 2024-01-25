#!/bin/bash
#set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	DarkXero
# Website 	: 	http://xerolinux.xyz
##################################################################################################################
tput setaf 5
echo "############################################################################"
echo "#                           Initial System Setup                           #"
echo "############################################################################"
tput sgr0
echo
echo "Hello $USER, Please Select What To Do."
echo
echo "############ Initial Setup Section ############"
echo
echo "x.  Activate XeroLinux Repo."
echo "b.  Install & Activate Bluetooth (Bluez)."
echo "p.  Install Essential System Packages (Native & AUR)."
echo "f.  Add & Activate Flathub Repositories (Req. for OBS)."
echo
echo "############ System Update Section ############"
echo
echo "1.  Update Arch & A.U.R Packages (Step 'p' Needed)."
echo "2.  Update Flatpak Packages Only (Step 'f' Needed)."
echo
echo "Type Your Selection. To Exit, just close Window."
echo

while :; do

read CHOICE

case $CHOICE in

    x )
      echo
      echo "###########################################"
      echo "             Adding & Xero Repo            "
      echo "###########################################"
      sleep 3
      sudo cp /etc/pacman.conf /etc/pacman.conf.backup && \
      echo -e '\n[xero-repo]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | sudo tee -a /etc/pacman.conf
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh /usr/share/xerotool/scripts/tool_init.sh
      ;;

    b )
      echo
	  sleep 2
	  echo "#################################"
      echo "       Installing & Activating Bluetooth       "
      echo "#################################"
      sleep 1.5
      sudo pacman -S --needed --noconfirm bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools
      sudo systemctl enable --now  bluetooth.service
      sleep 1.5
      echo
      echo "#################################"
      echo "        All Done, Try now       "
      echo "#################################"
	  sleep 2
      clear && sh /usr/share/xerotool/scripts/service.sh

      ;;
    
    p )
      echo
      echo "###########################################"
      echo "           Installing Packages          "
      echo "###########################################"
      sleep 3
      echo
      echo "Step 1 - Installing Audio Server/Codec Packages."
      echo
      sudo pacman -S --noconfirm --needed gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugins-good gst-plugin-pipewire libdvdcss alsa-utils wireplumber alsa-firmware  pipewire-jack pavucontrol lib32-pipewire-jack pipewire libpipewire  pipewire-alsa pipewire-pulse pipewire-v4l2 pipewire-x11-bell pipewire-zeroconf  realtime-privileges sof-firmware ffmpeg ffmpegthumbs ffnvcodec-headers mesa-utils #> /dev/null 2>&1
      echo
      sudo usermod -aG realtime $(whoami)
      sleep 3
      echo
      echo "Step 2 - Installing Extra Input Tools."
      echo
      sudo pacman -S --noconfirm --needed piper gestures xf86-input-void xf86-input-evdev iio-sensor-proxy libinput-gestures xf86-input-libinput xf86-input-synaptics xf86-input-elographics > /dev/null 2>&1
      sleep 3
      echo "Step 3 - Installing Extra Networking & VPN Tools."
      echo
      sudo pacman -S --noconfirm --needed broadcom-wl avahi netctl openldap smbclient net-tools openresolv traceroute nm-cloud-setup wireless-regdb wireless_tools wpa_supplicant networkmanager-vpnc networkmanager-pptp networkmanager-l2tp network-manager-sstp network-manager-applet networkmanager-openvpn networkmanager-strongswan networkmanager-openconnect mobile-broadband-provider-info > /dev/null 2>&1
      sleep 3
      echo "Step 4 - Installing Extra Quality of Life Tools."
      echo
      sudo pacman -S --noconfirm --needed eza numlockx lm_sensors appstream-glib bat bat-extras neofetch fastfetch pacman-contrib pacman-bintrans pacman-mirrorlist yt-dlp gnustep-base parallel dex bash make libxinerama bash-completion gtk-update-icon-cache gnome-disk-utility appmenu-gtk-module dconf-editor dbus-python lsb-release asciinema playerctl s3fs-fuse vi duf gcc git yad zip xdo inxi meld lzop nmon tree vala btop lshw expac fuse3 meson unace unrar unzip p7zip rhash sshfs vnstat nodejs cronie hwinfo arandr assimp netpbm wmctrl grsync libmtp polkit sysprof gparted hddtemp mlocate fuseiso gettext node-gyp graphviz inetutils appstream cifs-utils ntfs-3g nvme-cli exfatprogs f2fs-tools man-db man-pages tldr > /dev/null 2>&1
      sleep 3
      echo "Step 5 - Installing VIM Incl. Plugins."
      echo
      sudo pacman -S --noconfirm --needed vim vim-align vim-csound vim-pastie vim-runtime vim-nerdtree vim-supertab vim-syntastic vim-gitgutter vim-bufexplorer vim-editorconfig vim-nerdcommenter vim-coverage-highlight #> /dev/null 2>&1
      sleep 3
      echo "Step 6 - Installing some useful/recommended tools from the AUR (Step a. is required/Might take a while)."
      echo
      $AUR_HELPER -S --noconfirm downgrade yt-dlg libadwaita-without-adwaita-git mkinitcpio-firmware hw-probe pkgstats alsi
      sleep 3
      echo
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh /usr/share/xerotool/scripts/tool_init.sh
      ;;

    f )
      echo
      echo "##########################################"
      echo "       Adding & Activating Flatpaks       "
      echo "##########################################"
      sleep 3
      echo
      sudo pacman -S --noconfirm flatpak
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh /usr/share/xerotool/scripts/tool_init.sh
      ;;

    1 )
      echo
      echo "##########################################"
      echo "       Updating Arch & AUR Packages       "
      echo "##########################################"
      sleep 3
      echo
      $AUR_HELPER -Syyu
      sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh /usr/share/xerotool/scripts/tool_init.sh
      ;;

    3 )
      echo
      echo "##########################################"
      echo "        Updating Flatpak Packages         "
      echo "##########################################"
			sleep 3
			echo
			flatpak update
			sleep 3
      echo "#######################################"
      echo "                 Done !                "
      echo "#######################################"
            clear && sh /usr/share/xerotool/scripts/tool_init.sh
      ;;

    * )
      echo "#################################"
      echo "    Choose the correct number    "
      echo "#################################"
      ;;
esac
done
