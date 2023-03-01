FROM google/cloud-sdk:latest

RUN apt-get update && apt-get install -y zip unzip groff jq yq gettext-base && apt-get clean
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
        && unzip awscliv2.zip \
        && ./aws/install \
        && rm awscliv2.zip
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null \
        && apt-get install apt-transport-https --yes \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
        && apt-get update \
        && apt-get install -y helm \
        && apt-get clean
RUN mkdir -p /opt/ci-helpers
COPY ./scripts/ /opt/ci-helpers
COPY ./bin/ /usr/local/bin
RUN chmod +x /usr/local/bin/*
