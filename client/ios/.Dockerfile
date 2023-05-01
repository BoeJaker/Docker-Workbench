ARG ANDROID_IMAGE="quamotion/appium-docker-ios"
ARG ANDROID_DIGEST="latest"
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN
ARG REPO_URL

FROM $IOS_IMAGE:$IOS_DIGEST

RUN || \
    echo "Unsupported package manager"
RUN git clone $REPO_URL /app