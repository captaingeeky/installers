# Masternode-setup-guide

## 1. Wallet Setup

1.1 Download the wallet for your operating system which is available in our wallets repository at
https://github.com/nodiumproject/Wallets <br />
1.2 Launch the wallet and allow it to synchronize <br />
1.3 Click on `debug console` found in `tools` - Type `masternode genkey` - copy the generated key - exit console <br />
1.4 Go to `receiving wallets` found in `files` - create masternode wallet, by creating a new wallet, called `masternode1` <br />
1.5 Send EXACTLY 10,000 coins to `masternode1` wallet <br />
1.6. Go back to `debug console` - Type `masternode outputs` <br />
1.7: Now you should see a transaction hash and the output id, keep them for later. <br />

## 2. Masternode config file

2.1 Go to `open masternode configuration file` - found on the 'tools' menu <br />
   Here you will see the format and an example( these three lines are comments so they have no effect ) <br />
The format is like this:

```
# Masternode config file
# Format: alias IP:port masternodeprivkey collateral_output_txid collateral_output_index
# Example: mn1 127.0.0.2:51474 93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg 2bcd3c84c84f87eaa86e4e56834c92927a07f9e18718810b92e0d0324456a67c 0
```

2.2. Add your own real working node details under it. <br />
2.3. Put the masternode wallet name, i.e - `masternode1` <br />
2.4 Put the server IP address ( your vultr ip or other vps/vm ip) followed by the port :6250 <br />
2.5 Put the private key generated in step 1.3 <br />
2.6 Put the transaction hash and output id from step 1.7 <br />
Example below

```
masternode1 124.842.07.0:6250 119cCx5YeA519YkTzun4EptdexAo3RvQXaPdkP 838328ce57cc8b168d932d138001781b77b22470c05cf2235a3284093cb0019db 0
```

2.7 Once complete, save the file <br />

The file will look like this:
```
# Masternode config file
# Format: alias IP:port masternodeprivkey collateral_output_txid collateral_output_index
# Example: mn1 127.0.0.2:51474 93HaYBVUCYjEMeeH1Y4sBGLALQZE1Yc1K64xiqgX37tGBDQL8Xg 2bcd3c84c84f87eaa86e4e56834c92927a07f9e18718810b92e0d0324456a67c 0
masternode1 124.842.07.0:6250 119cCx5YeA519YkTzun4EptdexAo3RvQXaPdkP 838328ce57cc8b168d932d138001781b77b22470c05cf2235a3284093cb0019db 0
```

## 3. Preparing the VPS config file with wallet information

(Get ready for some linux, as seen in steps below you will use it) <br />

3.1 Copy this, and save as a file to use later on your desktop for example.

1. externalip and bind = your vultr ip address
2. masternodeaddr = your vultr ip address + port
3. masternodeprivkey = masternode gen key

(Keep the private key to yourself and do not share it with anyone !!!! )

```
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
masternode=1
externalip=207.148.3.88
bind=207.148.3.88
masternodeaddr=207.148.3.88
masternodeprivkey=13bkESxBStGfzHAGAAke61kX0E5tLUeNgTTHWhpmJ5EBai4XZFa
```

Above is a non functioning dummy, replace with your own
The Wallet configuration is now completed. Congratulations!

*****

# 4. Set up the Masternode on a Linux VPS

## 4.1 Choose your VPS

VPS server required: We recommend the following specifications:
- www.vultr.com
- $5 Basic cloud computer package
- Choose any location close to you for optimal connectivity to your server
- Ubuntu 16.04.x64
- Server (Name anything you want, i.e matrix)

## 4.2 Start an SSH session

Depending upon which operating system you are using. Download the following software:

- [Windows - PUTTY](https://www.putty.org/)
- Mac/Linux - Terminal ( preinstalled ) - You can find terminal by following the steps: Go to finder, then click on utilities, then you'll find terminal there.

Next:

4.2.1 Load the SSH terminal<br />
4.2.2 Copy your IP from the VPS - And for windows Putty simply put in the IP and press enter. For Mac, use the command: ssh root@(yourserveripaddress)<br />
4.2.3 It will login to server. Follow the commands below, typing one by one, each line, followed by pressing enter<br />
4.2.4 Username: root<br />
4.2.5 Password: (vultr password)<br />

4.3 in your SSH session, type:

```
wget https://raw.githubusercontent.com/zaemliss/installers/master/nodium/nodium.sh
chmod +x nodium.sh
./nodium.sh
```

and follow the on-screen instructions

Wait a few minutes then go to your Windows or Mac wallet, Masternodes tab, Start All.
