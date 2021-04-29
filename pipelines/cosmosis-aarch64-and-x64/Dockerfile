FROM centos:8

RUN yum groupinstall -y "Development tools" 
RUN dnf install -y python3 cmake jq git sudo
RUN pip3 install conan==1.35.0

RUN dnf install -y dnf-plugins-core \
      && dnf config-manager --set-enabled powertools \
      && dnf -y install doxygen