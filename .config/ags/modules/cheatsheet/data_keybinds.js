// vim:fileencoding=utf-8:ft=javascript:fdm=marker foldlevel=0
// In vim/neovim, press `z' `a' to toggle folding.

// https://github.com/end-4/dots-hyprland/issues/167
// The icons' names are Labels that have the font family set to "Material Symbols Rounded", see the cheatsheet here: https://fonts.google.com/icons
export const keybindList = [[
//{{{ ========== Windows ==========
    {
        "icon": "move_group",
        "name": "windows",
        "binds": [
            // Move focus #####
            { "keys": ["s-", "hjkl"], "action": "go to" },
            // Swap windows #####
            { "keys": ["s-S-", "hjkl"], "action": "Swap to" },
            // Window split ratio #####
            { "keys": ["s-A-", "hjkl"], "action": "Resize" },
            // Misc #####
            { "keys": ["s-", "X"], "action": "Kill" },
            { "keys": ["s-S-", "X"], "action": "hyprctl Kill" },
            { "keys": ["s-A-", "Space"], "action": "floating" },
            { "keys": ["s-", ";"], "action": "switch split" },
            { "keys": ["s-", "F"], "action": "Fullscr" },
            { "keys": ["s-A-", "F"], "action": "fake Fullscr" },
            { "keys": ["s-", "Z"], "action": "move by cursor" },
            { "keys": ["s-", "Lmb(Drag)"], "action": "Move" },
            { "keys": ["s-", "Mmb(Drag)"], "action": "Move" },
            { "keys": ["s-", "Rmb(Drag)"], "action": "Resize" },
        ],
        "id": 1
    },
//}}}EndOf ===== Windows
//{{{ ========== Workspaces ==========
    {
        "icon": "pin_drop",
        "name": "WorkSpace: go to",
        "binds": [
            // goto #####
            { "keys": ["s-", "num #"], "action": "WS #" },
            { "keys": ["s-", "`"], "action": "Special WS" },
            { "keys": ["s-", "Scroll"], "action": "WS -1/+1" },
            { "keys": ["s-", "[ ]"], "action": "WS -1/+1" },
        ],
        "id": 2
    },
    {
        "icon": "overview_key",
        "name": "WorkSpace: Swap to",
        "binds": [
            // Move #####
            { "keys": ["s-S-", "num #"], "action": "WS #" },
            { "keys": ["s-S-", "`"], "action": "Special WS" },
            { "keys": ["s-S-", "Scroll"], "action": "WS -1/+1" },
            { "keys": ["s-S-", "[ ]"], "action": "WS -1/+1" },
        ],
        "id": 3
    },
//}}}EndOf ===== Workspaces
],
[
//{{{ ========== Settings & Configs ==========
    {
        "icon": "construction",
        "name": "settings & configs",
        "binds": [
            { "keys": ["s-C-", "I"], "action": "Gnome settings" },
            { "keys": ["s-C-", "V"], "action": "pavucontrol" },
            { "keys": ["S-C-", "ESC"], "action": "sys-monitor" },
            { "keys": ["A-S-C-", "ESC"], "action": "btop" },
            { "keys": ["A-S-C-", "ESC"], "action": "btop" },
        ],
        "id": 4
    },
//}}}EndOf ===== Settings & Configs
//{{{ ========== Applications ==========
    {
        "icon": "apps",
        "name": "Apps",
        "binds": [
            // App launcher #####
            { "keys": ["s-", "/"], "action": "App Launcher" },
            // Misc #####
            { "keys": ["s-", "Return"], "action": "Tilix" },
            { "keys": ["s-S-", "Return"], "action": "Foot" },
        ],
        "id": 5
    },
//}}}EndOf ===== Applications
//{{{ ========== Widgets ==========
    {
        "icon": "widgets",
        "name": "widgets",
        "binds": [
            // Power & Lockscreen #####
            { "keys": ["s-", "del"], "action": "wlogout" },
            { "keys": ["A-C-", "del"], "action": "ags \"session\"" },
            { "keys": ["s-", "F1"], "action": "ScreenLock" },
            { "keys": ["s-A-S-C-", "del"], "action": "poweroff" },
            // MISC #####
            { "keys": ["s-C-", "R"], "action": "restart ags" },
            { "keys": ["s-A-C-", "R"], "action": "reload widgets" },
            { "keys": ["s-", "."], "action": "emoji" },
            { "keys": ["s-C-", "T"], "action": "switch wallpaper" },
            { "keys": ["s-C-", "[ ]"], "action": "L/R sidebar" },
            { "keys": ["s-", ","], "action": "Color Scheme" },
            // { "keys": ["(right)Ctrl"], "action": "Dismiss notification & close menus" }
        ],
        "id": 6
    },
//}}}EndOf ===== Widgets
],
[
//{{{ ========== Capture ==========
    {
        "icon": "center_focus_strong",
        "name": "Capture",
        "binds": [
            // Screenshot #####
            { "keys": ["Print"], "action": "shot screen to clipboard" },
            { "keys": ["s-S-", "S"], "action": "shot to clipboard" },
            { "keys": ["s-A-S-", "S"], "action": "shot and edit" },
            // OCR #####
            { "keys": ["s-S-C-", "S"], "action": "OCR to clipboard" },
            // Color picker, Clipboard history #####
            { "keys": ["s-S-", "C"], "action": "color pick" },
            { "keys": ["s-", "V"], "action": "clipboard history" },
            // Recorder #####
            { "keys": ["s-", "G"], "action": "record selected" },
            { "keys": ["s-S-", "G"], "action": "record fullscreen" },
        ],
        "id": 7
    },
//}}}EndOf ===== Capture
//{{{ ========== Media related ==========
    {
        "icon": "stock_media",
        "name": "Media related",
        "binds": [
            // Volume #####
            { "keys": ["(Volume)"], "action": "alter volume" },
            // Brightness #####
            { "keys": ["(Brightness)"], "action": "alter brightness" },
            // Media player #####
            { "keys": ["(Player)"], "action": "alter player" },
            { "keys": ["s-S-", "N"], "action": "next" },
            { "keys": ["s-S-", "B"], "action": "previous" },
            { "keys": ["s-", "M"], "action": "Music panel" },
        ],
        "id": 8
    }
//}}}EndOf ===== Media related
]];
