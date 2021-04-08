FROM ubuntu:20.10

RUN apt update && apt install -y openjdk-8-jre

# CMD cd /app/cloud && ./bin/cloud -w ../manager/ -s  ../star_local.jks
# CMD bash

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
