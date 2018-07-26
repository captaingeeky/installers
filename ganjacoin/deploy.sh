
#!/bin/bash

VERSION="1.0.52"
PROJECT="GanjaCoin"
PROJECT_FOLDER="$HOME/ganja"
BINARY="ganjacoind"
  
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

function checks()
{
  if [[ ($(lsb_release -d) != *16.04*) ]] && [[ ($(lsb_release -d) != *17.04*) ]]; then
      echo -e "${RED}You are not running Ubuntu 16.04 or 17.04. Installation is cancelled.${NC}"
      exit 1
  fi

  if [[ $EUID -ne 0 ]]; then
     echo -e "${RED}$0 must be run as root.${NC}"
     exit 1
  fi

  if [ -f /root/.Ganjaproject2 ]; then
    IS_INSTALLED=true
    echo -e "${YELLOW}$PROJECT Previously installed! ${NC}"
      
    read -e -p "$(echo -e ${YELLOW}Delete the current version and continue? [Y/N] ${NC})" CHOICE
    if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
      echo
      echo -e "${RED} Installation aborted by user.${NC}"
      exit 1
    else
      echo
      echo -e "${BLUE}Deleting existing files...${NC}"
      rm -R /root/.Ganjaproject2 > /dev/null 2>&1
      rm -R /root/coins/GanjaCoin > /dev/null 2>&1
      rm -R /root/ganja > /dev/null 2>&1
      sleep 2
    fi
  fi
}

function check_existing()
{
  echo
  echo -e "${BLUE}Checking for existing nodes and available IPs...${NC}"
  echo
  #Get list and count of IPs excluding local networks
  IP_LIST=$(ifconfig | grep "inet addr:" | awk {'print $2'} | grep -vE '127.0.0|192.168|172.16|10.0.0' | tr -d 'inet addr:')
  IP_NUM=$(echo "$IP_LIST" | wc -l)

  #Get number of existing MRJA masternode directories
  DIR_COUNT=$(ls -la /root/ | grep "\.Ganjaproject" | grep -c '^')
  
  #Check if there are more IPs than existing nodes
  if [[ $DIR_COUNT -ge $IP_NUM ]]; then
    echo -e "${RED}Not enough available IP addresses to run another node! Please add other IPs to this VPS first.${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Found ${BLUE} $DIR_COUNT ${YELLOW} $PROJECT Masternodes and ${BLUE} $IP_NUM ${YELLOW} IP addresses.${NC}"

  NEXT_AVAIL_IP=$(curl -4 icanhazip.com)
  echo -e "${YELLOW}Using next available IP : ${BLUE}$NEXT_AVAIL_IP${NC}"

  read -e -p "$(echo -e ${YELLOW}Continue with installation? [Y/N] ${NC})" CHOICE
  if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
    exit 1;
  fi
  
}

function set_environment()
{
  DATADIR="$HOME/.Ganjaproject2$DIR_NUM"

  TMP_FOLDER=$(mktemp -d)
  RPC_USER="$PROJECT-Admin"
  MN_PORT=12419
  RPC_PORT=14420

  DAEMON="$PROJECT_FOLDER/$BINARY"
  CONF_FILE="$DATADIR/Ganjaproject.conf"
  DAEMON_START="$DAEMON -daemon"
  CRONTAB_LINE="@reboot $DAEMON_START"
}

