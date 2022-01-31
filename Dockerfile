FROM google/cloud-sdk:latest

RUN apt-get update && apt-get install -y zip unzip groff jq gettext-base && apt-get clean
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
        && unzip awscliv2.zip \
        && ./aws/install \
        && rm awscliv2.zip
RUN mkdir -p /opt/ci-helpers
COPY ./scripts/ /opt/ci-helpers
COPY ./bin/ /usr/local/bin
RUN chmod +x /usr/local/bin/*
