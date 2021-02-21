FROM ubuntu:20.04


ARG DEBCONF_NONINTERACRTIVE_SEEN=true
ARG DEBCONF_FRONTEND=noninteractive
ARG TERM=xterm

COPY packages /packages
RUN apt-get update && \
    xargs -a /packages -t -n1 apt-get install -y

# get packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get install -y packer

WORKDIR /builder
VOLUME /packer_env

COPY build.yml /builder
COPY .create_packer_env.yml /builder
COPY templates/ /builder/templates/

ENTRYPOINT ["ansible-playbook", "-e", "packer_env_folder=/packer_env", "build.yml" ]
