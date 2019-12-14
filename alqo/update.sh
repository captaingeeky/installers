#!/bin/bash
# wget https://raw.githubusercontent.com/zaemliss/installers/master/atheneum/update.sh -O update.sh && chmod +x update.sh && ./update.sh

VERSION="1.0.6"
PROJECT="Alqo"
PROJECT_FOLDER="$HOME/ALQO"
DAEMON_BINARY="alqod"
CLI_BINARY="alqo-cli"

red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'

printf '\e[48;5;0m'
clear

echo -e "${yel}Searching for Alqo binaries and installation directories...${clr}"
echo
client=$(find ~/ -name "alqo-cli" | head -n 1) > /dev/null 2>&1
workDir=$(dirname "$client")

#Get number of existing masternode directories
DIR_COUNT=$(ls -la /root/ | grep "\.alqocrypto" | grep -c '^')

if [[ $DIR_COUNT -lt 1 ]]; then
  echo -e "${red}No data directories found! Please make sure you have Alqo Masternodes installed on this server.${clr}"
  exit 1;
fi
echo -e "${grn}Alqo binaries found in $workDir .${clr}"
#echo -e "${blu}$DIR_COUNT Alqo installations found!${clr}"
echo

echo -e "${grn}Stopping Daemon using datadir /.alqocrypto"
cd ALQO
./alqo-cli stop
#$client -datadir=/root/.alqocrypto -conf=/root/.alqo/alqo.conf stop

#if [[ $DIR_COUNT -gt 1 ]]; then
#  for i in `seq 2 $DIR_COUNT`;
#    do
#      echo -e "${grn}Stopping Daemon using datadir .alqo$i"
  #    $client -datadir=/root/.alqo$i -conf=/root/.alqo$i/alqo.conf stop
#    done
#fi
echo

echo -e "${blu}Downloading new binaries...${clr}"
sleep 10
echo
cd ALQO
rm alqod
rm alqo-cli

wget https://github.com/ALQO-Universe/ALQO/releases/download/v6.2.0.0-d4d958e4f/ALQO-v6.2.0.0-d4d958e4f-lin64.tgz > /dev/null 2>&1
tar zxvf ALQO-v6.2.0.0-d4d958e4f-lin64.tgz -C ~/ALQO  > /dev/null 2>&1

chmod +x ~/ALQO/alqod ~/ALQO/alqo-cli
echo -e "${grn}Starting Daemon using datadir /.alqo"
#$workDir/alqod -datadir=/root/.alqo -conf=/root/.alqo/alqo.conf -daemon
cd ~/ALQO  > /dev/null 2>&1
./alqod -daemon
#if [[ $DIR_COUNT -gt 1 ]]; then
  #for i in `seq 2 $DIR_COUNT`;
  #  do
  #    echo -e "${grn}Starting Daemon using datadir /.alqo$i"
  #    $workDir/alqod -datadir=/root/.alqo$i -conf=/root/.alqo$i/alqo.conf -daemon
  #  done
  #  sleep 3
#fi
echo
echo -e "Waiting 10 seconds for all daemons to start up..."
echo
sleep 10
echo -e "${blu}Update complete. Alqo now updated to version below.${yel}"
#$workDir/alqod -datadir=/root/.alqo$i -conf=/root/.alqo$i/alqo.conf --version | head -n 1
#echo -e "${blu}Version : ${grn}" $($workDir/alqo-cli -datadir=/root/.alqo -conf=/root/.alqo/alqo.conf getinfo | grep '"version":' | tr -d '"version:, ')
#echo -e "${blu}Protocol: ${grn}" $($workDir/alqo-cli -datadir=/root/.alqo -conf=/root/.alqo/alqo.conf getinfo | grep '"protocolversion":' | tr -d '"protocolversion:, ')
echo
echo -e "${red} !!! IMPORTANT !!! ${grn}"
echo -e "Don't forget to update your QT wallet with the latest executables. \nYou can find them at the official repo at:"
echo -e "${blu}https://github.com/ALQO-Universe/ALQO/releases ${clr}"  #need static installer link
echo
