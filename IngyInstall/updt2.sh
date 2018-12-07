cd /usr/local/bin
# wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/updt2.sh -O updt2.sh && chmod +x updt2.sh && ./updt2.sh

rm ing*
wget https://github.com/IngenuityCoin/Ingenuity/files/2657057/Ingenuity-Daemon-.Ubuntu_16.04.tar.gz
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/i.sh -O i.sh && chmod +x i.sh
tar -xf Ingenuity-Daemon-.Ubuntu_16.04.tar.gz
cd ~
i.sh ingenuity stop
sleep 5
i.sh ingenuity start
echo "Daemon updated"
i.sh ingenuity --version

i.sh ingenuity2 stop
i.sh ingenuity3 stop
sleep 3
i.sh ingenuity2 start
i.sh ingenuity3 start
