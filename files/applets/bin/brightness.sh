#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Brightness

# Import Current Theme
. "$HOME"/.config/rofi/applets/shared/theme.bash
# shellcheck disable=2154
theme="$type/$style"

# Brightness Info
backlight="$(brightnessctl -m | awk -F, 'gsub(/%/,""){print $4}')"
card="$(brightnessctl -m | awk -F, '{print $1}')"

if [ "$backlight" -ge 0 ] && [ "$backlight" -le 29 ]; then
    level="Low"
elif [ "$backlight" -ge 30 ] && [ "$backlight" -le 49 ]; then
    level="Optimal"
elif [ "$backlight" -ge 50 ] && [ "$backlight" -le 69 ]; then
    level="High"
elif [ "$backlight" -ge 70 ] && [ "$backlight" -le 100 ]; then
    level="Peak"
fi

# Theme Elements
prompt="${backlight}%"
mesg="Device: ${card}, Level: $level"

type_number="$(basename "$type")"
if [ "$type_number" = 'type-1' ]; then
    list_col='1'
    list_row='4'
    win_width='400px'
elif [ "$type_number" = 'type-3' ]; then
    list_col='1'
    list_row='4'
    win_width='120px'
elif [ "$type_number" = 'type-5' ]; then
    list_col='1'
    list_row='4'
    win_width='425px'
elif [ "$type_number" = 'type-2' ] || [ "$type_number" = 'type-4' ]; then
    list_col='4'
    list_row='1'
    win_width='550px'
fi

# Options
layout=$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)
if [ "$layout" = 'NO' ]; then
    option_1="  Increase"
    option_2="  Optimal"
    option_3="  Decrease"
    option_4="  Settings"
else
    option_1=" "
    option_2=" "
    option_3=" "
    option_4=" "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "󰖨 ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n%s\n%s\n%s" \
        "$option_1" \
        "$option_2" \
        "$option_3" \
        "$option_4" |
        rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1") brightnessctl --class=backlight set +10% ;;
    "$option_2") brightnessctl --class=backlight set 10 ;;
    "$option_3") brightnessctl --class=backlight set 10%- ;;
    "$option_4") gnome-control-center power ;;
esac
