#!/bin/bash
systemctl stop Ingenuity.service
sleep 5
rm -rf backups/ banlist.dat blocks/ budget.dat chainstate/ database/ db.log debug.log fee_estimates.dat .lock mncache.dat mnpayments.dat peers.dat sporks/ zerocoin/
systemctl start Ingenuity.service
