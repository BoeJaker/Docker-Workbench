ARG UBUNTU_IMAGE=ubuntu
ARG UBUNTU_DIGEST=latest

FROM ${UBUNTU_IMAGE}:${UBUNTU_DIGEST}

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG CLIENT_REPO

# VOLUME /app

RUN echo ${GITHUB_USERNAME}
RUN echo ${GITHUB_TOKEN}
RUN echo ${CLIENT_REPO}

RUN apt-get update && \
    apt install git pip -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY /client/ubuntu/init.sh /
RUN chmod +x /init.sh
ENTRYPOINT [ "/init.sh","/bin/bash" ]