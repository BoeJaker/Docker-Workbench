FROM codercom/code-server:latest

RUN apt update
RUN apt install pip
COPY ./services/dev/.bashrc /
RUN echo /.bashrc >> ~/.bashrc
RUN rm /.bashrc
