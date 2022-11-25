FROM python:slim

RUN apt update && \
    apt install -y jq awscli curl

WORKDIR /apps
COPY ./bsp-auto.sh .

ENTRYPOINT ./bsp-auto.sh
