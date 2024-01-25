#!/usr/bin/env bash

git_url="https://github.com/xerolinux/xerocurl"

aur_helpers=("yay" "paru")

if [[ -d $HOME/.cache/xero-curl-contents ]]; then
  cd $HOME/.cache/xero-curl-contents
  git pull origin main
  exit 0
fi

install_aur_helper () {
  cd /tmp && git clone https://aur.archlinux.org/$1.git && cd /tmp/$1 && makepkg -rsi --noconfirm && cd /tmp && rm -rf /tmp/$1
}

install_yay () {
  install_aur_helper yay-bin
  yay -Y --devel --save && yay -Y --gendb
}

install_paru () {
  install_aur_helper paru-bin
  paru --gendb
}

aur_helper="NONE"
for i in ${aur_helpers[@]}; do
  if command -v $i; then
    aur_helper="$i"
  fi
done

if [[ $aur_helper == "NONE" ]]; then
  echo "Oh shoot! No AUR helper detected! Which one would you like to install?"
  echo ""
  echo "1 - Yay"
  echo "2 - Paru"
  echo ""
  echo "Invalid input will default to Yay."
  echo ""
  read -p "Choose number: " number_chosen

  case $number_chosen in
    1)
      install_yay
    ;;
    2)
      install_paru
    ;;
    *)
      install_yay
    ;;
  esac
fi

cd $HOME

mkdir -p $HOME/.local/bin/xeroscripts > /dev/null 2>&1

cd $HOME/.cache
git clone ${git_url}.git xero-curl-contents > /dev/null 2>&1

cp ./xero-curl-contents/contents/xero-cli $HOME/.local/bin
cp ./xero-curl-contents/contents/scripts/* $HOME/.local/bin/xeroscripts
