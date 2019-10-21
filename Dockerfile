FROM google/cloud-sdk:latest

RUN apt-get update && apt-get install -y zip unzip python3-pip groff jq gettext-base && apt-get clean
RUN /usr/bin/pip3 install awscli --upgrade
RUN mkdir -p /opt/ci-helpers
COPY ./scripts/ /opt/ci-helpers
COPY ./bin/ /usr/local/bin
RUN chmod +x /usr/local/bin/*
