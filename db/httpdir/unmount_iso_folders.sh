#!/bin/bash

BASEDIR=$(dirname $BASH_SOURCE)

# find all iso folders
for ISO_FOLDER in $(find $BASEDIR -type d -name iso)
do
  umount -v $ISO_FOLDER
  rmdir $ISO_FOLDER
done
