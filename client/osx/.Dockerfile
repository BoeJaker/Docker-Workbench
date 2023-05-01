ARG OSX_IMAGE="sickcodes/docker-osx"
ARG OSX_DIGEST="latest"
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG CLIENT_REPO

FROM $OSX_IMAGE:$OSX_DIGEST 

RUN brew update && \ 
    brew install git pip -y 

RUN git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@$CLIENT_REPO ./app