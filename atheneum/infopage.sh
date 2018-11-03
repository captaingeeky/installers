#!/bin/bash
clear

client=$(find ~/ -name "atheneum-cli" | head -n 1)

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;36m'
clear='\033[0m'
cls='\033[2J'

declare -a status
status[0]="Initial Masternode Syncronization"
status[1]="Syncing Masternode Sporks"
status[2]="Syncing Masternode List"
status[3]="Syncing Masternode Winners"
status[4]="Syncing Budget"
status[5]="Masternode Syncronization Timeout"
status[10]="Syncing Masternode Budget Proposals"
status[11]="Syncing Masternode Finalized Budgets"
status[998]="Masternode Sync Failed"
status[999]="Masternode Sync Successful"

while [ 1 ]; do


getinfo=$($client getinfo)
mnsync=$($client mnsync status)
mnstatus=$($client masternode debug)

version=$(echo $getinfo | jq .version)
protocol=$(echo $getinfo | jq .protocolversion)
blocks=$(echo $getinfo | jq .blocks)
connections=$(echo $getinfo | jq .connections)
supply=$(echo $getinfo | jq .moneysupply)

blockchainsynced=$(echo $mnsync | jq .IsBlockchainSynced)
asset=$(echo $mnsync | jq .RequestedMasternodeAssets)
attempt=$(echo $mnsync | jq .RequestedMasternodeAttempt)

logresult=$(tail -n 8 ./.atheneum/debug.log)


echo -e "${cls}"

echo -e "${blue}Protocol    : ${green}$protocol${clear}"
echo -e "${blue}Version     : ${green}$version${clear}"
echo -e "${blue}Connections : ${green}$connections${clear}"
echo -e "${blue}Supply      : ${green}$supply${clear}"
echo
echo -e "${blue}blocks      : ${yellow}$blocks${clear}"
echo
echo -e "${blue}Sync Status : ${green}${status[$asset]} ${blue}attempt ${yellow}$attempt ${blue}of ${yellow}8${clear}"
echo -e "${blue}MN Status   : ${green}$mnstatus${clear}"
echo
echo -e "${yellow}==========================================================================="
echo -e "${blue}$logresult${clear}"
echo -e "${yellow}===========================================================================${clear}"
echo -e "${green} Press CTRL-C to exit. Updated every 2 seconds.${clear}"

sleep 2
done
