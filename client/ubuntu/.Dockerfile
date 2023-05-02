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

RUN --mount=type=cache,id=apt-get-cache,target=/var/cache/apt \
    apt-get update && \
    apt install git pip -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN git clone "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${CLIENT_REPO}" /app
RUN ls /app

RUN pip install -r requirements.txt || echo "Requirements file not found"

COPY /client/ubuntu/init.sh /
ENTRYPOINT [ "/init.sh","/bin/bash" ]