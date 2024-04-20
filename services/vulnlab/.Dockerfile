FROM yavuzlar/vulnlab:latest

COPY vault-bootstrap/bootstrap.sh /secret/bootstrap.sh
COPY vault-bootstrap/bootstrap.env /secret/bootstrap.env

RUN chmod +x  /secret/bootstrap.sh
RUN apt install gosu

WORKDIR /secret
# RUN /secret/bootstrap.sh
ENTRYPOINT /secret/bootstrap.sh /usr/sbin/run.sh
