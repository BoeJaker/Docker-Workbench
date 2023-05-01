ARG UBUNTU_IMAGE=ubuntu
ARG UBUNTU_DIGEST=latest
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG CLIENT_REPO

FROM ${UBUNTU_IMAGE}:${UBUNTU_DIGEST}

RUN echo "GITHUB_USERNAME: ${GITHUB_USERNAME}"
RUN echo "GITHUB_TOKEN: $GITHUB_TOKEN"
RUN echo "CLIENT_REPO: $CLIENT_REPO"
RUN printenv

RUN apt update 
RUN apt install git pip -y

RUN mkdir ./app && \
    git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@$CLIENT_REPO /app && \
    cd ./app
# ENTRYPOINT git clone https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${CLIENT_REPO} /app
# RUN pip install -r requirements.txt 

COPY ./init.sh /
ENTRYPOINT [ "/init.sh" ]