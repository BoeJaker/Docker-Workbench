FROM codercom/code-server:latest

RUN apt update
RUN apt install pip
RUN apt install docker
COPY ./services/dev/.bashrc /
RUN echo /.bashrc >> ~/.bashrc
RUN rm /.bashrc
