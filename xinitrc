## Don't forget to ln -s ~/.xinitrc ~/.xsession if necessary 

exec >> .session.log 2>> .session.err
.screenlayout/single.sh
echo "xinitrc : `date`"
echo 1>&2 "xinitrc : `date`"

setxkbmap us  -variant qwerty-fr

screen -dmS cmus /usr/bin/cmus
# before starting xmonad, we want a correct X db and a running urxvt daemon
xrdb -merge ~/.Xresources
xbindkeys
xscreensaver &
nm-applet &
fdpowermon &
#redshift-gtk  -c ~/dotfiles/redshift.conf &

xset +fp /home/mgrenonville/.fonts
xset fp rehash

xmonad & wmpid=$!

xautolock -time 1 -locker xtrlock &
source /home/mgrenonville/.screenlayout/.screens.sh
pkill insync 
#insync start 
feh --bg-fill Pictures/Dorothy-0113-Alternative-Love-HP.jpg
wait $wmpid
keychain --stop all

