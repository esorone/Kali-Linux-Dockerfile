#!/bin/bash

# Check if /tmp/.X11-unix/* exists
if ls /tmp/.X11-unix/*; then
    echo "Removing /tmp/.X11-unix/..."
    sudo rm /tmp/.X11-unix/*
    sudo rm -R /tmp/.X1-lock
else
    echo "/tmp/.X11-unix/ does not exist, running VNC server..."
    sudo vncserver -geometry 1920x1080 :1
fi
