# fluentd/Dockerfile

FROM fluent/fluentd:v1.12.0-debian-1.0
USER root
RUN apt update
RUN apt install build-essential ruby-dev libpq-dev -y
# RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "5.2.0"]
# RUN gem update faraday
# RUN gem update fluent-plugin-elasticsearch
RUN ["gem", "install", "fluent-plugin-postgres", "--no-document"]
USER fluent