#!/bin/bash

dhclient;
apt-get update > /dev/null 2>&1;
if [ "$1" = "oldoldstable" ]; then
  apt list | grep 'upgradable' | awk '{printf $1" "$2"\n"}' | sed -e "s/\/${1},.*\ / /g" -e "s/\/${1}\ / /g" -e "s/\/${1}\/security\ / /g";
else
  apt list | grep 'upgradable' | awk '{printf $1" "$2"\n"}' | sed -e "s/\/${1},.*\ / /g" -e "s/\/${1}\ / /g" -e "s/\/${1}-security\ / /g";
fi
