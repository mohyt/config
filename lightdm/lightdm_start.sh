#!/bin/sh

# multi-monitor setup
xrandr --output LVDS1 --preferred --primary
xrandr --output VGA1 --preferred --right-of LVDS1
xbacklight -set 50

numlockx &

# additional partitions mounting
#mount /dev/sda4 /mnt
