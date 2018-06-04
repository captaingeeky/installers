
#!/bin/bash

VERSION="1.1.29"
PROJECT="Zixx"
PROJECT_FOLDER="$HOME/zixx"
DAEMON_BINARY="zixxd"
CLI_BINARY="zixx-cli"
  
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

function checks() 
{
  if [[ ($(lsb_release -d) != *16.04*) ]]; then
    if [[ ($(lsb_release -d) != *17.04*) ]]; then
      echo -e "${RED}You are not running Ubuntu 16.04 or 17.04. Installation is cancelled.${NC}"
      exit 1
    fi
  fi

  if [[ $EUID -ne 0 ]]; then
     echo -e "${RED}$0 must be run as root.${NC}"
     exit 1
  fi
}

function check_existing()
{
  echo
  echo -e "${BLUE}Checking for existing nodes and available IPs...${NC}"
  echo
  #Get list and count of IPs
  IP_LIST=$(ifconfig | grep "inet addr:" | awk {'print $2'} | grep -v "127.0.0.1" | tr -d 'inet addr:')
  IP_NUM=$(echo "$IP_LIST" | wc -l)

  #Get number of existing Zixx masternode directories
  DIR_COUNT=$(ls -la /root/ | grep "\.zixx" | grep -c '^')
  
  #Check if there are more IPs than existing nodes
  if [[ $DIR_COUNT -ge $IP_NUM ]]; then
    echo -e "${RED}Not enough available IP addresses to run another node! Please add other IPs to this VPS first.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Found ${BLUE} $DIR_COUNT ${YELLOW} $PROJECT Masternodes and ${BLUE} $IP_NUM ${YELLOW} IP addresses.${NC}"

  #Now confirm available IPs by removing those that are already bound to 44845
  IP_IN_USE=$(netstat -tulpn | grep :44845 | awk {'print $4'} | tr -d ':44845')
  IP_IN_USE_COUNT=$(echo "$IP_IN_USE" | wc -l)
  FREE_IPS=$(comm -23 <(echo "$IP_LIST" | sort) <(echo "$IP_IN_USE" | sort))
  NEXT_AVAIL_IP=$(echo $FREE_IPS | awk {'print $1'})
  echo -e "${YELLOW}Using next available IP : ${BLUE}$NEXT_AVAIL_IP${NC}"

  read -e -p "$(echo -e ${YELLOW}Continue with installation? [Y/N] ${NC})" CHOICE
  if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
    exit 1;
  fi
  
  if [[ $DIR_COUNT -gt 0 ]]; then
    DIR_NUM=$((DIR_COUNT+1))
  fi
}

function pre_install()
{
  echo -e "${BLUE}Installing pwgen...${NC}"
  sudo apt-get install -y pwgen
  PASSWORD=$(pwgen -s 64 1)
  WANIP=$(curl -s4 icanhazip.com)
}

function set_environment()
{
  DATADIR="$HOME/.zixx$DIR_NUM"

  TMP_FOLDER=$(mktemp -d)
  RPC_USER="$PROJECT-Admin"
  MN_PORT=44845
  RPC_PORT=$((14647+DIR_NUM))

  DAEMON="$PROJECT_FOLDER/$DAEMON_BINARY"
  CONF_FILE="$DATADIR/zixx.conf"
  CLI="$PROJECT_FOLDER/$CLI_BINARY -conf=$CONF_FILE -datadir=$DATADIR"
  DAEMON_START="$DAEMON -datadir=$DATADIR -conf=$CONF_FILE -daemon"
  CRONTAB_LINE="@reboot $DAEMON_START"
}

function show_header()
{
  clear
  echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
  echo -e "${YELLOW}$PROJECT Masternode Installer v$VERSION - chris 2018"
  echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
  echo
  echo -e "${BLUE}This script will automate the installation of your ${YELLOW}$PROJECT ${BLUE}masternode along with the server configuration."
  echo -e "It will:"
  echo
  echo -e " ${YELLOW}■${NC} Create a swap file"
  echo -e " ${YELLOW}■${NC} Prepare your system with the required dependencies"
  echo -e " ${YELLOW}■${NC} Obtain the latest $PROJECT masternode files from the official $PROJECT repository"
  echo -e " ${YELLOW}■${NC} Automatically generate the Masternode Genkey (and display at the end)"
  echo -e " ${YELLOW}■${NC} Automatically generate the .conf file"
  echo -e " ${YELLOW}■${NC} Add Brute-Force protection using fail2ban"
  echo -e " ${YELLOW}■${NC} Update the system firewall to only allow SSH, the masternode ports and outgoing connections"
  echo -e " ${YELLOW}■${NC} Add a schedule entry for the service to restart automatically on power cycles/reboots."
  echo
}

function create_swap()
{
  echo
  echo -e "${BLUE}Creating Swap... (ignore errors, this might not be supported)${NC}"
  fallocate -l 3G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo
  echo -e "/swapfile none swap sw 0 0 \n" >> /etc/fstab
}

