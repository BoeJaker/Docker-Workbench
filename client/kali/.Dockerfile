FROM lukaszlach/kali-desktop:lxde

RUN apt get update
RUN apt-get install -y \
  nmap \
  netcat \
  curl \
  wget \
  git \
  vim \
  nano
RUN apt-get install -y kali-linux-all
