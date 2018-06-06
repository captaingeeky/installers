#!/bin/bash
RED='\033[1;31m'
BLUE='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'

if [ -z $1 ]; then
        echo
        echo -e "${RED}ERROR: you must provide parameters.${NC}"
        echo -e "Syntax: ${BLUE}z datadir command [options]${NC}"
        echo -e "ex.: ${GREEN}z zixx2 masternode status${NC}"
        echo
        exit 1;
fi

/root/zixx/zixx-cli -datadir=/root/.$1 -conf=/root/.$1/zixx.conf $2 $3 $4
