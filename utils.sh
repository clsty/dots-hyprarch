#!/usr/bin/env bash
echo "This script is WIP, just do NOT run it. Use setup.sh if you are about to install the config."
case $dotsdebug in true)sleep 0;; *)exit 1;;esac
#
# TODO: Make this script "TUI"-like.
# Some Ideas:
# Make use of getopt(s) to provide more options
# Use vt100 features to provide a more controllable interface (eg. show total progress at the bottom of terminal during installation)
# Provide an interface to choose options (eg. install, auto install, update components, uninstall)
# i18n
#

cd "$(dirname "$0")"
export base="$(pwd)"
source ./functions


options=(opt1 "option 2" another "option here")
echo "Please choose an option:"
f=(echo "${options[@]}"|fzy)
echo "f = $f ."





exit

if ! command -v pacman >/dev/null 2>&1;then printf "\e[31m[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...\e[0m\n";exit 1;fi
startask (){
printf "\e[34m[$0]: Hi there!\n"
printf 'This script 1. only works for ArchLinux and Arch-based distros.\n'
printf '            2. has not been fully tested, use at your own risk.\n'
printf "\n"
printf "What do you want?"
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
if $ask_ags;then showfun install-ags;v install-ags;fi
