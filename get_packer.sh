#!/bin/bash

# ubuntu
get_packer_ubuntu() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  apt-get update && sudo apt-get install packer
}

if [[ $(lsb_release -i | awk -F ':\t' '{print $2}') == "Ubuntu" ]]
then
  get_packer_ubuntu
fi
