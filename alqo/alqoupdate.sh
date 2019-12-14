# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/alqoupdate.sh -O alqoupdate.sh && chmod +x alqoupdate.sh && ./alqoupdate.sh

#!/bin/bash
cd ~
mkdir build
cd build
git clone https://github.com/ALQO-Universe/ALQO.git
sudo apt-get install libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libssl-dev libgmp-dev libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev libzmq3-dev libminiupnpc-dev -y
./autogen.sh
./configure --without-gui --disable-tests
make
cd ~/ALQO
./alqo-cli stop
sleep 10
rm -rf alqod
rm -rf alqo-cli
mv build/alqod ~/ALQO
mv build/alqo-cli ~/ALQO
./alqod -daemon
