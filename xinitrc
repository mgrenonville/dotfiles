## Don't forget to ln -s ~/.xinitrc ~/.xsession if necessary 

exec >> .session.log 2>> .session.err

echo "xinitrc : `date`"
echo 1>&2 "xinitrc : `date`"

setxkbmap us  -variant qwerty-fr


# before starting xmonad, we want a correct X db and a running urxvt daemon
xrdb -merge ~/.Xresources
xbindkeys
xscreensaver &
redshift-gtk  -c ~/dotfiles/redshift.conf &

xmonad & wmpid=$!

source /home/mgrenonville/.screenlayout/.screens.sh
pkill insync 
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 58 --transparent true --tint 0x000000 --height 15 --monitor 0 --widthtype pixel &
insync start 
feh --bg-fill Pictures/P-Space_Zoom.jpg
wait $wmpid
keychain --stop all

