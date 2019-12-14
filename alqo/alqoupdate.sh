# cd ~ && wget https://raw.githubusercontent.com/captaingeeky/installers/master/alqo/alqoupdate.sh -O alqoupdate.sh && chmod +x alqoupdate.sh && ./alqoupdate.sh

#!/bin/bash
cd ~
mkdir build
cd build
git clone https://github.com/ALQO-Universe/ALQO.git
cd ALQO
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
