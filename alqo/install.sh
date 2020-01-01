# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/install.sh -O install.sh && chmod +x install.sh && ./install.sh
#!/bin/bash
Cur_Wallet=""
red='\033[1;31m'
grn='\033[1;32m'
yel='\033[1;33m'
blu='\033[1;36m'
clr='\033[0m'
echo
echo -ne "${blu}Installing Requisites${NC}"
echo
echo -ne "${grn} >Progress: ${blu}[###-----------]\r"
sudo apt-get update  > /dev/null 2>&1
sudo apt-get install build-essential software-properties-common -y  > /dev/null 2>&1
sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
echo -ne "${grn} >Progress: ${blu}[#####---------]\r"
sudo apt-get update  > /dev/null 2>&1
sudo apt-get install libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libssl-dev libgmp-dev libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev libzmq3-dev libminiupnpc-dev -y  > /dev/null 2>&1
echo -ne "${grn} >Progress: ${blu}[#######-------]\r"

CHKSWAP=`free | grep Swap | awk '{print $2}'`
if [ "CHKSWAP" == "0" ]
then
  fallocate -l 3G /swapfile      > /dev/null 2>&1
  chmod 600 /swapfile      > /dev/null 2>&1
  mkswap /swapfile  > /dev/null 2>&1
  swapon /swapfile  > /dev/null 2>&1
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
  echo "Swap already exists, not creating..."
fi

cd ~
mkdir ALQO
cd ALQO
echo -ne "${grn} >Progress: ${blu}[##########----]\r"
wget https://github.com/ALQO-Universe/ALQO/releases/download/v6.3.0.0-c7fc25cad/ALQO-v6.3.0.0-c7fc25cad-lin64.tgz > /dev/null 2>&1
tar zxvf ALQO-v6.3.0.0-c7fc25cad-lin64.tgz -C ~/ALQO  > /dev/null 2>&1
mv ~/ALQO/ALQO-v6.3.0.0-c7fc25cad-lin64/alqod ~/ALQO
mv ~/ALQO/ALQO-v6.3.0.0-c7fc25cad-lin64/alqo-cli ~/ALQO
echo -ne "${grn} >Progress: ${blu}[##############]${NC}"
./alqod -daemon
echo -e "${blu}Please enter the masternode private key generated in the debug console via ${yel}createmasternodekey ${NC}[0/1]"
read -e -p " : " MN_KEY
echo -e "${blu}Please enter a RPC Username  ${yel}Long and random${NC}[0/1]"
read -e -p " : " RPC_USER
echo -e "${blu}Please enter RPC Password ${yel}Longer and Randomer${NC}[0/1]"
read -e -p " : " PASSWORD
echo -e "${blu}Please enter the masternode IP Address${NC}[0/1]"
read -e -p " : " IPADDRESS
./alqo-cli stop
    echo -ne "${BLUE}Writing the alqo.conf file${NC}"
cat <<EOF > ~/.alqocrypto/alqo.conf
rpcuser=$RPC_USER
rpcpassword=$PASSWORD
rpcallowip=127.0.0.1
server=1
daemon=1
logintimestamps=1
maxconnections=256
externalip=$IPADDRESS
masternode=1
masternodeprivkey=$MN_KEY
#Addnodes
addnode=38.103.14.38:20480
addnode=80.211.7.205:20480
EOF

echo -ne "${blu}Starting Wallet${NC}"
./alqod -daemon
