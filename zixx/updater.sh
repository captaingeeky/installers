#!/bin/bash

VERSION="1.2.19"
PROJECT="Zixx"
PROJECT_FOLDER="$HOME/zixx"
DAEMON_BINARY="zixxd"
CLI_BINARY="zixx-cli"
  
red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clear='\033[0m'

printf '\e[48;5;0m'
clear

client=$(find / -name "zixx-cli" | head -n 1)
workDir=$(basename "$client")

#Get number of existing Zixx masternode directories
DIR_COUNT=$(ls -la /root/ | grep "\.zixx" | grep -c '^')

if [[ $DIR_COUNT -lt 1 ]]; then
  echo -e "${red}No data directories found! Please make sure you have Zixx Masternodes installed on this server.${clear}"
  exit 1;
fi

echo "${blu}$DIR_COUNT Zixx installations found!${clear}"
echo
