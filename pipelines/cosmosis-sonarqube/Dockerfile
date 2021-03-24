FROM ubuntu:20.10

RUN apt update && apt install -y bear make g++ python3 libboost-all-dev wget git zip
RUN apt install -y clang-tidy openjdk-11-jre nodejs

# Get run-clang-tidy.py python script to easily execute analysis recursively
RUN wget https://raw.githubusercontent.com/llvm-mirror/clang-tools-extra/1c8cadde7ea4ca20a449edcffe10d23b612fe5d6/clang-tidy/tool/run-clang-tidy.py

# Setup sonar-scanner
RUN wget -O /tmp/sonar-scanner.zip \
        https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.0.2311.zip && \
    unzip /tmp/sonar-scanner.zip -d /tmp/sonar-scanner && \
    mv /tmp/sonar-scanner/* /sonar-scanner && \
    rm -rf /tmp/sonar*
ENV PATH="/sonar-scanner/bin:$PATH"

COPY dockerd-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["dockerd-entrypoint.sh"]

