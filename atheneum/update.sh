#!/bin/bash
# wget https://raw.githubusercontent.com/zaemliss/installers/master/atheneum/update.sh -O update.sh && chmod +x update.sh && ./update.sh

VERSION="1.0.6"
PROJECT="Atheneum"
PROJECT_FOLDER="$HOME/Atheneum"
DAEMON_BINARY="atheneumd"
CLI_BINARY="atheneum-cli"
  
red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'

printf '\e[48;5;0m'
clear

echo -e "${yel}Searching for Atheneum binaries and installation directories...${clr}"
echo
client=$(find ~/ -name "atheneum-cli" | head -n 1) > /dev/null 2>&1
workDir=$(dirname "$client")

#Get number of existing Atheneum masternode directories
DIR_COUNT=$(ls -la /root/ | grep "\.Atheneum" | grep -c '^')

if [[ $DIR_COUNT -lt 1 ]]; then
  echo -e "${red}No data directories found! Please make sure you have Atheneum Masternodes installed on this server.${clr}"
  exit 1;
fi
echo -e "${grn}Atheneum binaries found in $workDir .${clr}"
echo -e "${blu}$DIR_COUNT Atheneum installations found!${clr}"
echo

echo -e "${grn}Stopping Daemon using datadir /.Atheneum"
$client -datadir=/root/.Atheneum -conf=/root/.Atheneum/atheneum.conf stop

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Stopping Daemon using datadir .Atheneum$i"
      $client -datadir=/root/.Atheneum$i -conf=/root/.Atheneum$i/atheneum.conf stop
    done
fi
echo

echo -e "${blu}Downloading new binaries...${clr}"
sleep 20
echo
cd $workDir
rm atheneumd
rm atheneum-cli
wget https://github.com/zaemliss/installers/releases/download/1.0.0/atheneumd > /dev/null 2>&1
wget https://github.com/zaemliss/installers/releases/download/1.0.0/atheneum-cli > /dev/null 2>&1
chmod +x $workDir/atheneumd $workDir/atheneum-cli
echo -e "${grn}Starting Daemon using datadir /.Atheneum"
$workDir/atheneumd -datadir=/root/.Atheneum -conf=/root/.Atheneum/atheneum.conf -daemon

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Starting Daemon using datadir /.Atheneum$i"
      $workDir/atheneumd -datadir=/root/.Atheneum$i -conf=/root/.Atheneum$i/atheneum.conf -daemon
    done
    sleep 3
fi
echo
echo -e "Waiting 10 seconds for all daemons to start up..."
echo
sleep 10
echo -e "${blu}Update complete. Atheneum now updated to version below.${yel}"
$workDir/atheneumd -datadir=/root/.Atheneum$i -conf=/root/.Atheneum$i/atheneum.conf --version | head -n 1
echo -e "${blu}Version : ${grn}" $($workDir/atheneum-cli -datadir=/root/.Atheneum -conf=/root/.Atheneum/atheneum.conf getinfo | grep '"version":' | tr -d '"version:, ')
echo -e "${blu}Protocol: ${grn}" $($workDir/atheneum-cli -datadir=/root/.Atheneum -conf=/root/.Atheneum/atheneum.conf getinfo | grep '"protocolversion":' | tr -d '"protocolversion:, ')
echo
echo -e "${red} !!! IMPORTANT !!! ${grn}"
echo -e "Don't forget to update your QT wallet with the latest executables. \nYou can find them at the official repo at:"
echo -e "${blu}https://github.com/AtheneumChain/Atheneum/releases ${clr}"
echo
