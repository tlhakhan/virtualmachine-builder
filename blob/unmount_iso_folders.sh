#!/bin/bash

BASEDIR=$(dirname $BASH_SOURCE)
ISO_DIR="iso_contents"

# find all iso folders
for ISO_FOLDER_PATH in $(find $BASEDIR -type d -name $ISO_DIR)
do
  umount -v $ISO_FOLDER_PATH
  rmdir $ISO_FOLDER_PATH
done
