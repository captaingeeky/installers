#!/bin/bash

#Color Declarations
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

function set_environment()
{
  #Variable Declaration
  VERSION="1.0.54"
  PROJECT="GanjaCoin"
  PROJECT_FOLDER="$HOME/ganja"
  BINARY="ganjacoind"
  NEXT_AVAIL_IP=$(curl -s4 icanhazip.com)
  DATADIR="$HOME/.Ganjaproject2"

  TMP_FOLDER=$(mktemp -d)
  RPC_USER="$PROJECT-Admin"
  MN_PORT=12419
  RPC_PORT=14420

  DAEMON="$PROJECT_FOLDER/$BINARY"
  CONF_FILE="$DATADIR/Ganjaproject.conf"
  DAEMON_START="$DAEMON -daemon"
  CRONTAB_LINE="@reboot $DAEMON_START"
}

function checks()
{
  # Checks if running at least Ubuntu 16.04, as root and no other Ganjacoin Masternode exists
  
  if [[ ($(lsb_release -d) != *16.04*) ]] && [[ ($(lsb_release -d) != *17.04*) ]]; then
      echo -e "${RED} You are not running Ubuntu 16.04 or 17.04. Installation is cancelled.${NC}"
      exit 1
  fi

  if [[ $EUID -ne 0 ]]; then
     echo -e "${RED}$ Must be run as root!${NC}"
     exit 1
  fi

  if [ -f /root/.Ganjaproject2 ]; then
    IS_INSTALLED=true
    echo -e "${YELLOW} $PROJECT Previously installed! ${NC}"

    read -e -p "$(echo -e ${YELLOW}Delete the current version and continue? [Y/N] ${NC})" CHOICE
    if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
      echo
      echo -e "${RED} Installation aborted by user.${NC}"
      exit 1
    else
      echo
      echo -e "${BLUE} Deleting existing files...${NC}"
      rm -R /root/.Ganjaproject2 > /dev/null 2>&1
      rm -R /root/coins/GanjaCoin > /dev/null 2>&1
      rm -R /root/ganja > /dev/null 2>&1
      sleep 2
    fi
  fi
}

function check_existing()
{
  #Secondary check. Looks for installed projects versus available IPs
  echo
  echo -e "${BLUE} Checking for existing nodes and available IPs...${NC}"
  echo
  #Get list and count of IPs excluding local networks
  IP_LIST=$(ifconfig | grep "inet addr:" | awk {'print $2'} | grep -vE '127.0.0|192.168|172.16|10.0.0' | tr -d 'inet addr:')
  IP_NUM=$(echo "$IP_LIST" | wc -l)

  #Get number of existing MRJA masternode directories
  DIR_COUNT=$(ls -la /root/ | grep "\.Ganjaproject" | grep -c '^')

  #Check if there are more IPs than existing nodes
  if [[ $DIR_COUNT -ge $IP_NUM ]]; then
    echo -e "${RED} Not enough available IP addresses to run another node! Please add other IPs to this VPS first.${NC}"
    exit 1
  fi
  echo -e "${YELLOW} Found ${BLUE} $DIR_COUNT ${YELLOW} $PROJECT Masternodes and ${BLUE} $IP_NUM ${YELLOW} IP addresses.${NC}"
  echo -e "${YELLOW} Using next available IP : ${BLUE}$NEXT_AVAIL_IP${NC}"

  read -e -p "$(echo -e ${YELLOW} Continue with installation? [Y/N] ${NC})" CHOICE
  if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
    exit 1;
  fi

}

