FROM debian:buster-slim

RUN apt update && \
    apt install -y curl

COPY bsp-auto.sh .

CMD ["bash", "bsp-auto.sh"]