function show_header()
{
clear
echo -e "${GREEN}                      ,(%%%%%%%%%%%%%(,                    "
echo -e "                 .#%%/.        /.     ./#%#,               "
echo -e "              /%%*             %,          /%%/            "
echo -e "           .#%,               *%,             /%#.         "
echo -e "         ,%#.                /%%.,              .#%,       "
echo -e "        ##.                 *%%%*.,               ,%#      "
echo -e "      *%*                  /#%%%,   .               (%*    "
echo -e "     /%.                   *%%%% .,,                 ,%/   "
echo -e "    /%                    .%%%%%....,                 ,%/  "
echo -e "   /%  /.                 #%%%%%..,*.                  ,%/ "
echo -e "  .%*   (##/*             (%%%%%.. ../                  /%."
echo -e "  (#     *%##%###,.       /%%%%%  .,.              ..    %("
echo -e "  %/      /%###%#%#%#     (%%%%%. , .       . . ..       #%"
echo -e " .%,        ,#%%%##%%%%%#. #%%%%..,.   *  . .,.          /%"
echo -e "  %*         .(%%%%%%%%%%%/(%%##(/*,. ..  ..  ,          (%"
echo -e "  %(           .(%%%%%%%%%#.  .**.  / . ,.. .            ##"
echo -e "  /%             .#%%%%%%#  (%%% . (.. ,   ..           ,%/"
echo -e "   %(              .(%%%%(  %%%#.....(..  ..            #% "
echo -e "   .%*          ./(%##%%%%. .%%%*,(. *...(, ,          /%. "
echo -e "    .%*   ,/(###(##%%%%%%%%%/.    .//,,*.. .   . .    (%.  "
echo -e "     .%(     *#####%%%%%%%%%%%%( .... *,  .. ..      #%.   "
echo -e "       ##.         ..   /%%%%%//  *. ,/  ...       ,%#     "
echo -e "        *%(           .%%%%%(  *    /..*,        .#%,      "
echo -e "          /%#        .%%%%/    .     ....,     .#%/        "
echo -e "               *%%(,                     ,#%%*             "
echo -e "                   /%%%(*,        .,/#%%%/                 "
echo -e "                        ,(%%%%%%%%%(,                      ${NC}"
sleep 4
echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
echo -e "${YELLOW}$PROJECT Masternode Installer v$VERSION - chris 2018"
echo -e "${RED}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${NC}"
echo
echo -e "${BLUE}This script will automate the installation of your ${YELLOW}$PROJECT ${BLUE}masternode along with the server configuration."
echo -e "${BLUE}It will take you through the entire process along with the setting up of your QT wallet (Windows/Mac Wallet)."
echo -e "${BLUE}Please read each question carefully before continuing to the next step."
echo -e "This script will:"
echo
echo -e " ${YELLOW}■${NC} Help you prepare your Hot Wallet"
echo -e " ${YELLOW}■${NC} Prepare your VPS system with the required dependencies"
echo -e " ${YELLOW}■${NC} Obtain the latest $PROJECT masternode files from the official $PROJECT repository"
echo -e " ${YELLOW}■${NC} Automatically generate the Masternode Genkey (and display at the end)"
echo -e " ${YELLOW}■${NC} Automatically generate the .conf file"
echo -e " ${YELLOW}■${NC} Add Brute-Force protection using fail2ban"
echo -e " ${YELLOW}■${NC} Update the system firewall to only allow SSH, the masternode ports and outgoing connections"
echo -e " ${YELLOW}■${NC} Add a schedule entry for the service to restart automatically on power cycles/reboots."
echo
echo -e " ${RED}WARNING!!! ${RED}If you are already running one or more $PROJECT Masternode(s) on this machine, make sure they are running before executing this script!!! ${NC}"
echo -e " ${RED}If you do not, the script will improperly detect running nodes and possibly overwrite existing $PROJECT configurations! ${NC}"
echo
}

function create_swap()
{
  echo
  echo -e "${BLUE}Creating Swap... (ignore errors, this might not be supported or previously installed.)${NC}"
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
    #pre-reqs for running the daemon file
    sudo apt update
    sudo apt install -y pwgen build-essential pkg-config libevent-dev libtool libboost-all-dev libgmp-dev libssl-dev libcurl4-openssl-dev
    sudo add-apt-repository -y ppa:bitcoin/bitcoin
    sudo apt update
    sudo apt install -y libdb4.8-dev libdb4.8++-dev
    #end pre-reqs section
}

function copy_binaries()
{
    #deleting previous install folders in case of failed install attempts. Also ensures latest binaries are used
    rm -rf $PROJECT_FOLDER > /dev/null 2>&1
    echo
    echo -e "${BLUE}Copying Binaries...${NC}"
    mkdir $PROJECT_FOLDER > /dev/null 2>&1
    cd $PROJECT_FOLDER > /dev/null 2>&1
  
    echo
    wget https://github.com/zaemliss/installers/raw/master/ganjacoin/ganjacoind > /dev/null 2>&1
    chmod +x $CLI_BINARY > /dev/null 2>&1

  if [ -f $DAEMON ]; then
      mkdir $DATADIR
      echo -e "${BLUE}Starting daemon ...(30 seconds)${NC}"
      $DAEMON_START
      sleep 30
    else
      echo -e "${RED}Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
      exit 1;
  fi
}

function prepare_QT()
{
  clear
  echo
  echo -e "${YELLOW}QT Wallet Preparation : (you need your Windows or Mac wallet open for this step!)${NC}"
  echo
  echo -e "${BLUE} Step 1. Create a new wallet receiving address. To do this, simply go to the ${GREEN}Receive ${BLUE}tab on the left and"
  echo -e " click on the ${GREEN}New Address${BLUE} button below. A popup window will ask for a label. Write something in to properly"
  echo -e " identify your masternode such as a name and it's number. For example, if this is your first, you could use: ${NC}"
  echo -e " ${GREEN}MN01 ${BLUE}as an alias. Write it in the label field and click ok.${NC}"
  echo
  read -e -p "$(echo -e ${YELLOW} Once this is done, please type in the label you chose here and press enter [case sensitive]: ${NC})" MN_ALIAS
  
}

