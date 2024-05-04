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
$t/install.sh
```
And follow the instructions of the script `install.sh`.

> [!WARNING]
> Uninstallation script is NOT provided. See FAQ-Whys.

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

Tilix is one of the terminal, it stores configs in dconf.
Use `.local/bin/tilix-dconf` to load/dump the Tilix config stored in dconf from/to the file `.config/Tilix.dconf`.

## Credits
- The project is largely based on the amazing [end-4/dots-hyprland (code name: illogical_impulse)](https://github.com/end-4/dots-hyprland), modified to suit my personal tastes.
  - I'm a collaborator both of [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) and its [doc site](https://github.com/end-4/dots-hyprland-wiki), where I have reworked the install scripts (including the online setup) and initialized the doc site, and currently maintain them.
- [Aylur/AGS](https://github.com/Aylur/ags/)-powered.

## How to debug
Here're some hints.

The bar, and the side bars, cheatsheet, etc. belongs to AGS.
To debug AGS, you may need to run this in shell:
```bash
pkill ags;ags
```
And see if there're any errors, CRITICALs and WARNINGs.

Also, some common problems are listed in FAQ.

## FAQ
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
### Firefox sometimes crashes
When this happens, please use `(xWayland) Firefox`, which desktop file is provided in `~/.local/share/applications` with `env MOZ_ENABLE_WAYLAND=0` for `Exec` entry.

This is just a workround, which makes Firefox running under xWayland.

### ags installation failed
#### `PermissionError: [Errno 13] Permission denied: '/usr/local/lib/libgvc.so'`
Run:
```bash
pacman -Qo /usr/local/lib/libgvc.so
```
to check whether this file belongs to any package (very likely not, because it's inside `/usr/local`).

If not, then it's probably safe to just remove it. If you're sure about that, run this:
```bash
sudo mv /usr/local/lib/libgvc.so /tmp/
```
#### Other errors
Delete `./cache/ags` and install it again.

### How to resize | set resolution | font size
Reference: <https://github.com/end-4/dots-hyprland/issues/180#issuecomment-1880385893>

You can use gsettings to change the font size, like this:
```bash
gsettings set org.gnome.desktop.interface font-name 'Rubik 9'
```
Rubik here is the font name and 9 is the font size in pt (1pt = 1.3333 px)

Stuff should scale according to the font size. Some ags element may need a restart of ags to take effect.

If some elements are wayy too big, then it's possible that css totally not working, see <https://github.com/end-4/dots-hyprland/issues/226>.

### How to change time format
Reference: <https://github.com/end-4/dots-hyprland/issues/228>

**NOTE**: You may need to run `man date` for time format.

For AGS bar (it's not a dock bar I guess), you should edit `~/.config/ags/widgets/bar/system.js`.
Find `"%H:%M"` there and change it to what you like.
Its format may refer to [this page](https://docs.gtk.org/glib/method.DateTime.format.html).

The lockscreen is swaylock currently. Edit its config in `~/.config/swaylock/config` to suit your needs.
For time format you need to adjust `timestr`.

### How to copy text in notification
Reference: <https://github.com/end-4/dots-hyprland/issues/224#issuecomment-1923706599>

Click and hold a notification for a while, and its content will be copied.

### How to set city for weather
Reference: <https://github.com/end-4/dots-hyprland/issues/220#issuecomment-1923793627>
<https://github.com/end-4/dots-hyprland/commit/c2d3c5bce37dd87f19bf5e13002b2af6e0e1e5eb>

The value will be used as `${city}` for `curl https://wttr.in/${city}?format=j1`.

By default the value comes from `curl ipinfo.io`.
You can also manually set the value by setting the env var `$AGS_WEATHER_CITY`.
## FAQ-Whys
### Why use `hyprland-git` from AUR instead of `hyprland` from repo of Arch Linux
See [end-4/dots-hyprland#158](https://github.com/end-4/dots-hyprland/issues/158).
### Uninstallation script is NOT provided, why?
Because it's very hard to make a proper uninstallation script,
which should revert all changes made by the installation script.

For example, the installation script will install `yay` (AUR-helper) for you if you don't have one.
However, what should the uninstallation script do to revert this changes?
Remove `yay` or `yay-bin`? Not proper, because you may already have one of them installed by yourself (NOT by the installation script).
And, even if the installation script had logged the package list installed by the script, it's still not proper to remove `yay` or `yay-bin` when the log showed `yay` or `yay-bin` is installed by the script, because you may have other programs using `yay` and this removal will break their functions.

In conclusion, it's nearly not possible to write a proper uninstallation script.
You'd better make reverted changes manually as you need.

> Wait, it might still be partly possible by creating a PKGBUILD and make the dotfiles as a package for pacman... Maybe implement this some other day.

