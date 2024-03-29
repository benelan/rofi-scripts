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
dir="$HOME/.config/rofi/powermenu/type-5"
theme='style-2'

# CMDs
lastlogin="$(last "$USER" | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7)"
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
lock=" "
suspend=" "
hibernate="󰒲 "
logout=" "
reboot=" "
shutdown=" "
yes=" "
no=" "

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "  $USER@$host" \
        -mesg "󰍂  Last Login: $lastlogin |   Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg "$1 Are you Sure?" \
        -theme "${dir}/${theme}.rasi"
}

# Ask for confirmation
confirm_exit() {
    [ "$(printf "%s\n%s" "$yes" "$no" | confirm_cmd "$1")" = "$no" ] && exit 0
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s\n%s" \
        "$lock" \
        "$suspend" \
        "$logout" \
        "$hibernate" \
        "$reboot" \
        "$shutdown" |
        rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$shutdown")
        confirm_exit "$shutdown"
        systemctl poweroff
        ;;
    "$reboot")
        confirm_exit "$reboot"
        systemctl reboot
        ;;
    "$hibernate")
        confirm_exit
        systemctl hibernate
        ;;
    "$lock")
        confirm_exit "$lock"
        loginctl lock-session
        ;;
    "$suspend")
        confirm_exit "$suspend"
        playerctl pause
        systemctl suspend
        ;;
    "$logout")
        confirm_exit "$logout"
        pkill -9 -u "$USER"
        # loginctl | grep "$USER" | awk '{print $1}' | xargs loginctl terminate-session
        ;;
esac
