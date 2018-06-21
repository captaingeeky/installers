#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

echo -e "${GREEN} Creating Directories... ${NC}"
mkdir ~/ganja
mkdir ~/.Ganjaproject2

echo -e "${YELLOW} Copying files... ${NC}"
mv database ~/.Ganjaproject2
mv txleveldb ~/.Ganjaproject2
mv blk0001.dat ~/.Ganjaproject2
mv Ganjaproject.conf ~/.Ganjaproject2
mv mncache.dat ~/.Ganjaproject2
mv peers.dat ~/.Ganjaproject2
mv ganjacoind ~/ganja

MYIP=$(curl -4 icanhazip.com)
echo -e "${BLUE} Select the current IP address to paste in the config: ${GREEN} $MYIP ${NC}"
read -n 1 -s -r -p "Press any key to continue to edit config file"
nano ~/.Ganjaproject2/Ganjaproject.conf

echo -e "${YELLOW} Starting Daemon... ${NC}"
~/ganja/ganjacoind -daemon
