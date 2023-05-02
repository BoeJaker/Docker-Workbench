ARG UBUNTU_IMAGE=ubuntu
ARG UBUNTU_DIGEST=latest

FROM ${UBUNTU_IMAGE}:${UBUNTU_DIGEST}

VOLUME [ "/Games" ]

RUN apt-get update && \
    apt install python3 pip -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


COPY /services/ftp/init.sh /
RUN chmod +x /init.sh

WORKDIR /Games
ENTRYPOINT [ "/init.sh","/bin/bash" ]