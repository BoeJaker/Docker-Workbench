FROM kalilinux/kali-rolling

# Install necessary packages
RUN apt-get update && apt-get install -y \
    kali-desktop-xfce \
    tightvncserver \
    xfonts-base \
    x11vnc \
    novnc \
    websockify \
    xfce4-terminal \
    firefox-esr

# Set up VNC server
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd secret ~/.vnc/passwd

# Set up VNC startup script
RUN echo "#!/bin/bash" > ~/.vnc/xstartup
RUN echo "xrdb $HOME/.Xresources" >> ~/.vnc/xstartup
RUN echo "startxfce4 &" >> ~/.vnc/xstartup
RUN echo "export DISPLAY=:1" >> ~/.vnc/xstartup

# Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 6080

# Start VNC server and noVNC proxy
CMD x11vnc -forever -shared -rfbport 5901 -passwdfile ~/.vnc/passwd & websockify --web /usr/share/novnc/ --wrap-mode=ignore --tcp-only --target-config=/root/.vnc/host:5901 localhost:6080
