#!/bin/bash
# wget https://raw.githubusercontent.com/zaemliss/installers/master/atheneum/update.sh -O update.sh && chmod +x update.sh && ./update.sh

VERSION="1.0.6"
PROJECT="Atheneum"
PROJECT_FOLDER="$HOME/Atheneum"
DAEMON_BINARY="atheneumd"
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

#Get number of existing Atheneum masternode directories
DIR_COUNT=$(ls -la /root/ | grep "\.alqo" | grep -c '^')

if [[ $DIR_COUNT -lt 1 ]]; then
  echo -e "${red}No data directories found! Please make sure you have Alqo Masternodes installed on this server.${clr}"
  exit 1;
fi
echo -e "${grn}Alqo binaries found in $workDir .${clr}"
echo -e "${blu}$DIR_COUNT Alqo installations found!${clr}"
echo

echo -e "${grn}Stopping Daemon using datadir /.alqo"
$client -datadir=/root/.alqo -conf=/root/.alqo/atheneum.conf stop

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Stopping Daemon using datadir .alqo$i"
      $client -datadir=/root/.alqo$i -conf=/root/.alqo$i/alqo.conf stop
    done
fi
echo

echo -e "${blu}Downloading new binaries...${clr}"
sleep 20
echo
cd $workDir
rm alqod
rm alqo-cli
wget https://github.com/zaemliss/installers/releases/download/1.0.0/atheneumd > /dev/null 2>&1  #need static installer
wget https://github.com/zaemliss/installers/releases/download/1.0.0/atheneum-cli > /dev/null 2>&1 #need static installer
chmod +x $workDir/atheneumd $workDir/alqo-cli
echo -e "${grn}Starting Daemon using datadir /.alqo"
$workDir/alqod -datadir=/root/.alqo -conf=/root/.alqo/alqo.conf -daemon

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Starting Daemon using datadir /.alqo$i"
      $workDir/alqod -datadir=/root/.alqo$i -conf=/root/.alqo$i/alqo.conf -daemon
    done
    sleep 3
fi
echo
echo -e "Waiting 10 seconds for all daemons to start up..."
echo
sleep 10
echo -e "${blu}Update complete. Alqo now updated to version below.${yel}"
$workDir/alqod -datadir=/root/.alqo$i -conf=/root/.alqo$i/alqo.conf --version | head -n 1
echo -e "${blu}Version : ${grn}" $($workDir/alqo-cli -datadir=/root/.alqo -conf=/root/.alqo/alqo.conf getinfo | grep '"version":' | tr -d '"version:, ')
echo -e "${blu}Protocol: ${grn}" $($workDir/alqo-cli -datadir=/root/.alqo -conf=/root/.alqo/alqo.conf getinfo | grep '"protocolversion":' | tr -d '"protocolversion:, ')
echo
echo -e "${red} !!! IMPORTANT !!! ${grn}"
echo -e "Don't forget to update your QT wallet with the latest executables. \nYou can find them at the official repo at:"
echo -e "${blu}https://github.com/AtheneumChain/Atheneum/releases ${clr}"  #need static installer link
echo
