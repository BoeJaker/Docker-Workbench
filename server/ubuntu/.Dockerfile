ARG UBUNTU_IMAGE=ubuntu
ARG UBUNTU_DIGEST=latest

FROM ubuntu

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG SERVER_REPO

RUN echo ${GITHUB_USERNAME}
RUN echo ${GITHUB_TOKEN}
RUN echo ${SERVER_REPO}

RUN apt update 
RUN apt install git pip -y
RUN git clone "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${CLIENT_REPO}" /app

# RUN pip install -r requirements.txt 
