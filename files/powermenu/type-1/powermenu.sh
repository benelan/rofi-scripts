#!/usr/bin/env sh

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-1"
theme='style-5'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
shutdown='󰐥 Shutdown'
reboot='󰜉 Reboot'
lock='󰌾 Lock'
suspend='󰤄 Suspend'
logout='󰍃 Logout'
yes='󰗡 Yes'
no='󰜺 No'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "${dir}/${theme}.rasi"
}

# Ask for confirmation
confirm_exit() {
    [ "$(printf "%s\n%s" "$yes" "$no" | confirm_cmd)" = "$no" ] && exit 0
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s" \
        "$lock" \
        "$suspend" \
        "$logout" \
        "$reboot" \
        "$shutdown" |
        rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$shutdown")
        confirm_exit
        systemctl poweroff
        ;;
    "$reboot")
        confirm_exit
        systemctl reboot
        ;;
    "$lock")
        confirm_exit
        i3lock -efc 000000
        ;;
    "$suspend")
        confirm_exit
        playerctl pause
        systemctl suspend
        ;;
    "$logout")
        confirm_exit
        if [ "$DESKTOP_SESSION" = 'i3' ]; then
            i3-msg exit
        elif [ "$DESKTOP_SESSION" = 'gnome' ]; then
            gnome-session-quit --no-prompt --logout
        elif [ "$DESKTOP_SESSION" = 'plasma' ]; then
            qdbus org.kde.ksmserver /KSMServer logout 0 0 0
        elif [ "$DESKTOP_SESSION" = 'bspwm' ]; then
            bspc quit
        elif [ "$DESKTOP_SESSION" = 'openbox' ]; then
            openbox --exit
        fi
        ;;
esac
