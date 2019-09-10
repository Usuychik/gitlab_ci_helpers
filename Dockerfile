FROM google/cloud-sdk:latest

RUN apt-get update && apt-get install -y python3-pip groff jq && apt-get clean
RUN /usr/bin/pip3 install awscli --upgrade
RUN mkdir -p /opt/ci-helpers
COPY . /opt/ci-helpers
