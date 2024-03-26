# Virtual Python Development Environment

# Use the official Python base image
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y openssh-server git unzip

# Install Python dependencies
RUN pip install tox virtualenv pytest mock

# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
EXPOSE 22

# Set up the application
RUN mkdir /app
RUN if [ "$GIT_PULL" = "true" ] ; then cd /app ; fi

# Extract the repository name from the URL
RUN if [ "$GIT_PULL" = "true" ] ; then GIT_REPO_NAME=$(echo "$GIT_REPO_URL" | sed -E 's|.*/(.+).git|\1|') && \
    echo "Repository Name: $GIT_REPO_NAME" ; fi

# Clone or pull the repository
RUN if [ "$GIT_PULL" = "true" ] ; then git clone ${GIT_REPO_URL} /${GIT_REPO_NAME} ; fi
RUN if [ "$GIT_PULL" = "true" ] ; then cd /${GIT_REPO_NAME} ; fi

# Install dependencies from requirements.txt or fallback to dynamic detection
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt || \
    (apt-get install -y unzip && \
    wget -O - https://github.com/jazzband/pip-tools/archive/refs/tags/v6.4.0.zip | \
    unzip - && \
    cd pip-tools-6.4.0 && \
    python3 -m pip install --no-cache-dir . && \
    cd .. && \
    rm -rf pip-tools-6.4.0 && \
    pip-compile --output-file=requirements.txt)

# Clean up unused dependencies and cache
RUN apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY startup.sh ./

# Set the entry point to run the Python script
CMD ["sh", "-c", "./startup.sh"]

