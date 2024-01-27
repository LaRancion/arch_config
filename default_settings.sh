#!/bin/bash

#da aggiungere al file di configurazione dopo exec_always

xrandr --output HDMI-2 --mode 1920x1080
xrandr --output HDMI-2 --auto --left-of eDP-1
xrandr --output DP-1 --auto --left-of HDMI-2
setxkbmap it
