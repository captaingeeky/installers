# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/install.sh -O install.sh && chmod +x install.sh && ./install.sh
#!/bin/bash
red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'

sudo apt-get update
sudo apt-get install build-essential software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libssl-dev libgmp-dev libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev libzmq3-dev libminiupnpc-dev -y
wget https://github.com/ALQO-Universe/ALQO/releases/download/v6.2.0.0-d4d958e4f/ALQO-v6.2.0.0-d4d958e4f-lin64.tgz > /dev/null 2>&1
tar zxvf ALQO-v6.2.0.0-d4d958e4f-lin64.tgz -C ~/ALQO  > /dev/null 2>&1
cd ~
mkdir ALQO
cd ALQO
mv ~/ALQO/ALQO-v6.2.0.0-d4d958e4f-lin64/alqod ~/ALQO
mv ~/ALQO/ALQO-v6.2.0.0-d4d958e4f-lin64/alqo-cli ~/ALQO
./alqod -daemon
echo -e "${BLUE}Please enter the masternode private key generated in the debug console via ${YELLOW}createmasternodekey ${NC}[0/1]"
read -e -p " : " MN_KEY
echo -e "${BLUE}Please enter a RPC Username  ${YELLOW}Long and random${NC}[0/1]"
read -e -p " : " RPC_USER
echo -e "${BLUE}Please enter RPC Password ${YELLOW}Longer and Randomer${NC}[0/1]"
read -e -p " : " PASSWORD
echo -e "${BLUE}Please enter the masternode IP Address${NC}[0/1]"
read -e -p " : " IPADDRESS
./alqo-cli stop
cat <<EOF > ~/.alqocrypto/alqo.conf
rpcuser=$RPC_USER
rpcpassword=$PASSWORD
rpcallowip=127.0.0.1
server=1
daemon=1
logintimestamps=1
maxconnections=256
externalip=$IPADDRESS:20480
masternode=1
masternodeprivkey=$MN_KEY
#Addnodes
addnode=45.77.199.41:20480
addnode=95.179.140.175:20480
addnode=166.48.188.231:20480
addnode=84.65.3.34:20480
EOF
}

./alqod -daemon
sleep 10
./alqo-cli getmasternodestatus
