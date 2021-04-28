FROM centos:8

RUN yum groupinstall -y "Development tools" \
      && dnf install -y python3 cmake jq git sudo \
      && pip3 install conan==1.35.0