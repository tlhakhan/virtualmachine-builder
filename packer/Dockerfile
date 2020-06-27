FROM repo.home.local/tlhakhan/centos8:latest

ENV PACKER_VERSION=1.5.4

RUN yum makecache && \
    yum install -y unzip python3 python3-pip ansible vim vim-enhanced jq

RUN curl -o /tmp/packer.zip http://repo.home.local/artifactory/downloads/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip /tmp/packer.zip -d /usr/local/sbin && \
    chmod +x /usr/local/sbin/packer

WORKDIR /packer
