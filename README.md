# keyboard light


brightnessctl --device='tpacpi::kbd_backlight' set 0


# keyboard layout

setxkmap x

# 3 screen management

xrandr --output HDMI-2 --mode 1920x1080

xrandr --output HDMI-2 --auto --above eDP-1

xrandr --output DP-1 --auto --left-of HDMI-2

# shortcuts

### apps

mod+b => firefox

mod+v => virtualbox

mod+t => terminal

mod+shift+number move current app to workspace

mod+shift+space float

mod+s layout stacking

mod+w layout tabbed

mod+e layout toggle split

mod+f fullscreen

mod+Shift+Left move left

mod+Shift+Down move down

mod+Shift+Up move up

mod+Shift+Right move right

*move focus*

mod+Shift+Left move left

mod+Shift+Down move down

mod+Shift+Up move up

mod+Shift+Right move right




### system

mod+x lock screen

mod+shift+r refresh i3 conf

mod+r drag applications around to resize

mod+shift+e logout

mod+shift+q kill window

mod+d open search bar


### other

mod+shif+g app gaps

### x discord

~/.config/discord/settings.json

"SKIP_HOST_UPDATE": true


