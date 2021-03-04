#!/bin/bash

if [[ ! -e config.yml ]]
then
  echo config.yml doesnt exist
fi

docker image inspect packer-esxi:latest &> /dev/null || docker build -t packer-esxi:latest .
docker run --network=host -it -v $PWD/config.yml:/build/config.yml -v $PWD/blob:/build/blob --rm packer-esxi:latest $@
