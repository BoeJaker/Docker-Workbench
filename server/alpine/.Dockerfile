ARG ALPINE_IMAGE="alpine"
ARG ALPINE_DIGEST="latest"

FROM $ALPINE_IMAGE:$ALPINE_DIGEST

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG SERVER_REPO

RUN apk update && \
    apk add python3 git && \
    git clone "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${CLIENT_REPO}" /app

HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1   
