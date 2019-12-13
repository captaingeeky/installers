# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/wallettest.sh -O wallettest.sh && chmod +x wallettest.sh && ./wallettest.sh

#!/bin/bash
sudo apt-get update
sudo apt-get install build-essential software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
git clone https://github.com/ALQO-Universe/ALQO.git
cd ALQO
sudo apt-get install libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libssl-dev libgmp-dev libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev libzmq3-dev libminiupnpc-dev -y
./autogen.sh
./configure --without-gui --disable-tests
make
mv src/alqod ~
mv src/alqo-cli ~
cd ~
ls
