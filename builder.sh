#!/bin/bash

# 
# build a packer-esxi container image
# create a volume to store the packer_env vars
# run the container image and pass through arguments array to the running container
#
docker image inspect packer-esxi:latest &> /dev/null || docker build -t packer-esxi:latest .
docker volume create packer_env &> /dev/null
docker run --network=host -it -v packer_env:/packer_env --rm packer-esxi:latest $@
