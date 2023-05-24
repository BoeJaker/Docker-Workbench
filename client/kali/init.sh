#!/bin/bash

rm -R /root/.pyenv

# msploitego dependencies 
sudo apt install zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev libreadline-dev
curl https://pyenv.run | bash 

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc  
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc  
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc 

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# exec $SHELL &
pyenv install 2.7.18

pip install deprecated python-libnmap NmapParser psycopg2  
apt-get install libpq-dev  

echo "select an install size, light, default or large"
read mode

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