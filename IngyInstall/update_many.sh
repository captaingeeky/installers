#!/bin/bash

PROJECT="Ingenuity"
DATAFOLDER=".ingenuity"
FINDFOLDER="\.ingenuity"
CONFIG="ingenuity.conf"
DAEMON_BINARY="ingenuityd"
CLI_BINARY="ingenuity-cli"
REPO="https://github.com/IngenuityCoin/Ingenuity/releases"
tarFILE="Ingenuity-.Ubuntu_Daemon.tar.gz"
tarURL="https://github.com/IngenuityCoin/Ingenuity/files/2919098/$tarFILE"
sudo apt install -y unzip > /dev/null 2>&1

red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'

printf '\e[48;5;0m'
clear

echo -e "${yel}Searching for $PROJECT binaries and installation directories...${clr}"
echo
client=$(find / -name $CLI_BINARY | head -n 1) > /dev/null 2>&1
workDir=$(dirname "$client")

echo -e "${blu}Found ${yel}$client ${blu}in ${yel}$workDir ...${clr}"
sleep 2
#Get number of existing masternode directories
DIR_COUNT=$(ls -la /root/ | grep -c $FINDFOLDER)

if [[ $DIR_COUNT -lt 1 ]]; then
  echo -e "${red}No data directories found! Please make sure you have $PROJECT Masternodes installed on this server.${clr}"
  exit 1;
fi
echo -e "${grn}$PROJECT binaries found in $workDir .${clr}"
echo -e "${blu}$DIR_COUNT $PROJECT installations found!${clr}"
echo

echo -e "${grn}Stopping Daemon using datadir /$DATAFOLDER"
$client -datadir=/root/$DATAFOLDER -conf=/root/$DATAFOLDER/$CONFIG stop

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Stopping Daemon using datadir $DATAFOLDER$i"
      $client -datadir=/root/$DATAFOLDER$i -conf=/root/$DATAFOLDER$i/$CONFIG stop
    done
fi
echo
echo -e "${blu}waiting 60s for processes to end normally..."
echo
sleep 60
echo -e "${red}killing rogue processes that may have stalled...${clr}"
pgrep ingenuityd | xargs kill -9 > /dev/null 2>&1
echo

echo -e "${blu}Downloading new binaries...${clr}"
echo
rm $workDir/$DAEMON_BINARY
rm $workDir/$CLI_BINARY

wget -q $tarURL -O $workDir/$tarFILE
cd $workDir
tar -xf $tarFILE
cd ~

chmod +x $workDir/$DAEMON_BINARY $workDir/$CLI_BINARY
echo -e "${grn}Starting Daemon using datadir /$DATAFOLDER"
$workDir/$DAEMON_BINARY -datadir=/root/$DATAFOLDER -conf=/root/$DATAFOLDER/$CONFIG -daemon

if [[ $DIR_COUNT -gt 1 ]]; then
  for i in `seq 2 $DIR_COUNT`; 
    do 
      echo -e "${grn}Starting Daemon using datadir /$DATAFOLDER$i"
      $workDir/$DAEMON_BINARY -datadir=/root/$DATAFOLDER$i -conf=/root/$DATAFOLDER$i/$CONFIG -daemon
      sleep 4
    done
fi
echo

echo -e "${blu}Update complete. $PROJECT now updated to version below.${yel}"
$workDir/$DAEMON_BINARY -datadir=/root/$DATAFOLDER$i -conf=/root/$DATAFOLDER$i/$CONFIG --version | head -n 1
echo
echo -e "${red} !!! IMPORTANT !!! ${grn}"
echo -e "Don't forget to update your QT wallet with the latest executables. \nYou can find them at the official repo at:"
echo -e "${blu}$REPO${clr}"
echo
echo -e "${grn}Also, on protocol upgrades your nodes will go ${red}MISSING ${grn}in your QT wallet after a few hours. \nPlease ${blu}Start Missing ${grn}when they do.${clr}"
echo
