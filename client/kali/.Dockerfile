FROM kalilinux/kali-rolling

# Install necessary packages
RUN apt-get update
RUN apt-get install kali-desktop-xfce -y
# RUN apt-get install tightvncserver -y
# RUN apt-get install xfonts-base -y
RUN apt-get install x11vnc -y
# RUN apt-get install novnc -y
RUN apt-get install xfce4-terminal -y
RUN apt-get install firefox-esr -y
RUN apt-get install xvfb

# Set up VNC server
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd secret ~/.vnc/passwd

# Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 6080

# Set up display environment variable
ENV DISPLAY=:1

# Start Xvfb and VNC server
CMD (Xvfb :1 -screen 0 1920x1080x16 &) && (sleep 5 && x11vnc -display :1 -forever -usepw -shared -rfbport 5901 -bg) && xfce4-session