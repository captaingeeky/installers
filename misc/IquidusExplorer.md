### install Node.js and NPM
```
sudo apt update
sudo apt upgrade
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install -y nodejs
```

### install compiler pre-requisites
```
sudo apt install -y git nano build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev miniupnpc libminiupnpc-dev autoconf pkg-config libtool autotools-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev automake
```

### install Mongo DB
```
sudo apt install -y mongodb
```

### create a swap partition
```
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo -e "/swapfile none swap sw 0 0 \n" >> /etc/fstab > /dev/null 2>&1
```

### create the database to use with the explorer
```
mongo
> use explorerdb
```
#### create user with read/write access:
```
> db.createUser( { user: "iquidus", pwd: "enter_your_own_password", roles: [ "readWrite" ] } )
```

### clone the explorer
```
cd ~
git clone https://github.com/iquidus/explorer explorer
```

### perform the installation
```
cd explorer && npm install --production
```
(if there are errors, perform an ``` npm audit ``` and fix as many as you can)

### configure the  explorer
```
cp ./settings.json.template ./settings.json
nano ./settings.json
```

### start the explorer
```
npm start
```

(to be continued)