function create_conf_file()
{
  echo
  PASSWORD=$(pwgen -s 64 1)
  GENKEY=$($CLI masternode genkey)
  echo
  echo -e "${BLUE}Creating conf file...${NC}"
  echo -e "${YELLOW}Ignore any errors you see below. (15 seconds)${NC}"
  sleep 15
  echo
  echo -e "${BLUE}Stopping the daemon and writing config (15 seconds)${NC}"
  $CLI stop > /dev/null 2>&1
  sleep 16
  
cat <<EOF > $CONF_FILE
rpcuser=$RPC_USER
rpcpassword=$PASSWORD
rpcallowip=localhost
$RPC_PORT
port=12419
externalip=$NEXT_AVAIL_IP
server=1
listen=1
daemon=1
logtimestamps=1
txindex=$TX_INDEX
maxconnections=500
mnconflock=0
masternode=1
masternodeaddr=$NEXT_AVAIL_IP:12419
masternodeprivkey=$GENKEY
stake=0
staking=0
addnode=8.9.5.253:12419
addnode=13.64.151.62:12419
addnode=162.243.168.95:12419
addnode=85.25.116.80:12419
addnode=104.238.183.8:12419
addnode=45.76.253.220:12419
addnode=104.207.144.192:12419
addnode=108.61.215.107:12419
addnode=84.200.101.85:12419
addnode=207.246.117.154:12419
addnode=78.159.150.22:12419
addnode=107.175.32.173:12419
addnode=66.42.64.200:12419
addnode=216.172.33.74:12419 
EOF
}

function secure_server()
{
  echo
  echo -e "${BLUE}setting up firewall...${NC}"
  sudo apt-get install -y ufw fail2ban > /dev/null 2>&1
  sudo apt-get update -y > /dev/null 2>&1
  
  #configure ufw firewall
  sudo ufw default allow outgoing > /dev/null 2>&1
  sudo ufw default deny incoming > /dev/null 2>&1
  sudo ufw allow ssh/tcp > /dev/null 2>&1
  sudo ufw limit ssh/tcp > /dev/null 2>&1
  sudo ufw allow $MN_PORT/tcp > /dev/null 2>&1
  sudo ufw logging on > /dev/null 2>&1
  echo "y" | sudo ufw enable
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
    echo
    echo -e "${BLUE}Now wait for a full synchro (can take 10-15 minutes)${NC}"
    echo -e "${BLUE}Once Synchronized, go back to your Windows/Mac wallet,${NC}"
    echo -e "${BLUE}go to your Masternodes tab, click on your masternode and press on ${YELLOW}Start Alias${NC}"
    echo
    read -n 1 -s -r -p "Press any key to continue to syncronisation steps"
    echo
    $DAEMON_START > /dev/null 2>&1
    echo -e "${BLUE}Starting Synchronization...${NC}"
    sleep 10
    
    BLOCKS=$($DAEMON getblockcount)
    CURBLOCK=$($DAEMON  getinfo | grep blocks | awk {'print $3'} | tr -d ',')
        
    while [ $BLOCKS -ne $CURBLOCK ]; do
      BLOCKS=$($DAEMON getblockcount)
      CURBLOCK=$($DAEMON  getinfo | grep blocks | awk {'print $3'} | tr -d ',')
      echo -e "${BLUE}syncing${YELLOW} $CURBLOCK ${BLUE}out of${YELLOW} $BLOCKS ...${NC}"
      sleep 10
    done
    
    MNSTATUS=$($DAEMON masternode status | grep status | awk {'print $3'} | tr -d ',')
    
    echo -e "${YELLOW}Please right click on your new node in your QT wallet and Start Alias.${NC}"
    echo -e "${YELLOW}The command prompt will return once your node is started. If the Status goes to Expired in your QT wallet, please start alias again.${NC}"
    read -n 1 -s -r -p "Press any key to continue"
    watch -g $CLI masternode status
    echo -e "${BLUE}Congratulations, you've set up your masternode!${NC}"
    echo
    echo -e "${RED}Make ${YELLOW}SURE ${RED}you copy this Genkey for your QT wallet (Windows/Mac wallet) ${BLUE}$GENKEY${NC}"
    echo -e "${BLUE}If you are using Putty, just select the text. It will automatically go to your clipboard.${NC}"
    echo -e "${BLUE}If you are using SSH, use CTRL-INSERT / CTRL-V${NC}"
    echo -e "${YELLOW}Typing the key out incorrectly is 99% of all installation issues. ${NC}"
    echo
    echo -e "${BLUE}Type ${YELLOW}z <data directory> <command> ${BLUE} to interact with your server(s). ${NC}"
    echo -e "${BLUE}Ex: ${GREEN}z zixx2 masternode status ${NC}"
    
  else
    RETVAL=$?
    echo -e "${RED}Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
    exit 1
  fi
}

function cleanup()
{
  cd $HOME
  
  if [ "$IS_CURRENT" = true ] && [ "$IS_INSTALLED" = true ]; then
    echo -e "${BLUE} Finalizing..."
  else
    rm -R db-4.8*
  fi
}

function deploy()
{
  checks
  show_header
  check_existing
  set_environment
  create_swap
  install_prerequisites
  copy_binaries
  create_conf_file
  secure_server
  add_cron
  start_wallet
  cleanup
}

deploy
