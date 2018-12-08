cd /usr/local/bin
rm ing*
wget https://github.com/IngenuityCoin/Ingenuity/files/2657057/Ingenuity-Daemon-.Ubuntu_16.04.tar.gz
tar -xf Ingenuity-Daemon-.Ubuntu_16.04.tar.gz
cd ~
systemctl stop Ingenuity.service
sleep 5
systemctl start Ingenuity.service
echo "Daemon updated"
ingenuity-cli --version
echo
echo "**************************************************************"
echo "** Remember to restart your masternode in your QT wallet!!! **"
echo "**************************************************************"
