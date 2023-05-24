#!/bin/bash
echo "select an install size, light, default or large"
mode=input()

[ $mode -eq "default" ]{
    apt-get install kali-linux-default
}
[ $mode -eq "large" ]{
    apt-get install kali-linux-large
}

# Start VNC session
(Xvfb :1 -screen 0 1920x1080x16 &) && 
(sleep 5 && 
x11vnc -display :1 -forever -usepw -shared -rfbport 5901 -bg) && 
xfce4-session