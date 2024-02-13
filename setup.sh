#!/usr/bin/env bash
cd "$(dirname "$0")"
export base="$(pwd)"
echo $base
source ./scriptdata/functions
source ./scriptdata/installers

#####################################################################################
if ! command -v pacman >/dev/null 2>&1;then printf "\e[31m[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...\e[0m\n";exit 1;fi
prevent_sudo_or_root
startask (){
printf "\e[34m[$0]: Hi there!\n"
printf 'This script 1. only works for ArchLinux and Arch-based distros.\n'
printf '            2. has not been fully tested, use at your own risk.\n'
printf "\e[31m"
printf "Please CONFIRM that you HAVE ALREADY BACKED UP \"$HOME/.config/\" and \"$HOME/.local/\" folders!\n"
printf "\e[97m"
printf "Enter capital \"YES\" (without quotes) to continue:"
read -p " " p
case $p in "YES")sleep 0;; *)exit;;esac
printf '\n'
printf 'Do you want to confirm every time before a command executes?\n'
printf '  y = Yes, ask me before executing each of them. (RECOMMENDED)\n'
printf '  n = No, just execute them automatically.\n'
printf '  a = Abort. (DEFAULT)\n'
read -p "Enter [y/n/A]: " p
case $p in
  y)ask=true;;
  n)ask=false;;
  *)exit;;
esac
}

case $1 in
  "-f")ask=false;;
  *)startask ;;
esac

set -e
#####################################################################################
printf "\e[36m[$0]: 1. Get packages and add user to video/input groups\n\e[97m"

remove_bashcomments_emptylines ./scriptdata/dependencies.conf ./cache/dependencies_stripped.conf
readarray -t pkglist < ./cache/dependencies_stripped.conf

if ! command -v yay >/dev/null 2>&1;then
  echo -e "\e[33m[$0]: \"yay\" not found.\e[0m"
  showfun install-yay
  v install-yay
fi

if $ask;then
  # execute per element of the array $pkglist
  for i in "${pkglist[@]}";do v yay -S --needed $i;done
else
  # execute for all elements of the array $pkglist in one line
  v yay -S --needed --noconfirm ${pkglist[*]}
fi

v sudo usermod -aG video,input "$(whoami)"
v hyprshade install && systemctl --user enable --now hyprshade.timer

#####################################################################################
printf "\e[36m[$0]: 2. Installing parts from source repo\e[97m\n"
sleep 1

if command -v ags >/dev/null 2>&1;then
  echo -e "\e[33m[$0]: Command \"ags\" already exists, no need to install.\e[0m"
  echo -e "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_ags=$ask
else ask_ags=true
fi
if $ask_ags;then showfun install-ags;v install-ags;fi

if $(fc-list|grep -q Rubik); then
  echo -e "\e[33m[$0]: Font \"Rubik\" already exists, no need to install.\e[0m"
  echo -e "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_Rubik=$ask
else ask_Rubik=true
fi
if $ask_Rubik;then showfun install-Rubik;v install-Rubik;fi

if $(fc-list|grep -q Gabarito); then
  echo -e "\e[33m[$0]: Font \"Gabarito\" already exists, no need to install.\e[0m"
  echo -e "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_Gabarito=$ask
else ask_Gabarito=true
fi
if $ask_Gabarito;then showfun install-Gabarito;v install-Gabarito;fi

if $(test -d /usr/local/share/icons/OneUI); then
  echo -e "\e[33m[$0]: Icon pack \"OneUI\" already exists, no need to install.\e[0m"
  echo -e "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_OneUI=$ask
else ask_OneUI=true
fi
if $ask_OneUI;then showfun install-OneUI;v install-OneUI;fi
#####################################################################################
printf "\e[36m[$0]: 3. Copying\e[97m\n"

# In case ~/.local/bin does not exists
v mkdir -p "$HOME/.local/bin" "$HOME/.local/share"

# `--delete' for rsync to make sure that
# original dotfiles and new ones in the SAME DIRECTORY
# (eg. in ~/.config/hypr) won't be mixed together

for i in .config/*
do
  echo "[$0]: Found target: $i"
  if [ -d "$i" ];then v rsync -av --delete "$i/" "$HOME/$i/"
  elif [ -f "$i" ];then v rsync -av "$i" "$HOME/$i"
  fi
done

target="$HOME/.config/hypr/colors.conf"
test -f $target || { \
  echo -e "\e[34m[$0]: File \"$target\" not found.\e[0m" && \
  v cp "$HOME/.config/hypr/colors_default.conf" $target ; }

# some foldes (eg. .local/bin) should be processed seperately to avoid `--delete' for rsync,
# since the files here come from different places, not only about one program.
for i in .local/bin .local/share/*
do
  echo "[$0]: Found target: $i"
  if [ -d "$i" ];then v rsync -av "$i/" "$HOME/$i/"
  elif [ -f "$i" ];then v rsync -av "$i" "$HOME/$i"
  fi
done

# Prevent welcome msg from popping up for the first time because it use `hyprctl keyword bind'.
# See .config/ags/services/messages.js
echo 'Just a file to confirm that you have been greeted ;)' > ~/.cache/ags/user/firstrun.txt

# Prevent hyprland from not fully loaded
sleep 2&&hyprctl reload

# Load Tilix config
v $HOME/.local/bin/tilix-dconf load
#####################################################################################
printf "\e[36m[$0]: Finished. See the \"import-manually\" folder and grab anything you need.\e[97m\n"
printf "\e[36mPress \e[30m\e[46m Super+Shift+/ \e[0m\e[36m for a list of keybinds.\e[97m\n"
printf "\e[36mEdit \e[36m\e[40m ~/.config/hypr/hyprshade.toml \e[0m\e[36m for screen shader configuration.\e[97m\n"
