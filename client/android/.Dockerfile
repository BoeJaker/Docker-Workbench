ARG ANDROID_IMAGE="cimg/android"
ARG ANDROID_DIGEST="latest"
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG REPO_URL

FROM $ANDROID_IMAGE:$ANDRIOD_DIGEST

RUN apk update && apk add --no-cache git || \
    echo "Unsupported package manager"

RUN git clone $REPO_URL /app