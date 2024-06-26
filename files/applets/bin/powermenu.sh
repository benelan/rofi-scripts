#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Power Menu

# Import Current Theme
. "$HOME/.config/rofi/applets/shared/theme.bash"
# shellcheck disable=2154
theme="$type/$style"

# Theme Elements
prompt="$(hostname)"
mesg="Uptime : $(uptime -p | sed -e 's/up //g')"

type_number="$(basename "$type")"
if [ "$type_number" = 'type-1' ] || [ "$type_number" = 'type-3' ] || [ "$type_number" = 'type-5' ]; then
    list_col='1'
    list_row='6'
elif [ "$type_number" = 'type-2' ] || [ "$type_number" = 'type-4' ]; then
    list_col='6'
    list_row='1'
fi

# Options
layout=$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)
if [ "$layout" = 'NO' ]; then
    option_1="  Lock"
    option_2="  Suspend"
    option_3="󰒲  Hibernate"
    option_4="  Logout"
    option_5="  Reboot"
    option_6="  Shutdown"
    yes="  Yes"
    no="  No"
else
    option_1=" "
    option_2=" "
    option_3="󰒲 " #     
    option_4=" "
    option_5=" "
    option_6=" "
    yes=" "
    no=" "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s\n%s" \
        "$option_1" \
        "$option_2" \
        "$option_3" \
        "$option_4" \
        "$option_5" \
        "$option_6" |
        rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg "$1 Are you Sure?" \
        -theme "${theme}"
}

# Confirm or exit
confirm_exit() {
    [ "$(printf "%s\n%s" "$yes" "$no" | confirm_cmd "$1")" = "$no" ] && exit 0
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1")
        confirm_exit "$option_1"
        loginctl lock-session
        ;;
    "$option_2")
        confirm_exit "$option_2"
        playerctl pause 2>/dev/null || true && systemctl suspend
        ;;
    "$option_3")
        confirm_exit "$option_3"
        systemctl hibernate
        ;;
    "$option_4")
        confirm_exit "$option_4"
        pkill -9 -u "$USER"
        # loginctl | grep "$USER" | awk '{print $1}' | xargs loginctl terminate-session
        ;;
    "$option_5")
        confirm_exit "$option_5"
        systemctl reboot
        ;;
    "$option_6")
        confirm_exit "$option_6"
        systemctl poweroff
        ;;
esac
