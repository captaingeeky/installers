## Pre-requisites
```bash
#GIT and Compiler dependencies
sudo apt update
sudo apt upgrade
sudo apt install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git
sudo apt install -y g++-mingw-w64-x86-64
sudo apt install -y unzip

#AEM Dependencies
sudo apt install -y jq software-properties-common curl
sudo apt update > /dev/null 2>&1
sudo apt install -y pwgen build-essential libssl-dev libboost-all-dev libqrencode-dev libminiupnpc-dev
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt update
sudo apt install -y libdb5.3-dev libdb5.3++-dev
sudo apt install -y libzmq5 libboost-system1.58.0 libboost-filesystem1.58.0 libboost-program-options1.58.0 libboost-thread1.58.0 libboost-chrono1.58.0 libminiupnpc10 libevent-pthreads-2.0-5 unzip

# QT Libs and files
sudo apt-get install -y libqt5webkit5-dev qtscript5-dev libqt5help5 qttools5-dev qtdeclarative5-private-dev qtdeclarative5-dev-tools qtbase5-private-dev libqt5xmlpatterns5-dev qtxmlpatterns5-dev-tools qttools5-dev-tools
```


## Compiling for WINDOWS x32:
### ONLY GOT THIS TO WORK ON UBUNTU 14.04 !!!
```bash
sudo update-alternatives --config x86_64-w64-mingw32-g++ #POSIX will be the default one
cd Atheneum/depends/
make HOST=x86_64-w64-mingw32
cd ..
./autogen.sh
CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/opt/local --with-incompatible-bdb
make
```


## Compiling for WINDOWS x64:
### ONLY GOT THIS TO WORK ON UBUNTU 14.04 !!!
```bash
sudo make clean
chmod 777 -R *
sudo apt-get update
sudo apt-get -y upgrade
PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')
cd `pwd`/depends
sudo make -j16 HOST=x86_64-w64-mingw32
cd ..
sudo ./autogen.sh
mkdir db4
wget -c 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=`pwd`/db4
sudo make install
cd ../../
sudo ./autogen.sh
./configure LDFLAGS="-L`pwd`/db4/lib/" CPPFLAGS="-I`pwd`/db4/include/" --prefix=`pwd`/depends/x86_64-w64-mingw32
sudo make -j16
```


## Compiling for Ubuntu        
### ONLY GOT THIS TO WORK ON UBUNTU 16.04 !!!
See https://github.com/PIVX-Project/PIVX/blob/master/doc/build-unix.md
```bash
cd Atheneum
./autogen.sh
./configure #(if you want to build daemon, use --without-gui)
make
```


## Compiling for Mac OSX

1. Revise makefile.am and make sure the naming of the qt wallet is the right naming convention... I.E.: change pivx-qt to atheneum-qt etc...

2. Install Xcode with Command Line Tools

3. Install Dependencies using Homebrew:
```bash
brew install autoconf automake berkeley-db@4 git libevent libtool boost@1.57 miniupnpc openssl pkg-config protobuf qt5 zeromq librsvg
```
4. We need a specific version of boost to build the current Atheneum wallet, and now that it's installed, we need to link it:
```bash
brew link boost@1.57 --force
```
5. Make the Homebrew OpenSSL and Qt headers visible to the configure script.
```bash
export LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/opt/qt/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include -I/usr/local/opt/qt/include"
```
6. Build atheneum-qt
```bash
./autogen.sh
./configure --with-gui=qt5
make
```
### How to get a Atheneum-QT App:
After make is finished, you can create an App bundle inside a disk image with:
```bash
make deploy
```
Once this is done, you'll find AEM-Qt.dmg inside your Core folder. Open and install as usual.



## Harcoding Seeds
### Pre-requisites:
```bash
sudo apt-get install python3-dnspython
```

### Procedure
```bash
cd contrib/seeds
nano nodes_main.txt
```
enter all of the seeds in the format ```x.x.x.x:22000``` one per line. Save and exit
```bash
touch nodes_test.txt
python3 generate-seeds.py . > ../../src/chainparamsseeds.h
```

Then recompile the wallet(s)
