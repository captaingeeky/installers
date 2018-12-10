#!/bin/bash
systemctl stop Ingenuity.service
sleep 5
rm -rf backups/ banlist.dat blocks/ budget.dat chainstate/ database/ db.log debug.log fee_estimates.dat .lock mncache.dat mnpayments.dat peers.dat sporks/ zerocoin/
systemctl start Ingenuity.service
sleep 3
ingenuity-cli addnode 104.248.113.141 add
ingenuity-cli addnode 104.248.121.23 add
ingenuity-cli addnode 138.197.217.53 add
ingenuity-cli addnode 206.189.11.138 add
ingenuity-cli addnode 128.199.203.87 add
ingenuity-cli addnode 178.62.77.53 add
ingenuity-cli addnode 104.248.33.190 add
ingenuity-cli addnode 178.128.233.157 add
~/ingyinfo.sh
