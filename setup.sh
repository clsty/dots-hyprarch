#!/usr/bin/env bash
cd "$(dirname "$0")"
export base="$(pwd)"

source ./scriptdata/functions
source ./scriptdata/installers
source ./scriptdata/options

#####################################################################################
if ! command -v pacman >/dev/null 2>&1;then
  C_R;printf "pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...";C_X;P_EOL;exit 1;fi
prevent_sudo_or_root
startask (){
C_B;P_BGN;printf "Hi there!";P_EOL
printf "This script 1. only works for ArchLinux and Arch-based distros.";P_EOL
printf "            2. has not been fully tested, use at your own risk.";P_EOL
C_R;printf "Please CONFIRM that you HAVE ALREADY BACKED UP \"$HOME/.config/\" and \"$HOME/.local/\" folders!";P_EOL;C_X
printf "Enter capital \"YES\" (without quotes) to continue:"
read -p " " p
case $p in "YES")sleep 0;; *)exit;;esac
P_EOL
printf 'Do you want to confirm every time before a command executes?';P_EOL
printf '  y = Yes, ask me before executing each of them. (RECOMMENDED)';P_EOL
printf '  n = No, just execute them automatically.';P_EOL
printf '  a = Abort. (DEFAULT)';P_EOL
read -p "Enter [y/n/A]: " p
case $p in
  y)ask=true;;
  n)ask=false;;
  *)exit;;
esac
}

case $ask in
  false)sleep 0;;
  *)startask ;;
esac

set -e
#####################################################################################
C_C;P_BGN;printf "1. Get packages and add user to video/input groups.";P_EOL;C_X

remove_bashcomments_emptylines ./scriptdata/dependencies.conf ./cache/dependencies_stripped.conf
readarray -t pkglist < ./cache/dependencies_stripped.conf

if ! command -v yay >/dev/null 2>&1;then
  if ! command -v paru >/dev/null 2>&1;then
    printf "\e[33m[$0]: \"yay\" not found.\e[0m"
    showfun install-yay
    v install-yay
    AUR_HELPER=yay
  else
    printf "\e[33m[$0]: \"yay\" not found, but \"paru\" found.\e[0m"
    printf "\e[33mIt is not recommended to use \"paru\" as warned in Hyprland Wiki:\e[0m"
    printf "\e[33m    \"If you are using the AUR (hyprland-git) package, you will need to cleanbuild to update the package. Paru has been problematic with updating before, use Yay.\"\e[0m"
    printf "\e[33mReference: https://wiki.hyprland.org/FAQ/#how-do-i-update\e[0m"
    if $ask;then
      printf "Install \"yay\"?";P_EOL
      printf "  y = Yes, install \"yay\" for me first. (DEFAULT)";P_EOL
      printf "  n = No, use \"paru\" at my own risk.";P_EOL
      printf "  a = Abort.";P_EOL
      sleep 2
      read -p "====> " p
      case $p in
        [Nn]) AUR_HELPER=paru;;
        [Aa]) printf "\e[34mAlright, aborting...\e[0m";exit 1;;
        *) v paru -S --needed --noconfirm yay-bin;
           AUR_HELPER=yay;;
      esac
    else
      AUR_HELPER=paru
    fi
  fi
else AUR_HELPER=yay
fi

if $ask;then
  # execute per element of the array $pkglist
  for i in "${pkglist[@]}";do v $AUR_HELPER -S --needed $i;done
else
  # execute for all elements of the array $pkglist in one line
  v $AUR_HELPER -S --needed --noconfirm ${pkglist[*]}
fi

v sudo usermod -aG video,input "$(whoami)"
v hyprshade install && systemctl --user enable --now hyprshade.timer
sudo systemctl enable --now clightd

#####################################################################################
printf "\e[36m[$0]: 2. Installing parts from source repo";P_EOL;C_X
sleep 1

if command -v ags >/dev/null 2>&1;then
  printf "\e[33m[$0]: Command \"ags\" already exists, no need to install.\e[0m"
  printf "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_ags=$ask
else ask_ags=true
fi
if $ask_ags;then showfun install-ags;v install-ags;fi

if $(fc-list|grep -q Rubik); then
  printf "\e[33m[$0]: Font \"Rubik\" already exists, no need to install.\e[0m"
  printf "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_Rubik=$ask
else ask_Rubik=true
fi
if $ask_Rubik;then showfun install-Rubik;v install-Rubik;fi

if $(fc-list|grep -q Gabarito); then
  printf "\e[33m[$0]: Font \"Gabarito\" already exists, no need to install.\e[0m"
  printf "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_Gabarito=$ask
else ask_Gabarito=true
fi
if $ask_Gabarito;then showfun install-Gabarito;v install-Gabarito;fi

if $(test -d /usr/local/share/icons/OneUI); then
  printf "\e[33m[$0]: Icon pack \"OneUI\" already exists, no need to install.\e[0m"
  printf "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_OneUI=$ask
else ask_OneUI=true
fi
if $ask_OneUI;then showfun install-OneUI;v install-OneUI;fi

if $(test -d /usr/local/share/icons/Bibata-Modern-Classic); then
  printf "\e[33m[$0]: Cursor theme \"Bibata-Modern-Classic\" already exists, no need to install.\e[0m"
  printf "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_bibata=$ask
else ask_bibata=true
fi
if $ask_bibata;then showfun install-bibata;v install-bibata;fi

