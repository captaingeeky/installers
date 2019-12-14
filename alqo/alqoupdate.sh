

#!/bin/bash
# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/alqoupdate.sh -O alqoupdate.sh && chmod +x alqoupdate.sh && ./alqoupdate.sh
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

    echo
    echo -ne "${BLUE}Updating Wallet${NC}"
    echo
    echo -ne "${GREEN} >Progress: ${BLUE}[###-----------]\r"
    cd ~
    mkdir build
    cd build
    git clone https://github.com/ALQO-Universe/ALQO.git  > /dev/null 2>&1
    echo -ne "${GREEN} >Progress: ${BLUE}[#####---------]\r"
    cd ALQO
    ./autogen.sh  > /dev/null 2>&1
    echo -ne "${GREEN} >Progress: ${BLUE}[#######-------]\r"
    ./configure --without-gui --disable-tests  > /dev/null 2>&1
    echo -ne "${GREEN} >Progress: ${BLUE}[##########----]\r"
    make  > /dev/null 2>&1
    echo -ne "${GREEN} >Progress: ${BLUE}[##############]${NC}"
    cd ~/ALQO
    echo -ne "${BLUE}Stopping old Wallet${NC}"
    ./alqo-cli stop
    sleep 10
    rm -rf alqod
    rm -rf alqo-cli
    mv ~/build/ALQO/src/alqod ~/ALQO
    mv ~/build/ALQO/src/alqo-cli ~/ALQO
    echo -ne "${BLUE}Starting new Wallet${NC}"
    ./alqod -daemon
