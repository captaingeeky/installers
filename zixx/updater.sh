#!/bin/bash

VERSION="1.0.4"
PROJECT="Zixx"
PROJECT_FOLDER="$HOME/zixx"
DAEMON_BINARY="zixxd"
CLI_BINARY="zixx-cli"
  
red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'

printf '\e[48;5;0m'
clear

echo -e "${yel}Searching for Zixx binaries and installation directories...${clr}"
echo
client=$(find / -name "zixx-cli" | head -n 1)
workDir=$(dirname "$client")

#Get number of existing Zixx masternode directories
DIR_COUNT=$(ls -la /root/ | grep "\.zixx" | grep -c '^')

if [[ $DIR_COUNT -lt 1 ]]; then
  echo -e "${red}No data directories found! Please make sure you have Zixx Masternodes installed on this server.${clr}"
  exit 1;
fi
echo -e "${grn}Zixx binaries found in $workDir .${clr}"
echo -e "${blu}$DIR_COUNT Zixx installations found!${clr}"
echo

echo -e "${grn}Stopping Daemon using datadir /.zixx"
$client -datadir=/root/.zixx -conf=/root/.zixx/zixx.conf stop

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Stopping Daemon using datadir /.zixx$i"
      $client -datadir=/root/.zixx$i -conf=/root/.zixx$i/zixx.conf stop
    done
fi
echo

echo -e "${blu}Downloading new binaries...${clr}"
echo
wget https://github.com/zixxcrypto/zixxcore/releases/download/v0.16.5/zixxd -O $workDir/zixxd > /dev/null 2>&1
wget https://github.com/zixxcrypto/zixxcore/releases/download/v0.16.5/zixx-cli -O $workDir/zixx-cli> /dev/null 2>&1

echo -e "${grn}Starting Daemon using datadir /.zixx"
$workDir/zixxd -datadir=/root/.zixx -conf=/root/.zixx/zixx.conf -daemon

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Starting Daemon using datadir /.zixx$i"
      $workDir/zixxd -datadir=/root/.zixx$i -conf=/root/.zixx$i/zixx.conf -daemon
    done
fi
echo

echo -e "${blu}Update complete. Zixx now updated to version below.${yel}"
$workDir/zixxd -datadir=/root/.zixx$i -conf=/root/.zixx$i/zixx.conf --version
echo
echo -e "${red} !!! IMPORTANT !!! ${grn}"
echo -e "Don't forget to update your QT wallet with the latest executables. You can find them at the official repo at:"
echo -e "${blu}https://github.com/zixxcrypto/zixxcore/releases/tag/v0.16.5${clr}"
echo e

