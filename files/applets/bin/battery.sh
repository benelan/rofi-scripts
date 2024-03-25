#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Battery

# Import Current Theme
. "$HOME"/.config/rofi/applets/shared/theme.bash
# shellcheck disable=2154
theme="$type/$style"

# Battery Info
battery="$(acpi -b | cut -d':' -f1)"
time="$(acpi -b | cut -d',' -f3)"
status="$(acpi -b | sed -re 's/^.*: (\w*),.*$/\1/')"
percentage="$(acpi -b | sed -re 's/^.*, ([0-9]+)%.*$/\1/')"

if [ -z "$time" ]; then
    time=' Fully Charged'
fi

# Theme Elements
prompt="$status"
mesg="${battery}: ${percentage}%,${time}"

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
    win_width='500px'
elif [ "$type_number" = 'type-2' ] || [ "$type_number" = 'type-4' ]; then
    list_col='4'
    list_row='1'
    win_width='550px'
fi

# Charging Status
active=""
urgent=""
if [ "$status" = "Charging" ]; then
    active="-a 1"
    ICON_CHRG="󰂄"
elif [ "$status" = "Full" ]; then
    active="-u 1"
    ICON_CHRG="󱟢"
else
    urgent="-u 1"
    ICON_CHRG="󱐤"
fi

# Discharging
if [ "$percentage" -le 9 ]; then
    ICON_DISCHRG="󰁺"
elif [ "$percentage" -ge 10 ] && [ "$percentage" -le 19 ]; then
    ICON_DISCHRG="󰁻"
elif [ "$percentage" -ge 20 ] && [ "$percentage" -le 29 ]; then
    ICON_DISCHRG="󰁼"
elif [ "$percentage" -ge 30 ] && [ "$percentage" -le 39 ]; then
    ICON_DISCHRG="󰁽"
elif [ "$percentage" -ge 40 ] && [ "$percentage" -le 49 ]; then
    ICON_DISCHRG="󰁾"
elif [ "$percentage" -ge 50 ] && [ "$percentage" -le 59 ]; then
    ICON_DISCHRG="󰁿"
elif [ "$percentage" -ge 60 ] && [ "$percentage" -le 69 ]; then
    ICON_DISCHRG="󰂀"
elif [ "$percentage" -ge 70 ] && [ "$percentage" -le 79 ]; then
    ICON_DISCHRG="󰂁"
elif [ "$percentage" -ge 80 ] && [ "$percentage" -le 89 ]; then
    ICON_DISCHRG="󰂂"
elif [ "$percentage" -ge 90 ] && [ "$percentage" -le 100 ]; then
    ICON_DISCHRG="󰁹"
fi

# Options
layout=$(cat "${theme}" | grep 'USE_ICON' | cut -d'=' -f2)
if [ "$layout" = 'NO' ]; then
    option_1="$ICON_DISCHRG  Remaining ${percentage}%"
    option_2="$ICON_CHRG  $status"
    option_3="  Power Manager"
    option_4="  Diagnose"
else
    option_1="$ICON_DISCHRG"
    option_2="$ICON_CHRG"
    option_3=" "
    option_4=" "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str "textbox-prompt-colon {str: \"$ICON_DISCHRG\";}" \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
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
    "$option_1") notify-send "${ICON_DISCHRG} Remaining: ${percentage}%" ;;
    "$option_2") notify-send "$ICON_CHRG Status: $status" ;;
    "$option_3") gnome-control-center power ;;
    "$option_4")
        pkexec env PATH="$PATH" \
            DISPLAY="$DISPLAY" \
            XAUTHORITY="$XAUTHORITY" \
            "$TERMINAL" -e powertop
        ;;
esac