function show_header()
{
clear
echo -e "${YELLOW}                      ,(%%%%%%%%%%%%%(,                    "
echo -e "${YELLOW}                 .#%%/.${GREEN}        /.     ${YELLOW}./#%#,               "
echo -e "${YELLOW}              /%%*${GREEN}             %,          ${YELLOW}/%%/            "
echo -e "${YELLOW}           .#%,${GREEN}               *%,             ${YELLOW}/%#.         "
echo -e "${YELLOW}         ,%#.${GREEN}                /%%.,              ${YELLOW}.#%,       "
echo -e "${YELLOW}        ##.${GREEN}                 *%%%*.,               ${YELLOW},%#      "
echo -e "${YELLOW}      *%*${GREEN}                  /#%%%,   .               ${YELLOW}(%*    "
echo -e "${YELLOW}     /%.${GREEN}                   *%%%% .,,                 ${YELLOW},%/   "
echo -e "${YELLOW}    /%${GREEN}                    .%%%%%....,                 ${YELLOW},%/  "
echo -e "${YELLOW}   /%${GREEN}  /.                 #%%%%%..,*.                  ${YELLOW},%/ "
echo -e "${YELLOW}  .%*${GREEN}   (##/*             (%%%%%.. ../                  ${YELLOW}/%."
echo -e "${YELLOW}  (#${GREEN}     *%##%###,.       /%%%%%  .,.              ..    ${YELLOW}%("
echo -e "${YELLOW}  %/${GREEN}      /%###%#%#%#     (%%%%%. , .       . . ..       ${YELLOW}#%"
echo -e "${YELLOW} .%,${GREEN}        ,#%%%##%%%%%#. #%%%%..,.   *  . .,.          ${YELLOW}/%"
echo -e "${YELLOW}  %*${GREEN}         .(%%%%%%%%%%%/(%%##(/*,. ..  ..  ,          ${YELLOW}(%"
echo -e "${YELLOW}  %(${GREEN}           .(%%%%%%%%%#.  .**.  / . ,.. .            ${YELLOW}##"
echo -e "${YELLOW}  /% ${GREEN}            .#%%%%%%#  (%%% . (.. ,   ..           ${YELLOW},%/"
echo -e "${YELLOW}   %( ${GREEN}             .(%%%%(  %%%#.....(..  ..            ${YELLOW}#% "
echo -e "${YELLOW}   .%* ${GREEN}         ./(%##%%%%. .%%%*,(. *...(, ,          ${YELLOW}/%. "
echo -e "${YELLOW}    .%* ${GREEN}  ,/(###(##%%%%%%%%%/.    .//,,*.. .   . .    ${YELLOW}(%.  "
echo -e "${YELLOW}     .%( ${GREEN}    *#####%%%%%%%%%%%%( .... *,  .. ..      ${YELLOW}#%.   "
echo -e "${YELLOW}       ##. ${GREEN}        ..   /%%%%%//  *. ,/  ...       ${YELLOW},%#     "
echo -e "${YELLOW}        *%(  ${GREEN}         .%%%%%(  *    /..*,        ${YELLOW}.#%,      "
echo -e "${YELLOW}          /%#  ${GREEN}      .%%%%/    .     ....,    ${YELLOW} .#%/        "
echo -e "${YELLOW}               *%%(,                     ,#%%*             "
echo -e "${YELLOW}                   /%%%(*,        .,/#%%%/                 "
echo -e "${YELLOW}                        ,(%%%%%%%%%(,                      ${NC}"
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
echo
}

function create_swap()
{
  echo
  echo -e "${BLUE}Creating Swap... ${NC}"
  fallocate -l 3G /swapfile > /dev/null 2>&1
  chmod 600 /swapfile > /dev/null 2>&1
  mkswap /swapfile > /dev/null 2>&1
  swapon /swapfile > /dev/null 2>&1
  echo
  echo -e "/swapfile none swap sw 0 0 \n" >> /etc/fstab > /dev/null 2>&1
}

function install_prerequisites()
{
    echo
    echo -e "${BLUE}Installing Pre-requisites${NC}"
    #pre-reqs for running the daemon file
    sudo apt update > /dev/null 2>&1
    echo -ne "${YELLOW} [###               ]\r"
    sudo apt install -y pwgen libwww-perl build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils libdb++-dev libminiupnpc-dev libboost-all-dev libqrencode-dev unzip > /dev/null 2>&1
    echo -ne " [########          ]\r"
    sudo add-apt-repository -y ppa:bitcoin/bitcoin > /dev/null 2>&1
    echo -ne " [##############    ] \r"
    sudo apt update > /dev/null 2>&1
    sudo apt install -y libdb4.8-dev libdb4.8++-dev > /dev/null 2>&1
    echo -e " [##################]${NC}"
    #end pre-reqs section
    echo
    echo -e "${GREEN}Done.${NC}"
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
    chmod +x $DAEMON > /dev/null 2>&1
    echo -e "${GREEN}Done${NC}"
    echo
  if [ -f $DAEMON ]; then
      mkdir $DATADIR
cat <<EOF > $CONF_FILE
listen=1
server=0
maxconnections=500
rpcuser=yourusername
rpcpassword=9mRoJDqk1xa8XvOdL9NZhEdhTWzpnhhuT7
port=12419
rpcport=12420
rpcconnect=127.0.0.1
rpcallowip=127.0.0.1
addnode=138.197.44.71
EOF
      echo -e "${BLUE}Starting daemon ...(5 seconds)${NC}"
      $DAEMON &
      sleep 5

#      sed -i "s/server=1/server=0/" .Ganjaproject2/Ganjaproject.conf
    else
      echo -e "${RED}Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
      exit 1;
  fi
}

