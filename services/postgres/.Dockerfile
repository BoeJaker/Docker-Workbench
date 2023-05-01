ARG POSTGRES_IMAGE="postgres"
ARG POSTGRES_DIGEST=":latest"
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG CLIENT_REPO

FROM $POSTGRES_IMAGE$POSTGRES_DIGEST

RUN apt update && \ 
    apt install git pip -y

RUN mkdir ./app && \
    git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@$CLIENT_REPO ./app && \
    cd ./app

RUN pip install -r requirements.txt 
