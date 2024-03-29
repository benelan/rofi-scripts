#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Quick Links

# Import Current Theme
. "$HOME"/.config/rofi/applets/shared/theme.bash
# shellcheck disable=2154
theme="$type/$style"

quickopen_browser=$BROWSER

# Theme Elements
prompt='Quick Links'
mesg="Using '$quickopen_browser' as web browser"

type_number="$(basename "$type")"
if [ "$type_number" = 'type-1' ] || [ "$type_number" = 'type-3' ] || [ "$type_number" = 'type-5' ]; then
    list_col='1'
    list_row='6'
elif [ "$type_number" = 'type-2' ] || [ "$type_number" = 'type-4' ]; then
    list_col='6'
    list_row='1'
fi

if [ "$type_number" = 'type-1' ] || [ "$type_number" = 'type-5' ]; then
    efonts="Iosevka Nerd Font 12"
else
    efonts="Iosevka Nerd Font 28"
fi

# Options
layout=$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)
if [ "$layout" = 'NO' ]; then
    option_1="  Proton"
    option_2="  Github"
    option_3="  Youtube"
    option_4="  Apple Music"
    option_5="󰝆  Netflix"
    option_6="󰠩  Hulu"
    option_7="  Reddit"
    option_8="  Google"
    option_9="󰊫  Gmail"
else
    option_1=" "
    option_2=" "
    option_3=" "
    option_4=" "
    option_5="󰝆 "
    option_6="󰠩 "
    option_7=" "
    option_8=" "
    option_9="󰊫 "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
        -theme-str "element-text {font: \"$efonts\";}" \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s" \
        "$option_1" \
        "$option_2" \
        "$option_3" \
        "$option_4" \
        "$option_5" \
        "$option_6" \
        "$option_7" \
        "$option_8" \
        "$option_9" |
        rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1") $quickopen_browser 'https://proton.me' & ;;
    "$option_2") $quickopen_browser 'https://www.github.com/' & ;;
    "$option_3") $quickopen_browser 'https://www.youtube.com/' & ;;
    "$option_4") $quickopen_browser 'https://music.apple.com/' & ;;
    "$option_5") $quickopen_browser 'https://www.netflix.com/' & ;;
    "$option_6") $quickopen_browser 'https://www.hulu.com/' & ;;
    "$option_7") $quickopen_browser 'https://www.reddit.com/' & ;;
    "$option_8") $quickopen_browser 'https://www.google.com/' & ;;
    "$option_9") $quickopen_browser 'https://mail.google.com/' & ;;
esac