function prepare_QT()
{
  echo -e "This is a text guide complementing the instructions with pictures on the GitHUB!"
  echo 'https://github.com/zaemliss/installers/tree/master/ganjacoin'
  echo
  echo -e "${YELLOW} QT Wallet Preparation : (you need your Windows or Mac wallet open for this step!)${NC}"
  echo
  echo -e "${BLUE} Step 1. Create a new wallet receiving address. To do this, simply go to the" 
  echo -e " ${GREEN}Receive ${BLUE}tab on the left and click on the ${GREEN}New Address${BLUE} button below."
  echo -e " A popup window will ask for a label. Write something in to properly identify "
  echo -e " your masternode such as a name and it's number. For example, if this is your"
  echo -e " first, you could use ${GREEN}MN01 ${BLUE}as an alias. Write it in the label field and click ok."
  echo -e " Right-click on that new address and select COPY${NC}"
  echo
  echo -e " ${YELLOW}Once this is done, please type in the label you chose here and press enter${NC})"
  read -e -p " Masternode Alias [case sensitive] > : " MN_ALIAS
  echo
  echo
  echo -e "${BLUE} Step 2. Send ${YELLOW}EXACTLY 30,000 ${BLUE}coins to the new address you created."
  echo -e " To do this, simply click on the ${GREEN}Send${BLUE} tab. In the Pay To field, enter "
  echo -e " the new masternode address by pasting the one you copied in the previous step,"
  echo -e " then enter the quantity ${GREEN}30,000${BLUE} and press ${GREEN}SEND${NC}. ${BLUE}Enter your "
  echo -e " wallet password when prompted to confirm the transaction.${NC}"
  echo

  echo -e "${BLUE} Step 3. Now we need the ${YELLOW}Transaction ID and Output${BLUE} of the transaction"
  echo -e " you just did. For this, you simply click on ${GREEN}Help${BLUE} at the top of your wallet and " 
  echo -e " click ${GREEN}Debug Window ${BLUE}. On the popup window, click on ${GREEN}Console${BLUE}. "
  echo -e " In the little bar below, type ${GREEN}masternode outputs${BLUE} and press ENTER."
  echo -e " You should see something like:${NC}"
  echo "{"
  echo "  \"01dc01458060d7a5c937245b5eb72c06ab7c886caf36622338acd15906d45a\" : \"1\""
  echo "}"
  echo
  echo -e "${BLUE} The first part is the ${YELLOW}Transaction ID${BLUE} whereas the second part is the"
  echo -e " ${YELLOW}Transaction Output.${BLUE} If you can't see anything between the brackets it's " 
  echo -e " because your transaction is still pending. If it doesn't work right away, "
  echo -e " try again in a few minutes."
  echo -e " Once you have a result with the output command, please enter them here"
  echo -e " [WITHOUT QUOTES:]"
  echo -e "${YELLOW} Transaction ID: ${NC}"
  read -e -p "TXID: " TX_ID
  read -e -p "$(echo -e ${YELLOW} TXOutput [0 or 1]: ${NC})" TX_OUTPUT
  if [ TX_OUTPUT == 0 ]; then
     echo -e "${RED}ERROR! There must be a TX Output and a TX hash to continue."
     echo -e "Installation Aborted. ${NC}"
     exit 1
  fi

}

