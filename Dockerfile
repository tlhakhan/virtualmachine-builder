FROM ubuntu:20.04

# needed for package installs
ARG DEBCONF_NONINTERACRTIVE_SEEN=true
ARG DEBCONF_FRONTEND=noninteractive
ARG TERM=xterm

# list of base packages to install
COPY packages /packages
RUN apt-get update && \
    xargs -a /packages -t -n1 apt-get install -y

# get packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get install -y packer

# setup build area
WORKDIR /build
VOLUME /packer_env

# copy ansible playbooks to build area
COPY ansible.cfg .
COPY build.yml .
COPY .create_packer_env.yml .

# copy in packer templates to build area
COPY templates/ ./templates/

ENTRYPOINT ["ansible-playbook", "-e", "packer_env_folder=/packer_env", "build.yml" ]
