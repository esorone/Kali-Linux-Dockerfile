#!/bin/bash

file=/tmp/.X1-lock


if [ -e "$file" ]; then
    echo "File exists, so removing X1-Lock"
    sudo rm /tmp/.X1-lock

else
    echo "Running Xtightvnc"
    sudo vncserver -geometry 1920x1080 :1
    pidof Xtightvnc
fi;

dir=/tmp/.X11-unix/

 if [ -d "$dir" ]; then
    echo "Dir exists, so removing X11-unix"
      sudo rm /tmp/.X11-unix/*

 elif [ ! -d "$dir" ]; then
    echo "Dir does exists, so NOT removing X11-unix"
      sudo rm /tmp/.X11-unix/*

else echo "Next Step and starting server";

fi;

    echo "Running Xtightvnc"
var1='sudo kill -9'
var2=`pidof Xtightvnc`
var4="${var1} ${var2}"
echo $var4
$var4

    sudo vncserver -geometry 1920x1080 :1
