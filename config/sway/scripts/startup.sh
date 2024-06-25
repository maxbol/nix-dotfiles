#!/bin/sh

tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE "$HYPRLAND_INSTANCE_SIGNATURE"

wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

waybar &
kitty &
