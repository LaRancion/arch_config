#!/bin/bash

echo select the keyboard light option between 0,1,2

read a
echo "setting current keyboard light at $a"
if [ $a -eq 0 ]; then

	brightnessctl --device='tpacpi::kbd_backlight' set 0

elif [ $a -eq 1 ]; then

	brightnessctl --device='tpacpi::kbd_backlight' set 1

else 

	brightnessctl --device='tpacpi::kbd_backlight' set 2

fi