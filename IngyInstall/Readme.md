# Ingenuity Information Scriptlet 
to download:
```
cd ~ && wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/ingyinfo.sh -O ingyinfo.sh && chmod +x ingyinfo.sh
```

to execute the script:
```
cd ~
./ingyinfo.sh
```

# Ingenuity BlockData Nuker
to download:
```
cd ~/.ingenuity
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/nuke.sh -O nuke.sh && chmod +x nuke.sh
```

to execute the script:
```
cd ~/.ingenuity
./nuke.sh
```

# Ingenuity Updater
to download:
```
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/update.sh && chmod +x update.sh && update.sh
```

# Multiple Ingy on same VPS, different IPs
to download:
```
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/i.sh -O /usr/local/bin/i.sh && chmod +x /usr/local/bin/i.sh
```

to execute (replace ingenuity2 by the # of your MN, ex.: ingenuity3):
```
systemctl stop Ingenuity.service
systemctl disable Ingenuity.service
cd ~
sleep 5
cp -r .ingenuity .ingenuity2
i.sh ingenuity start
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/ingenuity.conf -O ~/.ingenuity2/ingenuity.conf
nano ~/.ingenuity2/ingenuity.conf
```
and replace the fields with the proper values. Once that's done, start the node with:
```
i.sh ingenuity2 start
```


