FROM centos:8

RUN yum update -y
RUN yum groupinstall -y "Development tools"
RUN dnf install -y dnf-plugins-core python3.9 cmake jq git sudo wget git zip
RUN dnf install -y clang java-11-openjdk-devel nodejs

# Install necessary components for bear
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --set-enabled powertools
RUN dnf install -y gsl hdf5
RUN curl -LO https://kojipkgs.fedoraproject.org//packages/bear/2.4.4/1.fc33/x86_64/bear-2.4.4-1.fc33.x86_64.rpm
RUN rpm -i bear-2.4.4-1.fc33.x86_64.rpm

# Get run-clang-tidy.py python script to easily execute analysis recursively
RUN wget https://raw.githubusercontent.com/llvm-mirror/clang-tools-extra/1c8cadde7ea4ca20a449edcffe10d23b612fe5d6/clang-tidy/tool/run-clang-tidy.py

# Setup sonar-scanner
RUN wget -O /tmp/sonar-scanner.zip \
        https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.0.2311.zip && \
    unzip /tmp/sonar-scanner.zip -d /tmp/sonar-scanner && \
    mv /tmp/sonar-scanner/* /sonar-scanner && \
    rm -rf /tmp/sonar*
ENV PATH="/sonar-scanner/bin:$PATH"

RUN pip3 install conan==1.35.0
RUN alternatives --set java java-11-openjdk.x86_64

COPY dockerd-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["dockerd-entrypoint.sh"]

