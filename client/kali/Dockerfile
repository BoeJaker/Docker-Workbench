FROM kalilinux/kali-rolling

# Update and install required packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openssh-server xauth xfce4 xfce4-goodies x11vnc xvfb

# Configure SSH server
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config
RUN echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Set up Xvfb
ENV DISPLAY :1
RUN Xvfb $DISPLAY -screen 0 1280x800x24 &

# Set up x11vnc
RUN mkdir -p /root/.vnc
RUN x11vnc -storepasswd password /root/.vnc/passwd

# Expose SSH, X11, and VNC ports
EXPOSE 22
EXPOSE 6000
EXPOSE 5900

# Start SSH and x11vnc services
CMD service ssh start && x11vnc -display $DISPLAY -rfbauth /root/.vnc/passwd -bg -forever && tail -f /dev/null
