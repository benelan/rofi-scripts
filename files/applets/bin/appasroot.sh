#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Run Applications as Root

# Import Current Theme
. "$HOME/.config/rofi/applets/shared/theme.bash"
# shellcheck disable=2154
theme="$type/$style"

# Theme Elements
prompt='Applications'
mesg='Run Applications as Root'

type_number="$(basename "$type")"
if [ "$type_number" = 'type-1' ]; then
    list_col='1'
    list_row='5'
    win_width='400px'
elif [ "$type_number" = 'type-3' ]; then
    list_col='1'
    list_row='5'
    win_width='120px'
elif [ "$type_number" = 'type-5' ]; then
    list_col='1'
    list_row='5'
    win_width='520px'
elif [ "$type_number" = 'type-2' ] || [ "$type_number" = 'type-4' ]; then
    list_col='5'
    list_row='1'
    win_width='670px'
fi

# Options
layout=$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)
if [ "$layout" = 'NO' ]; then
    option_1="  Terminal"
    option_2="  Vifm"
    option_3="  Editor"
    option_4="󰱼  Nautilus"
    option_5="󱇧  Gedit"
else
    option_1=" "
    option_2=" "
    option_3=" "
    option_4="󰱼 "
    option_5="󱇧 "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s" \
        "$option_1" \
        "$option_2" \
        "$option_3" \
        "$option_4" \
        "$option_5" |
        rofi_cmd
}

# Actions
chosen="$(run_rofi)"
polkit_cmd="pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
case ${chosen} in
    "$option_1") ${polkit_cmd} "$TERMINAL" ;;
    "$option_2") ${polkit_cmd} vifm / ;;
    "$option_3") ${polkit_cmd} "$([ "$EDITOR" = "nvim" ] && echo "nvim" || echo "vim")" ;;
    "$option_4") ${polkit_cmd} nautilus -s file:///home ;;
    "$option_5") ${polkit_cmd} gedit ;;
esac
