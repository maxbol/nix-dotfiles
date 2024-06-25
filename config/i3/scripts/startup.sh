#!/bin/sh
kitty &

tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE "$HYPRLAND_INSTANCE_SIGNATURE"

$HOME/.config/polybar/launch.sh &
