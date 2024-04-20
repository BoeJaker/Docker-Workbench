FROM corentinth/it-tools:latest as secret-bootstrap
#Busybox

COPY vault-bootstrap/bootstrap.sh /secret/bootstrap.sh
COPY vault-bootstrap/bootstrap.env /secret/bootstrap.env

RUN chown root /secret/bootstrap.sh
RUN chmod +x  /secret/bootstrap.sh

RUN apk update && apk add bash openssl gpg curl
WORKDIR /secret
RUN /secret/bootstrap.sh

# ENTRYPOINT ["/secret/bootstrap.sh"]
# CMD ["/docker-entrypoint.sh nginx", "/bin/bash", "-c", "while true; do echo 'Container is running...'; sleep 10; done"]
