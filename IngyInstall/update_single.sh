#!/bin/bash
#############################################################
## Masternode Update Script by Chris aka @bitmonopoly 2019 ##
#############################################################
tarFILE="Ingenuity-.Ubuntu_Daemon.tar.gz"
tarURL="https://github.com/IngenuityCoin/Ingenuity/files/2919098/$tarFILE"
PROJECT="Ingenuity"

red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'

echo -e "${yel}Updating $PROJECT binaries...${clr}"
cd /usr/local/bin
rm ing*
wget $tarURL
tar -xf $tarFILE
rm $tarFILE
echo
echo -e "${grn}Stopping Daemon...${clr}"
cd ~
systemctl stop Ingenuity.service
sleep 15
echo
echo -e "${grn}Starting Daemon...${clr}"
systemctl start Ingenuity.service
echo -e "${blu}Daemon updated to version below:${yel}"
ingenuity-cli --version
echo -e "${clr}"
echo "${yel}****************************************************************"
echo "** ${red}Remember to download the new QT wallet (if applies) and to ${yel}**"
echo "** ${red}restart your masternode in your QT wallet!!!               ${yel}**"
echo "****************************************************************${clr}"
