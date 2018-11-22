#!/bin/bash
# wget https://github.com/zaemliss/installers/raw/master/atheneum/infopage.sh -O infopage.sh
# User Friendly Masternode infopage by @bitmonopoly 2018

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;36m'
clear='\033[0m'
erase='\033[K'

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

client=$(find / -name "ingenuity-cli" | head -n 1)

clear

while [ 1 ]; do
  getinfo=$($client getinfo)
  gettxoutsetinfo=$($client gettxoutsetinfo)
  mnsync=$($client mnsync status)
  mnstatus=$($client masternode debug)
  count=$($client masternode list | grep -c addr)

  version=$(echo $getinfo | jq .version)
  protocol=$(echo $getinfo | jq .protocolversion)
  blocks=$(echo $getinfo | jq .blocks)
  connections=$(echo $getinfo | jq .connections)
  supply=$(echo $getinfo | jq .moneysupply)
  transactions=$(echo $gettxoutsetinfo | jq .transactions)

  blockchainsynced=$(echo $mnsync | jq .IsBlockchainSynced)
  asset=$(echo $mnsync | jq .RequestedMasternodeAssets)
  attempt=$(echo $mnsync | jq .RequestedMasternodeAttempt)

  logresult=$(tail -n 10 ~/.ingenuity/debug.log | pr -T -o 2 | cut -c 1-68 | awk '{printf("%.68s \n", $0"                                                    ")}')

  #clear
  tput cup 0 0
  echo
  echo -e "${erase}${blue} Protocol    : ${green}$protocol${clear}"
  echo -e "${erase}${blue} Version     : ${green}$version${clear}"
  echo -e "${erase}${blue} Connections : ${green}$connections${clear}"
  echo -e "${erase}${blue} Supply      : ${green}$supply${clear}"
  echo -e "${erase}${blue} Transactions: ${green}$transactions${clear}"
  echo -e "${erase}${blue} MN Count    : ${green}$count${clear}"
  echo
  echo -e "${erase}${blue} blocks      : ${yellow}$blocks${clear}"
  echo
  echo -e "${erase}${blue} Sync Status : ${green}${status[$asset]} ${blue}attempt ${yellow}$attempt ${blue}of ${yellow}8${clear}"
  echo -e "${erase}${blue} MN Status   : ${green}$mnstatus${clear}"
  echo
  echo -e "${erase}${yellow} ======================================================================="
  echo -e "${blue}$logresult${clear}"
  echo -e "${erase}${yellow} ======================================================================="
  echo -e "${erase}${green} Press CTRL-C to exit. Updated every 2 seconds. ${blue} 2018 @bitmonopoly${clear}"

  sleep 4
done
