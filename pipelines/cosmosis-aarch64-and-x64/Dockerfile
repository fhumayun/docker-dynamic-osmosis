FROM ubuntu:20.10

# Update Ubuntu Software repository
RUN apt-get update

# Upgrade Ubuntu Software repository
RUN apt-get upgrade -y

RUN apt-get install -y build-essential wget curl cmake sudo git jq

WORKDIR /cosmosis
RUN apt-get install python3.8 -y
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 50
RUN apt-get install -y python3-distutils manpages-dev python-dev python3-dev libpython3.8-dev 
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
RUN apt-get install -y python3-pip
RUN pip3 install conan==1.35.0

RUN apt-get install doxygen -y
