# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/wallettest.sh -O wallettest.sh && chmod +x wallettest.sh && ./wallettest.sh
#!/bin/bash	
sudo apt-get update	
sudo apt-get install build-essential software-properties-common -y	
sudo add-apt-repository ppa:bitcoin/bitcoin	
sudo apt-get update	
fallocate -l 3G /swapfile	
chmod 600 /swapfile	
mkswap /swapfile	
swapon /swapfile	
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
git clone https://github.com/ALQO-Universe/ALQO.git
cd ALQO
sudo apt-get install libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libssl-dev libgmp-dev libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev libzmq3-dev libminiupnpc-dev -y
./autogen.sh
./configure --without-gui --disable-tests
make
mv src/alqod ~/ALQO
mv src/alqo-cli ~/ALQO
cd ~
ls
