#!/bin/bash

rm -R /root/.pyenv

curl https://pyenv.run | bash 
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc  
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc  
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc 
exec $SHELL &
# pyenv install 2.7.18

# echo "select an install size, light, default or large"
# mode=input()

# [ $mode -eq "default" ]{
#     apt-get install kali-linux-default
# }
# [ $mode -eq "large" ]{
#     apt-get install kali-linux-large
# }

# Start VNC session
(Xvfb :1 -screen 0 1920x1080x16 &) && 
(sleep 5 && 
x11vnc -display :1 -forever -usepw -shared -rfbport 5901 -bg) && 
xfce4-session