ARG ALPINE_IMAGE="alpine"
ARG ALPINE_DIGEST="latest"
ARG SERVER_REPO

FROM $ALPINE_IMAGE:$ALPINE_DIGEST

RUN apk update && \
    apk add python3 git && \
    git clone ${SERVER_REPO}
