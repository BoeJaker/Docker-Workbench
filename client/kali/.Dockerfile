FROM kalilinux/kali-rolling

# Update necessary packages
RUN apt-get update

# Install VNC packages
RUN apt-get install kali-desktop-xfce -y
RUN apt-get install x11vnc -y
RUN apt-get install xfce4-terminal -y
RUN apt-get install firefox-esr -y
RUN apt-get install xvfb -y

RUN apt-get install nano

# Light install


# Setup postgres portforwarding
RUN apt-get install socat -y
RUN socat TCP-LISTEN:5432,fork TCP:workbench_postgres-log_1:5432

# Set up VNC server
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd ${KALI_VNC_PASSWORD} ~/.vnc/passwd
# Expose VNC port
EXPOSE 5901
# Set up display environment variable
ENV DISPLAY=:1

# # X11 forwarding
# ENV DISPLAY=host.docker.internal:0
# EXPOSE 6000

# Copy Kali database configuration
COPY ./client/kali/database.yml /usr/share/metasploit-framework/config/database.yml

# Maltego & Metasploit
RUN apt-get install metasploit-framework -y
RUN apt-get install maltego -y

RUN git clone https://github.com/shizzz477/msploitego.git
RUN apt-get install pyenv
RUN pyenv install 2.7.18
RUN 

RUN useradd -ms /bin/bash boejaker
USER boejaker
COPY ./clients/kali/init.sh /init.sh
RUN chmod +x /init.sh
# Start Xvfb and VNC server
CMD [ "/init.sh" ]