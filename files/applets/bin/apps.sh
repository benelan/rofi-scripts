#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Favorite Applications

# Import Current Theme
. "$HOME/.config/rofi/applets/shared/theme.bash"
# shellcheck disable=2154
theme="$type/$style"

# Theme Elements
prompt='Applications'
mesg="Installed Packages : $(apt list --installed 2>/dev/null | wc -l) (apt)"

type_number="$(basename "$type")"
if [ "$type_number" = 'type-1' ] || [ "$type_number" = 'type-3' ] || [ "$type_number" = 'type-5' ]; then
    list_col='1'
    list_row='6'
elif [ "$type_number" = 'type-2' ] || [ "$type_number" = 'type-4' ]; then
    list_col='6'
    list_row='1'
fi

# CMDs (add your apps here)
term_cmd="$TERMINAL"
file_cmd="vifm"
text_cmd="$TERMINAL -e $([ "$EDITOR" = "nvim" ] && echo "nvim" || echo "vim")"
web_cmd="$BROWSER"
music_cmd='sayonara'
setting_cmd="gnome-control-center"

# Options
layout="$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)"
if [ "$layout" = 'NO' ]; then
    option_1="  Terminal <span weight='light' size='small'><i>($term_cmd)</i></span>"
    option_2="  Files <span weight='light' size='small'><i>($file_cmd)</i></span>"
    option_3="  Editor <span weight='light' size='small'><i>($text_cmd)</i></span>"
    option_4="󰖟  Browser <span weight='light' size='small'><i>($web_cmd)</i></span>"
    option_5="󰝚  Music <span weight='light' size='small'><i>($music_cmd)</i></span>"
    option_6="  Settings <span weight='light' size='small'><i>($setting_cmd)</i></span>"
else
    option_1=" "
    option_2=" "
    option_3=" "
    option_4="󰖟 "
    option_5="󰝚 "
    option_6=" "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "󰏋 ";}' \
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

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1") ${term_cmd} ;;
    "$option_2") ${file_cmd} ;;
    "$option_3") ${text_cmd} ;;
    "$option_4") ${web_cmd} ;;
    "$option_5") ${music_cmd} ;;
    "$option_6") ${setting_cmd} ;;
esac
