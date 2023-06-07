FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    fluxbox

COPY ./services/vnc/init.sh /init.sh
COPY ./services/vnc/switch_display.sh /switch_display.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/bin/bash", "/init.sh"]