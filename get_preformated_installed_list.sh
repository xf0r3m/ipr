#!/bin/bash

apt-get update > /dev/null 2>&1;
#apt list | grep 'installed' | awk '{printf $1" "$2"\n"}' | sed -e "s/\/${1},.*\ / /g" -e "s/\/${1}\ / /g" -e "s/\/now\ / /g"
apt list | grep 'installed' | awk '{printf $1" "$2"\n"}' | sed -e "s/\/${1},.*\ / /g" -e "s/\/${1}\ / /g" -e "s/\/now\ / /g" -e "s/\/${1}-security,now\ / /g";
