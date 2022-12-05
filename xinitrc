## Don't forget to ln -s ~/.xinitrc ~/.xsession if necessary 

exec >> .session.log 2>> .session.err

echo "xinitrc : `date`"
echo 1>&2 "xinitrc : `date`"

setxkbmap us  -variant qwerty-fr
xmodmap -e "keycode 112 = Home"
xmodmap -e "keycode 117 = End"

# Disable middle click on touchpad
xinput set-button-map 13 1 1 3 4 5 6 7
xinput --set-prop 13 'libinput Accel Speed' 0.5
xrandr --fbmm `xrandr | sed -n '/ connected/s/.* \([0-9]*\)mm x \([0-9]*\)mm/\1x\2/p'`

# before starting xmonad, we want a correct X db and a running urxvt daemon
xrdb -merge ~/.Xresources
xbindkeys
xscreensaver &
#redshift-gtk  -c ~/dotfiles/redshift.conf &

xset +fp /home/mgrenonville/.fonts
xset fp rehash

xmonad & wmpid=$!


xautolock -time 1 -locker xtrlock &
source /home/mgrenonville/.screenlayout/.screens.sh
fdpowermon &
xbindkeys
#insync start 
feh --bg-fill Pictures/P-Space_Zoom.jpg Pictures/hierarchy-impure.jpeg
wait $wmpid
keychain --stop all

