#!/bin/bash

sudo pacman -S yay feh xorg git i3-gnome i3-wm ttf-droid ttf-droid i3status i3blocks dmenu materia-gtk-theme papirus-icon-theme lxappearance ttf-font-awesome ttf-ubuntu-font-family picom terminator
yay i3lock-color

mkdir ~/.config/scripts

echo "#!/bin/sh

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#00897bE6'
TEXT='#00897bE6'
WRONG='#880000bb'
VERIFYING='#00564dE6'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--blur 9                     \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%A, %Y-%m-%d"       \
--keylayout 1                \" >> ~/.config/scripts/lock

sudo chmod +x .config/scripts/lock
mkdir .config/i3status
sudo cp /etc/i3status.conf ~/.config/i3status/i3status.conf
sudo chown $USER:$USER ~/.config/i3status/i3status.conf
