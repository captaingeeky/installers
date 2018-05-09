#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

PROJECT="XXXX"
TMP_FOLDER=$(mktemp -d)
CONF_FILE="XXXX.conf"
RPC_USER="XXXX-Admin"
MN_PORT=NNNN
RPC_PORT=19643

DAEMON="XXXXd"
CLI="XXXX-cli"
DAEMON_BINARY_FILE="/usr/local/bin/$DAEMON_BINARY"
DAEMON_START="$DAEMON_BINARY_FILE -daemon"
CLI_BINARY_FILE="/usr/local/bin/$CLI_BINARY"
CRONTAB_LINE="@reboot $DAEMON_START"
GITHUB_REPO="https://github.com/PATH/TO/XXXX.git"

function pre_install()
{
  echo -e "${BLUE}Installing dns utils...${NC}"
  sudo apt-get install dnsutils
  echo -e "${BLUE}Installing pwgen...${NC}"
  sudo apt-get install pwgen
  PASSWORD=$(pwgen -s 64 1)
  WANIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
}

function show_header()
{
  clear
  echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
  echo -e "${yellow}$PROJECT Masternode Installer v1.0 - chris 2018 | On server VPS IP: $WANIP...${NC}"
  echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
  echo
  echo -e "This script will automate the installation of your $PROJECT masternode along with the server configuration."
  echo -e "It will:"
  echo
  echo -e " ${yellow}■${NC} Create a swap file"
  echo -e " ${yellow}■${NC} Prepare your system with the required dependencies"
  echo -e " ${yellow}■${NC} Obtain the latest $PROJECT masternode files from the official $PROJECT repository"
  echo -e " ${yellow}■${NC} Create a user and password to run the $PROJECT masternode service and install it"
  echo -e " ${yellow}■${NC} Add DDoS protection using fail2ban"
  echo -e " ${yellow}■${NC} Update the system firewall to only allow; SSH, the masternode ports and outgoing connections"
  echo
  echo -e "The script will output ${YELLOW}questions${NC}, ${BLUE}information${NC} and ${RED}errors${NC}"
  echo
  read -e -p "$(echo -e $YELLOW Do you want to continue? [Y/N] $NC)" CHOICE

if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
  exit 1;
fi
}

function get_masternode_key()
{
  echo -e "${YELLOW}Enter your masternode key for your conf file ${BLUE}(you created this in windows)${YELLOW}, then press ${GREEN}[ENTER]${NC}: " 
  echo -e "${RED}Make ${YELLOW}SURE ${RED}you copy from your ${BLUE}masternode genkey ${RED}in your windows/Mac wallet and then paste the key below."
  echo -e "Typing the key out incorrectly is 99% of the installation issues. ${NC}"
  read -p 'Masternode Private Key: ' GENKEY
  echo
}

function create_swap()
{
  fallocate -l 3G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo
  echo -e "/swapfile none swap sw 0 0 \n" >> /etc/fstab
}

function clone_github()
{
  echo
  echo -e "${BLUE}Cloning GitHUB${NC}"
  cd /root/
  git clone https://github.com/nodiumproject/Nodium nodium
}

function install_prerequisites()
{
  cd nodium
  echo
  echo -e "${BLUE}Installing Pre-requisites${NC}"
  sudo apt-get install -y pkg-config
  sudo apt-get -y install build-essential autoconf automake libtool libboost-all-dev libgmp-dev libssl-dev libcurl4-openssl-dev git
  sudo add-apt-repository ppa:bitcoin/bitcoin -y
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get install libdb4.8-dev libdb4.8++-dev
}

function build_project()
{
  echo
  echo -e "${BLUE}Compiling the wallet (this can take 20 minutes)${NC}"
  sudo chmod +x share/genbuild.sh
  sudo chmod +x autogen.sh
  sudo chmod 755 src/leveldb/build_detect_platform
  sudo ./autogen.sh
  sudo ./configure
  sudo make
}

function create_conf_file()
{
  echo
  echo -e "${BLUE}Starting daemon to create conf file${NC}"
  cd src
  ./$DAEMON -daemon
  sleep 30
  ./$CLI getmininginfo
  ./$CLI stop
  echo
  echo -e "${BLUE}Stopping the daemon and writing config${NC}"

  cat <<EOF > ~/.Nodium/Nodium.conf
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
  echo -e "${BLUE}setting up firewall to keep bad guys out...${NC}"
  sudo apt-get install -y ufw
  sudo apt-get update -y
  
  #configure ufw firewall to keep bad guys out
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
  ./DAEMON -daemon
}

function deploy()
{
  pre_install
  show_header
  get_masternode_key
  create_swap
  clone_github
  install_prerequisites
  build_project
  create_conf_file
  configure_firewall
  add_cron
  start_wallet
}

deploy
