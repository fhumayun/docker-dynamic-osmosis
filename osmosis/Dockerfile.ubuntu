FROM ubuntu:20.10

RUN apt update && apt install -y openjdk-8-jre

COPY osmosis.tar.gz /tmp/
RUN mkdir /app
RUN tar xf /tmp/osmosis.tar.gz --directory=/app
RUN rm /tmp/osmosis.tar.gz

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
