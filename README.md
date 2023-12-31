## Description
Dotfiles for Hyprland on Arch Linux.

Main feature/style:
- Vim-like keybindings (also a little Emacs styles).
- Sweet theme.
- (TODO)Zsh.

## Installation
Simply run:
```bash
t=~/dotfiles # Or anywhere else you'd like
mkdir -p $t
git clone https://github.com/clsty/dots-hyprarch $t
$t/setup.sh
```
And follow the instructions of the script `setup.sh`.

> [!WARNING]
> Uninstallation script is NOT provided. See FAQ.

## Launch
Basically, login to tty and launch the wrapper script `~/.local/bin/wrp-hyprland`.

**NOTE: You'd better have a look at the script's content and edit it to suit your needs.**

If you want this done automatically, you may add the following to the end of your default shell (zsh or bash)'s config file (`.zshrc` or `.bashrc`):
```bash
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec ~/.local/bin/wrp-hyprland
fi
```

## Usage
`Super`+`Shift`+`/` to open cheatsheet to see a list of keybinds.
> TODO: write cheatsheet in comments in `hypr/keybinds.conf` and use script to generate `ags/data/keybinds.js` from it

Tilix is the default terminal, it stores configs in dconf.
Use `.local/bin/tilix-dconf` to load/dump the Tilix config stored in dconf from/to the file `.config/Tilix.dconf`.

## Credits
- The project is largely based on the amazing [end-4/dots-hyprland (branch: illogical_impulse)](https://github.com/end-4/dots-hyprland/tree/illogical-impulse), modified to suit my personal tastes.
  - You may take a look there, as the development there is very active, and there're more branches.
  - I have also contributed some improvements and fixes there, mainly on the installation scripts.
- [Aylur/AGS](https://github.com/Aylur/ags/)-powered.

## FAQ
### Why use `hyprland-git` from AUR instead of `hyprland` from repo of Arch Linux
See [end-4/dots-hyprland#158](https://github.com/end-4/dots-hyprland/issues/158).
### The player panel does not pop up when there is media playing
> Reference: [end-4/dots-hyprland#168](https://github.com/end-4/dots-hyprland/issues/168)

Your player must have mpris support (see supported client [here](https://wiki.archlinux.org/title/MPRIS)).

If you are using firefox as player, Plasma Integration extension should be installed and enabled for firefox, and the package `plasma-browser-integration` should be installed on Arch Linux.

Then, when firefox is playing media, the following command:
```bash
dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames|grep mpris
```
should at least return
```plain
string "org.mpris.MediaPlayer2.plasma-browser-integration"
```
note that output like `string "org.mpris.MediaPlayer2.firefox.instance_1_37"` does NOT work.

If for some reason, firefox still does not have dbus `org.mpris.MediaPlayer2.plasma-browser-integration` showing up,
consider the following steps:
1. Create a new profile using `firefox --ProfileManager`.
2. Launch firefox with the newprofile and install the Plasma Integration extension again.
3. Restart firefox with the new profile and try again.

Note: `playerctl -F metadata` may also be helpful for debugging.
# Uninstallation script is NOT provided, why?
Because it's very hard to make a proper uninstallation script,
which should revert all changes made by the installation script.

However, it's very hard to know what command will exactly make the reverted changes.

For example, the installation script will install `yay` (AUR-helper) for you if you don't have one.
However, what should the uninstallation script do to revert this changes?
Remove `yay` or `yay-bin`? Not proper, because you may already have one of them installed by yourself (NOT by the installation script).
And, even if the installation script had logged the package list installed by the script, it's still not proper to remove `yay` or `yay-bin` when the log showed `yay` or `yay-bin` is installed by the script, because you may have other programs using `yay` and this removal will break their functions.

In conclusion, it's nearly not possible to write a proper uninstallation script.
You'd better make reverted changes manually as you need.

> Wait, it might still be partly possible by creating a PKGBUILD and make the dotfiles as a package for pacman... Maybe implement this some other day.
