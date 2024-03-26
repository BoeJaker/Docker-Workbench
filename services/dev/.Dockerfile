FROM codercom/code-server:latest

RUN apt update

# Python Dev
RUN apt install python3 python3-pip
# Pipreqs to generate requirement files
RUN python3 -m pip install pipreqs

# Install github cli
RUN type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

COPY ./services/dev/.bashrc /
RUN echo /.bashrc >> ~/.bashrc
RUN rm /.bashrc