#!/bin/bash

read -p "ESX Build Server: " ESX_BUILD_SERVER
read -p "ESX Build Datastore: " ESX_BUILD_DATASTORE
read -p "ESX Build Network: " ESX_BUILD_NETWORK
read -p "ESX Build Username: " ESX_BUILD_USERNAME
read -sp "ESX Build Password: " ESX_BUILD_PASSWORD
echo
echo Creating .env file
cat << eof > .env
export ESX_BUILD_SERVER=$ESX_BUILD_SERVER
export ESX_BUILD_DATASTORE=$ESX_BUILD_DATASTORE
export ESX_BUILD_NETWORK=$ESX_BUILD_NETWORK
export ESX_BUILD_USERNAME=$ESX_BUILD_USERNAME
export ESX_BUILD_PASSWORD=$ESX_BUILD_PASSWORD
eof
