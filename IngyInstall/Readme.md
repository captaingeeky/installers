# Ingenuity Information Scriptlet 
to download:
```
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/ingyinfo -O /usr/local/bin/ingyinfo && chmod +x /usr/local/bin/ingyinfo
```

to execute the script:
```
ingyinfo
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
## To use, simply copy and paste the relevant code below into your VPS. The script will do the rest.
SINGLE MN ON A VPS:
```
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/update_single.sh -O update_single.sh && chmod +x update_single.sh && ./update_single.sh
```

MULTIPLE MN ON A VPS:
```
wget https://raw.githubusercontent.com/zaemliss/installers/master/IngyInstall/update_many.sh -O update_many.sh && chmod +x update_many.sh && ./update_many.sh
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