if command -v LaTeX >/dev/null 2>&1;then
  printf "\e[33m[$0]: Program \"MicroTeX\" already exists, no need to install.\e[0m"
  printf "\e[34mYou can reinstall it in order to update to the latest version anyway.\e[0m"
  ask_MicroTeX=$ask
else ask_MicroTeX=true
fi
if $ask_MicroTeX;then showfun install-MicroTeX;v install-MicroTeX;fi

#####################################################################################
printf "\e[36m[$0]: 3. Copying";P_EOL;C_X

# In case some folders does not exists
v mkdir -p "$HOME"/.{config,cache,local/{bin,share}}

# `--delete' for rsync to make sure that
# original dotfiles and new ones in the SAME DIRECTORY
# (eg. in ~/.config/hypr) won't be mixed together


# For .config/* but not AGS/Hyprland
for i in $(find .config/ -mindepth 1 -maxdepth 1 ! -name 'ags' ! -name 'hypr' -exec basename {} \;); do
  i=".config/$i"
  P_BGN;printf "Found target: %s" "$i";P_EOL
  if [ -d "$i" ];then v rsync -av --delete "$i/" "$HOME/$i/"
  elif [ -f "$i" ];then v rsync -av "$i" "$HOME/$i"
  fi
done

# For AGS
v rsync -av --delete --exclude '/user_options.js' .config/ags/ "$HOME"/.config/ags/
t="$HOME/.config/ags/user_options.js"
if [ -f $t ];then
  printf "\e[34m[$0]: \"$t\" already exists.\e[0m"
  v cp .config/ags/user_options.js $t.new
  existed_ags_opt=y
else
  printf "\e[33m[$0]: \"$t\" does not exist yet.\e[0m"
  v cp .config/ags/user_options.js $t
  existed_ags_opt=n
fi

# For Hyprland
v rsync -av --delete --exclude '/custom' --exclude '/hyprland.conf' .config/hypr/ "$HOME"/.config/hypr/
t="$HOME/.config/hypr/hyprland.conf"
if [ -f $t ];then
  printf "\e[34m[$0]: \"$t\" already exists.\e[0m"
  v cp -f .config/hypr/hyprland.conf $t.new
  existed_hypr_conf=y
else
  printf "\e[33m[$0]: \"$t\" does not exist yet.\e[0m"
  v cp .config/hypr/hyprland.conf $t
  existed_hypr_conf=n
fi
t="$HOME/.config/hypr/custom"
if [ -d $t ];then
  printf "\e[34m[$0]: \"$t\" already exists, will not do anything.\e[0m"
else
  printf "\e[33m[$0]: \"$t\" does not exist yet.\e[0m"
  v rsync -av --delete .config/hypr/custom/ $t/
fi


# some foldes (eg. .local/bin) should be processed seperately to avoid `--delete' for rsync,
# since the files here come from different places, not only about one program.
for i in .local/bin .local/share/*
do
  P_BGN;printf "Found target: %s" "$i";P_EOL
  if [ -d "$i" ];then v rsync -av "$i/" "$HOME/$i/"
  elif [ -f "$i" ];then v rsync -av "$i" "$HOME/$i"
  fi
done

# Prevent welcome msg from popping up for the first time because it use `hyprctl keyword bind'.
# See .config/ags/services/messages.js
echo 'Just a file to confirm that you have been greeted ;)' > ~/.cache/ags/user/firstrun.txt

# Prevent hyprland from not fully loaded
sleep 1; try hyprctl reload

# Load Tilix config
v $HOME/.local/bin/tilix-dconf load

existed_zsh_conf=n
grep -q 'source ~/.config/zshrc.d/dots-hyprland.zsh' ~/.zshrc && existed_zsh_conf=y

#####################################################################################
C_C;P_BGN;printf "Finished. See the \"import-manually\" folder and grab anything you need.";P_EOL
i="\e[30;46m Super+Shift+/ \e[0m"
printf "Press $i";C_C;printf " for a list of keybinds.";P_EOL
i="\e[36;40m ~/.config/hypr/hyprshade.toml \e[0m"
printf "Edit $i";C_C;printf " for screen shader configuration.";P_EOL
case $existed_ags_opt in
  y) printf "\e[33m[$0]: Warning: \"~/.config/ags/user_options.js\" already existed before and we didn't overwrite it. \e[97m\n"
     printf "Please use \"~/.config/ags/user_options.js.new\" as a reference for a proper format.\e[97m\n"
;;esac
case $existed_hypr_conf in
  y) printf "\e[33m[$0]: Warning: \"~/.config/hypr/hyprland.conf\" already existed before and we didn't overwrite it. \e[97m\n"
     printf "Please use \"~/.config/hypr/hyprland.conf.new\" as a reference for a proper format.\e[97m\n"
     printf "If this is your first time installation, you must overwrite \"~/.config/hypr/hyprland.conf\" with \"~/.config/hypr/hyprland.conf.new\".\e[97m\n"
;;esac

case $existed_zsh_conf in
  n) printf "\n\e[36m[$0]: \"~/.zshrc\" seems not sourcing \"~/.config/zshrc.d/dots-hyprland.zsh\".\e[97m\n"
     printf "\e[36mIt is optional, but you may put this line into your \"~/.zshrc\" to support colorscheme for ZSH:\e[97m\n"
     printf "\e[36m    source ~/.config/zshrc.d/dots-hyprland.zsh\e[97m\n"
;;esac
