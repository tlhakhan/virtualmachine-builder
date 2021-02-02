#!/bin/bash

figlet get packer

# ubuntu
get_packer_ubuntu() {
  echo Detected $(lsb_release -sd)
  echo Getting gpg key
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  echo "Adding apt.releases.hashicorp.com repository"
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  echo "Installing packer"
  sudo apt-get update && sudo apt-get install packer
}

if [[ $(lsb_release -si) == "Ubuntu" ]]
then
  get_packer_ubuntu
fi
