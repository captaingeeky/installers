# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/wallettest.sh -O wallettest.sh && chmod +x wallettest.sh && ./wallettest.sh

git clone https://github.com/ALQO-Universe/ALQO.git
cd ALQO
sudo apt-get install libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libssl-dev libgmp-dev libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev libzmq3-dev libminiupnpc-dev -y
./autogen.sh
./configure --without-gui --disable-tests
make
mv src/alqod ~/build
mv src/alqo-cli ~/build
cd ~
ls
