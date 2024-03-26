# Use the official Rust base image
FROM rust:latest

# Install system dependencies
RUN apt-get update && apt-get install -y openssh-server git unzip

# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
EXPOSE 22

# Set up the application
RUN mkdir /app
WORKDIR /app

# Set environment variables for the Git repository
ENV GIT_PULL=true
ENV GIT_REPO_URL="https://github.com/example/repo.git"
ENV GIT_REPO_NAME="repo"

# Clone or pull the repository
RUN if [ "$GIT_PULL" = "true" ] ; then git clone ${GIT_REPO_URL} /${GIT_REPO_NAME} ; fi
RUN if [ "$GIT_PULL" = "true" ] ; then cd /${GIT_REPO_NAME} ; fi

# Build your Rust project
RUN cargo build

# Clean up unused dependencies and cache
RUN apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Start the SSH server and run the startup script
CMD ["/usr/sbin/sshd", "-D"]
