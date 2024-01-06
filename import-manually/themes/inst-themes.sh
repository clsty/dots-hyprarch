#!/bin/bash
echo -e "This script will install sweet themes for Kvantum(qt) and gtk, and papirus icons."

printf '\e[31m'
echo -e "WARNING 1: Some files in your computer may be OVERWRITTEN!"
echo -e "WARNING 2: Uninstallation script is not provided, so you'll have to delete files by hand if you want to."
printf '\e[0m'
printf '\e[32m'
echo -e "CLARIFICATION: The author of this script is NOT related with the authors of sweet themes and papirus icons."
printf '\e[0m'

printf '\e[31m'
echo -e "You MUST fully understand what this script will do by reading the script"
echo -e "and use it at your own risk before you continue!"
read -p "Continue? [y/N]" p
printf '\e[0m'

case $p in
  [yY])echo -e "Okay, let's do it!";;
  *)echo -e "Aborting...";exit;;
esac
# ==================================================

selfpath="${BASH_SOURCE[0]}"
cd "$(dirname $selfpath)"
basedir="$(pwd)"

set -e
function try { "$@" || sleep 0; }
function aaa { while true;do if "$@";then break;else echo "!! Retrying \"$@\"";sleep 1;fi;done; }

ppsweet(){
  echo "Preparing sweet theme..."
  target="$basedir"/cache/sweet-theme-backup

  mkdir -p "$target";cd "$target"
  try git init -b main
  try git remote add origin https://github.com/clsty/sweet-theme-backup.git
  git pull --depth=1 origin main

  echo "Done with preparing sweet theme."
}

ppicons(){
  echo "Preparing icons..."
  target="$basedir"/cache/icons/papirus-icon-theme

  mkdir -p "$target";cd "$target"
  try git init -b master
  try git remote add origin https://github.com/clsty/papirus-icon-theme.git
  git pull --depth=1 origin master
  echo "Done with preparing icons."
}

aaa ppsweet
aaa ppicons
# ==================================================
cache="$basedir"/cache
sweet="$cache/sweet-theme-backup"
share="/usr/share"

sudo mkdir -p $share/icons
sudo mkdir -p $share/themes/sweet
sudo mkdir -p $share/Kvantum
sudo mkdir -p $share/color-schemes

sudo rsync -av --delete $cache/icons/papirus-icon-theme/Papirus/ $share/icons/Papirus/
sudo rsync -av --delete $cache/icons/papirus-icon-theme/Papirus-Dark/ $share/icons/Papirus-Dark/

# Don't forget backslash in the end of every directory path.
for i in $(cat<<EOF
/icons/Sweet-cursors/
/themes/sweet/index.theme
/themes/sweet/assets/
/themes/sweet/gtk-2.0/
/themes/sweet/gtk-3.0/
/themes/sweet/gtk-4.0/
/Kvantum/Sweet-transparent-toolbar/
/Kvantum/Sweet-transparent-toolbar/
/color-schemes/Sweet.colors
EOF
)
do sudo rsync -av --delete $sweet/"$i" $share/"$i"
done
# ==================================================

cd $basedir
rsync -av per-user/ $HOME/

sudo pacman -S --noconfirm --needed qt5ct qt6ct kvantum

printf '\e[36m'
echo -e "Theme installation script done!"
echo -e "You may optionally install \"nwg-look\" or \"nwg-look-bin\" from AUR for futher gtk theme configuring."
printf '\e[0m'
