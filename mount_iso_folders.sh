#!/bin/bash

BASEDIR=$(dirname $BASH_SOURCE)

# find all iso files
for ISO_FILE in $(find $BASEDIR -type f -name "*.iso")
do

  LOCAL_DIR="$(dirname $ISO_FILE)"
  if [[ $LOCAL_DIR =~ packer_cache$ ]]
  then
    continue
  fi

  LOCAL_ISO_DIR="$LOCAL_DIR/iso"
  # mount the iso file to a local folder called iso
  test -d $LOCAL_ISO_DIR || mkdir $LOCAL_ISO_DIR
  mount -v -o ro $ISO_FILE $LOCAL_ISO_DIR 
done

