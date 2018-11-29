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
do download:
```
cd ~/.ingenuity
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/nuke.sh -O nuke.sh && chmod +x nuke.sh
```

to execute the script:
```
cd ~/.ingenuity
./nuke.sh
```

# Multiple Ingy on same VPS, different IPs
to download:
```
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/i.sh -O /usr/local/bin/i.sh + chmod +x /usr/local/bin/i.sh
```

to execute (replace ingenuity2 by the # of your MN, ex.: ingenuity3):
```
cd ~
i.sh ingenuity stop
sleep 5
cp -r .ingenuity **.ingenuity2**
i.sh ingenuity start
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/ingenuity.conf -O ~/.ingenuity2/ingenuity.conf
```
