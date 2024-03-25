#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : MPD (music)

# Import Current Theme
. "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
status="$(mpc status)"
if [[ -z "$status" ]]; then
    prompt='Offline'
    mesg="MPD is Offline"
else
    prompt="$(mpc -f "%artist%" current)"
    mesg="$(mpc -f "%title%" current) :: $(mpc status | grep "#" | awk '{print $3}')"
fi

if [[ ("$theme" == *'type-1'*) || ("$theme" == *'type-3'*) || ("$theme" == *'type-5'*) ]]; then
    list_col='1'
    list_row='6'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
    list_col='6'
    list_row='1'
fi

# Options
layout=$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)
if [ "$layout" = 'NO' ]; then
    if [[ ${status} == *"[playing]"* ]]; then
        option_1="󰏤 Pause"
    else
        option_1="󰐊 Play"
    fi
    option_2="󰓛 Stop"
    option_3="󰒮 Previous"
    option_4="󰒭 Next"
    option_5="󰑖 Repeat"
    option_6="󰒟 Random"
else
    if [[ ${status} == *"[playing]"* ]]; then
        option_1="󰏤"
    else
        option_1="󰐊"
    fi
    option_2="󰓛"
    option_3="󰒮"
    option_4="󰒭"
    option_5="󰑖"
    option_6="󰒟"
fi

# Toggle Actions
active=''
urgent=''
# Repeat
if [[ ${status} == *"repeat: on"* ]]; then
    active="-a 4"
elif [[ ${status} == *"repeat: off"* ]]; then
    urgent="-u 4"
else
    option_5="󱔢 Parsing Error"
fi
# Random
if [[ ${status} == *"random: on"* ]]; then
    [ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ ${status} == *"random: off"* ]]; then
    [ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
else
    option_6="󱔢 Parsing Error"
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "󰝚 ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
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
    "$option_1") mpc -q toggle && notify-send -u low -t 1000 "󰎈 $(mpc current)" ;;
    "$option_2") mpc -q stop ;;
    "$option_3") mpc -q prev && notify-send -u low -t 1000 "󰎈 $(mpc current)" ;;
    "$option_4") mpc -q next && notify-send -u low -t 1000 "󰎈 $(mpc current)" ;;
    "$option_5") mpc -q repeat ;;
    "$option_6") mpc -q random ;;
esac
