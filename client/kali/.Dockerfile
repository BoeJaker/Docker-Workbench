FROM kalilinux/kali-last-release as base

ENV DEBIAN_FRONTEND=noninteractive

# Update necessary packages
RUN apt-get update
RUN apt-get upgrade -y && apt-get autoremove -y && apt-get clean

RUN apt-get install nano -y
RUN apt-get install apt-utils -y

# Install VNC packages
RUN apt-get install kali-desktop-xfce -y
RUN apt-get install x11vnc -y
# RUN apt-get install firefox-esr -y
RUN apt-get install xvfb -y
# RUN apt-get install xauth -y
# RUN apt-get install xfce4 -y
RUN apt-get install xfce4-terminal -y
# RUN apt-get install xfce4-goodies -y

#Setup terminal environment variables
RUN export TERM=xterm
RUN export SHELL=/bin/bash
# RUN source ./.bashrc



FROM base as modified

# Setup postgres request forwarding
RUN apt-get install socat -y
RUN socat TCP-LISTEN:5432,fork TCP:workbench_postgres-log_1:5432 &

# Set up VNC server
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd secret ~/.vnc/passwd

# Maltego & Metasploit
RUN apt-get install metasploit-framework  -y
RUN apt-get install maltego -y
RUN git clone https://github.com/shizzz477/msploitego.git

# Copy metaploit database configuration
COPY ./client/kali/database.yml /usr/share/metasploit-framework/config/database.yml

# RUN rm -R /root/.pyenv 2&>/dev/null

# #pyenv dependencies
# RUN apt-get install python3 python3-pip zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev libreadline-dev -y
# RUN curl https://pyenv.run | bash 

# RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc  
# RUN echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc  
# RUN echo ' eval "$(pyenv init -)"' >> ~/.bashrc 

# RUN export PATH="root/.pyenv/bin:$PATH"
# RUN eval "$(pyenv init -)"
# # eval "$(pyenv virtualenv-init -)"

# RUN pyenv install 2.7.18

# # Switch to python 2.7
# RUN pyenv global 2.7.18

# # msploitego dependencies on python 2.7
# RUN pip install deprecated python-libnmap==0.7.0 NmapParser psycopg2  
# RUN apt-get install libpq-dev -y

# RUN pyenv global system

# Configure SSH server
RUN apt-get install -y openssh-server 
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config
RUN echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Expose VNC port
EXPOSE 22
EXPOSE 6000
EXPOSE 5900
EXPOSE 5901

# Set up display environment variable
ENV DISPLAY=:1

RUN apt-get autoremove -y && apt-get clean


# OS Hardening
FROM modified as hardened

# Disable non-root user creation during the image build
# RUN echo 'kalilinux ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/kalilinux

# Update and upgrade the base system
RUN apt-get update && apt-get upgrade -y

# Install essential security tools and update them
RUN apt-get install -y \
    nmap \
    openssh-client \
    iptables \
    lynis \
    && apt-get clean

# Configure Lynis security auditing tool
# RUN sed -i 's/^# CRONFILE=.*/CRONFILE="no"/' /etc/lynis/lynis.conf

# Remove unnecessary services and packages
RUN apt-get purge -y \
    rpcbind \
    telnet \
    && apt-get autoremove -y && apt-get clean

# Remove unnecessary setuid and setgid files
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN find / -perm /4000 -type f -exec chmod a-s {} \; || true

# Disable core dumps
RUN echo "* hard core 0" > /etc/security/limits.d/10-kali-disable-core-dumps.conf

# Configure sudoers file to limit sudo access
# RUN echo "ALL ALL=(ALL:ALL) ALL" > /etc/sudoers.d/10-kali-security

# Set a secure umask value
RUN echo "umask 027" >> /etc/bash.bashrc

# Network Hardening
# FROM hardened as net-hardened

# # Install IP tables and related tools
# RUN apt-get install -y iptables=1.6.2-1.1

# # Set default policies to DROP
# RUN iptables -P INPUT DROP
# RUN iptables -P OUTPUT DROP
# RUN iptables -P FORWARD DROP

# # Allow loopback traffic
# RUN iptables -A INPUT -i lo -j ACCEPT
# RUN iptables -A OUTPUT -o lo -j ACCEPT

# # Allow established and related incoming connections
# RUN iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# # Allow SSH (replace with your preferred SSH port if necessary)
# RUN iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# # Allow HTTP and HTTPS for web browsing
# RUN iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# RUN iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# # Allow VNC at port 5901
# RUN iptables -A INPUT -p tcp --dport 5901 -j ACCEPT

# # Allow X11 forwarding from port 6000
# RUN iptables -A INPUT -p tcp --dport 6000 -j ACCEPT

# # Allow DNS for name resolution
# RUN iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# # Allow established outgoing connections
# RUN iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# # Drop all other incoming and outgoing traffic
# RUN iptables -A INPUT -j DROP
# RUN iptables -A OUTPUT -j DROP

# # Save IP tables rules
# RUN iptables-save > /etc/iptables/rules.v4


# Copy scripts and add execution permissions
COPY ./client/kali/init.sh /init.sh
COPY ./client/kali/change_python_version.sh /root/change_python_version.sh
RUN chmod +x /init.sh
RUN chmod +x /root/change_python_version.sh
ENV DEBIAN_FRONTEND=interactive
# Start Xvfb and VNC server
CMD [ "/bin/sh", "/init.sh"  ]
