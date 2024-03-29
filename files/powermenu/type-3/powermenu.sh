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
dir="$HOME/.config/rofi/powermenu/type-3"
theme='style-3'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"

# Options
lock=" "
suspend=" "
logout=" "
reboot=" "
shutdown=" "
yes=" "
no=" "


# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "Uptime: $uptime" \
        -mesg "Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

# Confirmation CMD
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg "$1 Are you Sure?" \
        -theme "${dir}/shared/confirm.rasi"
}

# Ask for confirmation
confirm_exit() {
    [ "$(printf "%s\n%s" "$yes" "$no" | confirm_cmd "$1")" = "$no" ] && exit 0
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
        confirm_exit "$shutdown"
        systemctl poweroff
        ;;
    "$reboot")
        confirm_exit "$reboot"
        systemctl reboot
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
