FROM ubuntu:20.10

RUN apt update && apt install -y openjdk-8-jre

CMD cd /app/cloud && ./bin/cloud -w ../manager/ -s  ../star_local.jks