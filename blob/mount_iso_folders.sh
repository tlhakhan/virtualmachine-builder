#!/bin/bash

BASEDIR=$(dirname $BASH_SOURCE)
ISO_DIR="iso_contents"

# find all iso files
for ISO_FILE in $(find $BASEDIR -type f -name "*.iso")
do

  # identify the local directory where the iso file is located
  LOCAL_DIR="$(dirname $ISO_FILE)"

  # ignore any iso files found in a path that has pattern `packer_cache`
  if [[ $LOCAL_DIR =~ packer_cache$ ]]
  then
    continue
  fi

  # create a directory called $ISO_DIR in the local directory where the iso file was found
  LOCAL_ISO_DIR="$LOCAL_DIR/$ISO_DIR"
  test -d $LOCAL_ISO_DIR || mkdir $LOCAL_ISO_DIR

  # mount the iso file to a local folder called iso
  mount -v -o ro $ISO_FILE $LOCAL_ISO_DIR 
done
