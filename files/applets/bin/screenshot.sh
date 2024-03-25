#!/usr/bin/env sh
# shellcheck disable=1091

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
. "$HOME"/.config/rofi/applets/shared/theme.bash
# shellcheck disable=2154
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: $(xdg-user-dir PICTURES)/Screenshots"

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
    option_1="󰹑  Capture Desktop"
    option_2="󰒉  Capture Area"
    option_3="󱃶  Capture Window"
    option_4="󰔝  Capture in 3s"
    option_5="󰔜  Capture in 10s"
else
    option_1="󰹑 "
    option_2="󰒉 "
    option_3="󱃶 "
    option_4="󰔝 "
    option_5="󰔜 "
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
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

# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)
geometry=$(xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current')
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}_${geometry}.png"

if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
    notify_cmd_shot='dunstify -u low --replace=699'
    ${notify_cmd_shot} "Copied to clipboard."
    viewnior "$dir/$file"
    if [ -e "$dir/$file" ]; then
        ${notify_cmd_shot} "Screenshot Saved."
    else
        ${notify_cmd_shot} "Screenshot Deleted."
    fi
}

# Copy screenshot to clipboard
copy_shot() {
    tee "$file" | xclip -selection clipboard -t image/png
}

# countdown
countdown() {
    for sec in $(seq "$1" -1 1); do
        dunstify -t 1000 --replace=699 "Taking shot in : $sec"
        sleep 1
    done
}

# take shots
shotnow() {
    cd "${dir}" && sleep 0.3 && maim -u -f png | copy_shot
    notify_view
}

shot5() {
    countdown '5'
    sleep 1 && cd "${dir}" && maim -u -f png | copy_shot
    notify_view
}

shot10() {
    countdown '10'
    sleep 1 && cd "${dir}" && maim -u -f png | copy_shot
    notify_view
}

shotwin() {
    cd "${dir}" && maim -u -f png -i "$(xdotool getactivewindow)" | copy_shot
    notify_view
}

shotarea() {
    cd "${dir}" && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
    notify_view
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    "$option_1") shotnow ;;
    "$option_2") shotarea ;;
    "$option_3") shotwin ;;
    "$option_4") shot5 ;;
    "$option_5") shot10 ;;
esac
