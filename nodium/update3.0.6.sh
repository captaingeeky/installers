#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

PROJECT="Nodium"
PROJECT_FOLDER="/root/nodium"
UPDATE_FOLDER="temp_update"

DAEMON_BINARY="nodiumd"
DAEMON_OLD="Nodiumd"

DAEMON_BINARY_PATH="/root/nodium/src/nodiumd"
DAEMON_OLD_PATH="/root/nodium/src/Nodiumd"
OLD_BINARY="/root/nodium/src/Nodiumd"
CLI_BINARY="/root/nodium/src/nodium-cli"
CLI_OLD="/root/nodium/src/Nodium-cli"
CONF_FILE="/root/.Nodium/nodium.conf"
CONF_OLD="/root/.Nodium/Nodium.conf"

DAEMON_START="/root/nodium/src/nodiumd -daemon"

CRONTAB_LINE="@reboot $DAEMON_START"
GITHUB_REPO="https://github.com/nodiumproject/zNodium"

function checks() 
{
  if [[ $(lsb_release -d) != *16.04* ]]; then
    echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
    exit 1
  fi

  if [[ $EUID -ne 0 ]]; then
     echo -e "${RED}$0 must be run as root.${NC}"
     exit 1
  fi

  if [ "$(pidof $DAEMON_OLD)" -lt 1 ]; then
    echo -e "${RED}The $PROJECT_NAME daemon is not running on this machine. $PROJECT_NAME updater is ONLY for existing masternodes.${NC}"
    NEW_NODE="n"
    exit 1
  else
    NEW_NODE="new"
  fi
}

function show_header()
{
  clear
  echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
  echo -e "${YELLOW}$PROJECT Masternode UPDATER from 2.3 to v3.0.6 - chris 2018 ${NC}"
  echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
  echo
  echo -e "${BLUE}This script will automate the UPDATE of your ${YELLOW}$PROJECT ${BLUE}masternode along with the server configuration."
  echo -e "It will:"
  echo
  echo -e " ${YELLOW}■${NC} Prepare your system with any missing dependencies"
  echo -e " ${YELLOW}■${NC} Rebuild the new project from GitHUB in a temp folder"
  echo -e " ${YELLOW}■${NC} Copy the new binaries to the project folder and remove the temp folder"
  echo -e " ${YELLOW}■${NC} Modify syntax and naming conventions."
  echo -e " ${YELLOW}■${NC} Check if you have Brute-Force protection. If not install fail2ban."
  echo -e " ${YELLOW}■${NC} Update the system firewall to only allow SSH, the masternode ports and outgoing connections"
  echo -e " ${YELLOW}■${NC} Add or modify the schedule entry for the service to restart automatically on power cycles/reboots."
  echo
  read -e -p "$(echo -e ${YELLOW}Continue with installation? [Y/N] ${NC})" CHOICE

if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
  exit 1;
fi
}

function clone_github()
{
  echo
  echo -e "${BLUE}Cloning GitHUB${NC}"
  cd /root/
  git clone $GITHUB_REPO $UPDATE_FOLDER
  if [ $? -eq 0 ]; then
    echo -e "${BLUE}GitHUB Cloned - Proceeding to next step. ${NC}"
    echo
  else
    RETVAL=$?
    echo -e "${RED}Git Clone has failed. Please see error above : $RETVAL ${NC}"
    exit 1
  fi
}

function install_prerequisites()
{
  echo
  echo -e "${BLUE}Installing Pre-requisites${NC}"
  sudo apt-get install -y pkg-config
  sudo apt-get install -y git build-essential libevent-dev libtool libboost-all-dev libgmp-dev libssl-dev libcurl4-openssl-dev git
  sudo add-apt-repository ppa:bitcoin/bitcoin -y
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
  sudo apt-get install -y autoconf automake
}

function build_project()
{
  cd $PROJECT_FOLDER
  echo
  echo -e "${BLUE}Compiling the wallet (this can take 20 minutes)${NC}"
  sudo chmod +x share/genbuild.sh
  sudo chmod +x autogen.sh
  sudo chmod 755 src/leveldb/build_detect_platform
  sudo ./autogen.sh
  sudo ./configure
  sudo make
  if [ -f $DAEMON_BINARY_PATH ]; then
    echo -e "${BLUE}$PROJECT_NAME Daemon and CLI installed, proceeding to next step...${NC}"
    echo
  else
    RETVAL=$?
    echo -e "${RED}installation has failed. Please see error above : $RETVAL ${NC}"
    exit 1
  fi
}

function create_conf_file()
{
  echo
  echo -e "${BLUE}Starting daemon to create conf file${NC}"
  echo -e "${YELLOW}Ignore any errors you see below. This will take 30 seconds.${NC}"
  $DAEMON_START
  sleep 30
  $CLI_BINARY getmininginfo
  $CLI_BINARY stop
  echo
  echo -e "${BLUE}Stopping the daemon and writing config${NC}"

cat <<EOF > $CONF_FILE
rpcuser=$RPC_USER
rpcpassword=$PASSWORD
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
masternode=1
externalip=$WANIP
bind=$WANIP
masternodeaddr=$WANIP:$MN_PORT
masternodeprivkey=$GENKEY
EOF
}

function configure_firewall()
{
  echo
  echo -e "${BLUE}setting up firewall...${NC}"
  sudo apt-get install -y ufw
  sudo apt-get update -y
  
  #configure ufw firewall
  sudo ufw default allow outgoing
  sudo ufw default deny incoming
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw allow $MN_PORT/tcp
  sudo ufw logging on
}

function add_cron()
{
(crontab -l; echo "$CRONTAB_LINE") | crontab -
}

function start_wallet()
{
  echo
  echo -e "${BLUE}Re-Starting the wallet...${NC}"
  if [ -f $DAEMON_BINARY_PATH ]; then
    $DAEMON_START
    echo
    echo -e "${BLUE}Now wait for a full synchro (can take 10-15 minutes)${NC}"
    echo -e "${BLUE}Once Synchronized, go back to your Windows/Mac wallet,${NC}"
    echo -e "${BLUE}go to your Masternodes tab, click on your masternode and press on ${YELLOW}Start Alias${NC}"
    echo -e "${BLUE}Congratulations, you've set up tour masternode!${NC}"
  else
    RETVAL=$?
    echo -e "${RED}Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
    exit 1
  fi
}

function deploy()
{
  checks
  pre_install
  show_header
  get_masternode_key
  create_swap
  install_prerequisites
  clone_github
  build_project
  create_conf_file
  configure_firewall
  add_cron
  start_wallet
}

deploy