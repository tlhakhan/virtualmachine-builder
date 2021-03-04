FROM ubuntu:20.04

# needed for package installs
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm

# list of base packages to install
RUN apt-get update && \
    apt-get install -y ansible apt-utils curl dialog gnupg lsb-release psmisc software-properties-common

# get packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get install -y packer

# setup build area
WORKDIR /build

STOPSIGNAL SIGINT
# ENTRYPOINT ["./docker-entrypoint.sh"]
