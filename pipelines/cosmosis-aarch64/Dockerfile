FROM amazonlinux:2 AS core

ENV EPEL_REPO="https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"

# Install git, SSH, and other utilities
RUN set -ex \
    && yum install -y openssh-clients \
    && mkdir ~/.ssh \
    && touch ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H github.com >> ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H bitbucket.org >> ~/.ssh/known_hosts \
    && chmod 600 ~/.ssh/known_hosts \
    && yum install -y $EPEL_REPO \
    && yum groupinstall -y "Development tools" \
    && yum install -y \
           GeoIP-devel bzip2-devel \
           dpkg-dev e2fsprogs expat-devel expect fakeroot \
           glib2-devel gzip icu iptables jq \
           libcurl-devel libdb-devel libedit-devel libevent-devel libffi-devel \
           libicu-devel libserf \
           libtidy-devel libunwind libwebp-devel libxml2-devel libxslt libxslt-devel \
           libyaml-devel libzip-devel mlocate \
           ncurses-devel oniguruma-devel openssl openssl-devel \
           procps-ng python-configobj readline-devel rsync sgml-common \
           tar tcl tk vim wget which xfsprogs xmlto xz-devel

# Install Git
RUN set -ex \
   && GIT_VERSION=2.27.0 \
   && GIT_TAR_FILE=git-$GIT_VERSION.tar.gz \
   && GIT_SRC=https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz  \
   && curl -L -o $GIT_TAR_FILE $GIT_SRC \
   && tar zxvf $GIT_TAR_FILE \
   && cd git-$GIT_VERSION \
   && make -j4 prefix=/usr \
   && make install prefix=/usr \
   && cd .. ; rm -rf git-$GIT_VERSION \
   && rm -rf $GIT_TAR_FILE /tmp/*

# Install stunnel
RUN set -ex \
   && STUNNEL_VERSION=5.56 \
   && STUNNEL_TAR=stunnel-$STUNNEL_VERSION.tar.gz \
   && STUNNEL_SHA256="7384bfb356b9a89ddfee70b5ca494d187605bb516b4fff597e167f97e2236b22" \
   && curl -o $STUNNEL_TAR https://www.usenix.org.uk/mirrors/stunnel/archive/5.x/$STUNNEL_TAR \
   && echo "$STUNNEL_SHA256 $STUNNEL_TAR" | sha256sum -c - \
   && tar xvfz $STUNNEL_TAR \
   && cd stunnel-$STUNNEL_VERSION \
   && ./configure \
   && make -j4 \
   && make install \
   && openssl genrsa -out key.pem 2048 \
   && openssl req -new -x509 -key key.pem -out cert.pem -days 1095 -subj "/C=US/ST=Washington/L=Seattle/O=Amazon/OU=Codebuild/CN=codebuild.amazon.com" \
   && cat key.pem cert.pem >> /usr/local/etc/stunnel/stunnel.pem \
   && cd .. ; rm -rf stunnel-${STUNNEL_VERSION}*

# AWS Tools
# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
RUN curl -sS -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator
RUN curl -sS -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest 
RUN chmod +x /usr/local/bin/aws-iam-authenticator /usr/local/bin/ecs-cli

#########################
# Setup GCC 8

RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7

RUN yum install -y yum-utils
RUN yum-config-manager --add-repo http://mirror.centos.org/altarch/7/extras/aarch64/
RUN yum-config-manager --add-repo http://mirror.centos.org/altarch/7/sclo/aarch64/rh/

RUN yum install -y centos-release-scl-rh

RUN wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/libgfortran5-8.3.1-2.1.1.el7.aarch64.rpm
RUN yum install -y libgfortran5-8.3.1-2.1.1.el7.aarch64.rpm

RUN yum install -y devtoolset-8 --nogpgcheck

RUN yum remove -y yum-utils

COPY enable_scl_8.sh /etc/profile.d/

#########################
# Setup Python 3 and Conan
RUN yum install -y python3
RUN pip3 install conan
RUN yum install -y cmake

#########################
# COPY dockerd-entrypoint.sh /usr/local/bin/

# ENTRYPOINT ["dockerd-entrypoint.sh"]

