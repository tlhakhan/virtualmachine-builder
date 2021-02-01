#!/bin/bash

# ubuntu
get_packer_ubuntu() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install packer
}

if [[ $(lsb_release -si) == "Ubuntu" ]]
then
  get_packer_ubuntu
fi
