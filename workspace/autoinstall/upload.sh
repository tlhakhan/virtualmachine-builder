#!/bin/bash

# Description:
# This is a helper script that will upload all the directories into a generic repo called 'files'.
# It's equivalent to serving this directory as a static web server.

BASEDIR=$(dirname $BASH_SOURCE)

for folder in $(ls -1d ./*/)
do
  echo Uploading $folder to files
  jfrog rt u --flat=false $folder files
  echo
done
