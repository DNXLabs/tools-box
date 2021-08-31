FROM amazon/aws-cli:latest

RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm" && \
    yum install -y ./session-manager-plugin.rpm && \
    rm session-manager-plugin.rpm

WORKDIR /work