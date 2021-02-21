#!/bin/bash

BASEDIR=$(dirname $BASH_SOURCE)

# find all iso files
for ISO_FILE in $(find $BASEDIR -type f -name "*.iso")
do
  LOCAL_ISO_DIR="$(dirname $ISO_FILE)/iso"
  # mount the iso file to a local folder called iso
  test -d $LOCAL_ISO_DIR || mkdir $LOCAL_ISO_DIR
  mount -v -o ro $ISO_FILE $LOCAL_ISO_DIR 
done