function create_conf_file()
{
  echo
  PASSWORD=$(pwgen -s 64 1)
  GENKEY=$($DAEMON masternode genkey) > /dev/null 2>&1
  echo
  echo -e "${BLUE}Creating conf file...${NC}"
  sleep 15
  echo
  echo -e "${BLUE}Stopping the daemon and writing config (15 seconds)${NC}"
  $DAEMON stop > /dev/null 2>&1
  sleep 10

cat <<EOF > $CONF_FILE
rpcuser=$RPC_USER
rpcpassword=$PASSWORD
rpcallowip=localhost
rpcport=$RPC_PORT
port=12419
externalip=$NEXT_AVAIL_IP
server=1
listen=1
daemon=1
logtimestamps=1
txindex=$TX_OUTPUT
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
  echo "y" | sudo ufw enable > /dev/null 2>&1
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
    echo -e "${YELLOW} Final Wallet Configuration:"
    echo -e "${BLUE} Please go to your QT Wallet (Windows or Mac wallet) and close it.${NC}"
    echo -e "${BLUE} Next, go to your data folder and double-click on ${GREEN}Ganjaproject2${BLUE} (see methods below)${NC}"
    echo
    echo -e " In Windows: Click the start button and type %APPDATA% and press ENTER, then double-click on the Ganjaproject2 folder"
    echo -e " In MacOS: with your file explorer, navigate to /Users/USERNAME/Library/Application Support/Ganjacoin2"
    echo
    echo -e "${BLUE} Once in that folder, you should see a masternode.conf file if you have other masternodes. If not you may have"
    echo -e " to create it.${NC}"
    echo -e "${BLUE} Once in that file, copy and paste the following information on a new line:${NC}"
    echo
    echo
    echo -e "$MN_ALIAS $GENKEY $TX_ID $TX_OUTPUT"
    echo
    echo
    echo -e "${BLUE} Next, save the file and close it. Now restart your QT (Windows or Mac) wallet${YELLOW}"
    read -n 1 -s -r -p " Press any key once this is all done to proceed to the next step."
    echo -e "${NC}"
    echo

    $DAEMON_START > /dev/null 2>&1
    echo -e "${BLUE} Starting Blockchain Synchronization...${NC}"
    sleep 10

    BLOCKS=$(curl -s http://explorer.ganjacoinpro.com/api/getblockcount)
    CURBLOCK=$($DAEMON  getinfo | grep blocks | awk {'print $3'} | tr -d ',')

    while [ $CURBLOCK -lt ${BLOCKS-200} ]; do
      CURBLOCK=$($DAEMON  getinfo | grep blocks | awk {'print $3'} | tr -d ',')
      echo -ne "${BLUE} syncing${YELLOW} $CURBLOCK ${BLUE}out of${YELLOW} $BLOCKS ${BLUE}...${NC}      \r"
      sleep 2
    done
    echo
    echo -e "${GREEN} Blockchain synced!${NC}"
    echo -e "${BLUE} Starting Masternode Synchronization...${NC}"
    echo -e "${GREEN} When it says ${YELLOW}MASTERNODE Waiting for remote activation!${NC}"
    echo -e "${GREEN} Go to your Masternode Tab in your QT Wallet, Click on your new Masternode and click on Start."
    echo
    echo
    
    MNSTAT[0]="MASTERNODE_NOT_PROCESSED"
    MNSTAT[1]="MASTERNODE_IS_CAPABLE"
    MNSTAT[2]="MASTERNODE Waiting for remote activation!"
    MNSTAT[3]="MASTERNODE_STOPPED"
    MNSTAT[4]="MASTERNODE_INPUT_TOO_NEW"
    MNSTAT[6]="MASTERNODE_PORT_NOT_OPEN"
    MNSTAT[7]="MASTERNODE_PORT_OPEN"
    MNSTAT[8]="MASTERNODE_SYNC_IN_PROCESS"
    MNSTAT[9]="MASTERNODE_REMOTELY_ENABLED"
    MNSTATUS=0

    while [ $MNSTATUS -ne 9 ]; do
      MNSTATUS=$($DAEMON masternode status | grep status | awk {'print $3'} | tr -d ',')
      echo -ne "${YELLOW} >Masternode Status : ${BLUE}${MNSTAT[MNSTATUS]}${NC} \r"
      sleep 5
    done

    echo -e "${BLUE} Congratulations, you've set up your masternode!${NC}"

  else
    RETVAL=$?
    echo -e "${RED} Binary not found! Please scroll up to see errors above : $RETVAL ${NC}"
    exit 1
  fi
}

function cleanup()
{
  cd $HOME

  if [ "$IS_CURRENT" = true ] && [ "$IS_INSTALLED" = true ]; then
    echo -e "${BLUE} End of Script."
  fi
}

function deploy()
{
  set_environment
  checks
  show_header
  prepare_QT
  check_existing
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

