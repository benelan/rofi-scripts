#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Volume

# Import Current Theme
. "$HOME"/.config/rofi/applets/shared/theme.bash
# shellcheck disable=2154
theme="$type/$style"

# Volume Info
mixer="$(amixer info Master | grep 'Mixer name' | cut -d':' -f2 | tr -d \',' ')"
speaker="$(amixer get Master | tail -n1 | awk -F' ' '{print $5}' | tr -d '[]')"
mic="$(amixer get Capture | tail -n1 | awk -F' ' '{print $5}' | tr -d '[]')"

active=""
urgent=""

# Speaker Info
if amixer get Master | grep '\[on\]' >/dev/null 2>&1; then
    active="-a 1"
    stext='Unmute'
    sicon=' '
else
    urgent="-u 1"
    stext='Mute'
    sicon='󰝟 '
fi

# Microphone Info
if amixer get Capture | grep '\[on\]' >/dev/null 2>&1; then
    [ -n "$active" ] && active="$active,3" || active="-a 3"
    mtext='Unmute'
    micon='󰍬 '
else
    [ -n "$urgent" ] && urgent="$urgent,3" || urgent="-u 3"
    mtext='Mute'
    micon='󰍭 '
fi

# Theme Elements
prompt="S:${stext}d, M:${mtext}d"
mesg="$mixer - Speaker: $speaker, Mic: $mic"

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
    option_1="󰝝  Increase"
    option_2="$sicon $stext"
    option_3="󰝞  Decrease"
    option_4="$micon $mtext"
    option_5="  Settings"
else
    option_1="󰝝 "
    option_2="$sicon"
    option_3="󰝞 "
    option_4="$micon"
    option_5=" "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "󰓃 ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
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
case ${chosen} in
    "$option_1") pactl set-sink-volume @DEFAULT_SINK@ +20% ;;
    "$option_2") pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    "$option_3") pactl set-sink-volume @DEFAULT_SINK@ -20% ;;
    "$option_4") pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
    "$option_5") pavucontrol ;;
esac
