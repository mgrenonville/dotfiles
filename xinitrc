exec >> .session.log 2>> .session.err

echo "xinitrc : `date`"
echo 1>&2 "xinitrc : `date`"

# before starting xmonad, we want a correct X db and a running urxvt daemon
xrdb -merge ~/.Xresources
xbindkeys


xmonad & wmpid=$!

setxkbmap fr
source /home/mgrenonville/.screens.sh

wait $wmpid
keychain --stop all