function install_prerequisites()
{
  echo
  echo -e "${BLUE}Installing Pre-requisites${NC}"
  #addid this for libdbcxx
  sudo apt update
  sudo apt install -y build-essential libssl-dev libboost-all-dev libqrencode-dev libminiupnpc-dev
  sudo add-apt-repository -y ppa:bitcoin/bitcoin
  sudo apt update
  sudo apt install -y libdb4.8-dev libdb4.8++-dev
  #end libdbcxx section
  
  sudo apt install -y build-essential htop libevent-2.0-5 libzmq5 libboost-system1.58.0 libboost-filesystem1.58.0 libboost-program-options1.58.0 libboost-thread1.58.0 libboost-chrono1.58.0 libminiupnpc10 libevent-pthreads-2.0-5 unzip
  sudo wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
  sudo unzip db-4.8.30.zip
  cd db-4.8.30
  cd build_unix/
  sudo ../dist/configure --prefix=/usr/ --enable-cxx
  sudo make
  sudo make install
}

function copy_binaries()
{
  #deleting previous install folders in case of failed install attempts. Also ensures latest binaries are used
  rm -rf $PROJECT_FOLDER
  echo
  echo -e "${BLUE}Copying Binaries...${NC}"
  mkdir $PROJECT_FOLDER
  cd $PROJECT_FOLDER
  
  echo
  echo -e "${BLUE}Getting latest files...${NC}"
  LATEST_D=$(wget -qO- wget -qO- https://api.zixx.org/download/linux/zixxd)
  LATEST_CLI=$(wget -qO- wget -qO- https://api.zixx.org/download/linux/zixx-cli)
  wget $LATEST_D
  wget $LATEST_CLI
  
  chmod +x zixx{d,-cli}
  if [ -f $DAEMON ]; then
    mkdir $DATADIR
    echo -e "${BLUE}Starting daemon ...${NC}"
    $PROJECT_FOLDER/$DAEMON_BINARY -daemon
    sleep 2
  else
    echo -e "${RED}Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
    exit 1
  fi
}

function create_conf_file()
{
  sleep 2
  echo
  GENKEY=$($PROJECT_FOLDER/$CLI_BINARY masternode genkey)
  echo
  echo -e "${BLUE}Creating conf file conf file${NC}"
  echo -e "${YELLOW}Ignore any errors you see below.${NC}"
  sleep 2
  echo
  echo -e "${BLUE}Stopping the daemon and writing config${NC}"
  $PROJECT_FOLDER/$CLI_BINARY stop
  
cat <<EOF > $CONF_FILE
masternode=1
masternodeprivkey=$GENKEY
server=1
bind=$NEXT_AVAIL_IP
rpcport=$RPC_PORT
rpcuser=$RPC_USER
rpcpassword=$PASSWORD
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
  if [ -f $DAEMON ]; then
    $DAEMON_START
    echo
    echo -e "${BLUE}Now wait for a full synchro (can take 10-15 minutes)${NC}"
    echo -e "${BLUE}Once Synchronized, go back to your Windows/Mac wallet,${NC}"
    echo -e "${BLUE}go to your Masternodes tab, click on your masternode and press on ${YELLOW}Start Alias${NC}"
    echo -e "${BLUE}Congratulations, you've set up your masternode!${NC}"
    echo
    echo -e "${RED}Make ${YELLOW}SURE ${RED}you copy this Genkey for your QT wallet (Windows/Mac wallet) ${BLUE}$GENKEY${NC}"
    echo -e "${BLUE}If you are using Putty, just select the text. It will automatically go to your clipboard.${NC}"
    echo -e "${BLUE}If you are using SSH, use CTRL-INSERT / CTRL-V${NC}"
    echo -e "${YELLOW}Typing the key out incorrectly is 99% of all installation issues. ${NC}"
    echo
  else
    RETVAL=$?
    echo -e "${RED}Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
    exit 1
  fi
}

function cleanup()
{
#  echo -e "==================================="
#  echo -e "VERSION = $VERSION"
#  echo -e "PROJECT = $PROJECT"
#  echo -e "PROJECT_FOLDER = $PROJECT_FOLDER"
#  echo -e "DAEMON_BINARY = $DAEMON_BINARY"
#  echo -e "CLI_BINARY = $CLI_BINARY"
#  echo -e "DATADIR = $DATADIR"

#  echo -e "TMP_FOLDER = $TMP_FOLDER"
#  echo -e "RPC_USER = $RPC_USER"
#  echo -e "MN_PORT = $MN_PORT"
#  echo -e "RPC_PORT = $RPC_PORT"
#  echo -e "CRONTAB_LINE = $CRONTAB_LINE"

#  echo -e "DAEMON = $DAEMON"
#  echo -e "CLI = $CLI"
#  echo -e "CONF_FILE = $CONF_FILE"
#  echo -e "DAEMON_START = $DAEMON_START"
#  echo -e "==================================="
  
  cd $HOME
  rm inst*.sh
  rm install
  rm -R db-4.8*
}

function deploy()
{
  checks
  show_header
  check_existing
  pre_install
  set_environment
  create_swap
  install_prerequisites
  copy_binaries
  create_conf_file
  configure_firewall
  add_cron
  start_wallet
  cleanup
}

deploy
