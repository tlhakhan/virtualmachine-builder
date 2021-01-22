#!/bin/bash

vm=$1

if [[ -z $vm ]]
then
  echo usage: $0 [ vm name ]
  echo notes: [ vm name ] is a yml file in var-files.
  exit 1
fi


docker-compose run packer $vm
