# Masternode-setup-guide

## 1. Wallet Setup

1.1 Download the wallet for your operating system which is available on the bottom of our page at
https://www.ganjacoinpro.com/ <br />

1.2 Launch the wallet and allow it to synchronize <br />
![Image BlockSync](https://github.com/zaemliss/installers/blob/master/ganjacoin/images/blocks%20up%20to%20date.png)

1.3 Encrypt your wallet! (Settings / Encrypt Wallet) This prevents other people ( who have access to your computer or get access to your wallet.dat file ) to get in your wallet. Don't lose that password. If you lose it the wallet is locked forever and nobobdy will be able to recover your funds.

1.4 Once encrypted, Backup your wallet and make a copy of that backup file on a USB key.

1.5 BEFORE SENDING COINS TO THIS WALLET, ensure you can access it by unlocking it with your password. 

1.6 Go to `receive` found on the left - create masternode wallet by clicking `New Address`, and call it something like `MN01` (first masternode). If this is not your first MRJA masternode, name it appropriately (ex.: `MN03` if it's your third) <br />

1.7 Send EXACTLY 30,000 coins to the wallet address you've just created by right-clicking on that new address and clicking on `Copy Address` then going to the send tab and pasting that address in the `Pay To` field. Make sure that it's exactly 30000 - no more, no less.<br />

1.8. Go to `Help / Debug Window / Console ` and type `masternode outputs` <br />

1.9. Now you should see a transaction hash and the output id, keep them for later. <br />
```
11:56:52 masternode outputs
11:56:52￼
{
    "187514e80d0d7a5c93121231bcedfe123be12a6cafe4622338a7d150f18" : "0",
}
```
1.10. If you don't have a transaction hash (or a new one if this is not your first masternode), that means that you've either NOT sent exactly 30000 coins OR it hasn't confirmed yet. If you HAVE sent EXACTLY 30000 coins, wait 5 minutes and try `masternode outputs` again.

## 2. Set up the Masternode on a Linux VPS

2.1 Choose your VPS

VPS server required: We recommend the following specifications:
- www.vultr.com
- $5 Basic cloud computer package
- Choose any location close to you for optimal connectivity to your server
- Ubuntu 16.04.x64
- Server (Name anything you want, i.e matrix)

2.2 Start an SSH session

Depending upon which operating system you are using. Download the following software:

- [Windows - PUTTY](https://www.putty.org/)
- Mac/Linux - Terminal ( preinstalled ) - You can find terminal by following the steps: Go to finder, then click on utilities, then you'll find terminal there.

Next:

2.2.1 Load the SSH terminal<br />

2.2.2 Copy your IP from the VPS - And for windows Putty simply put in the IP and press enter. For Mac/Linux, use the command: 
```
ssh root@(yourserveripaddress)
```

2.2.3 It will connect to the server. Enter your user (root) and VPS password:<br />
```
Username: root
Password: (vultr password)
```

# 3. Installing the Masternode on the VPS

3.1 Copy the following text and paste it at the terminal prompt:
```
wget https://github.com/legends420/GanjaCoin/installer/deploy.sh && chmod +x deploy.sh && ./deploy.sh
```

3.2 Press `ENTER` Then Simply follow the on-screen instructions.

# 4. Questions?

If you have a problem or a question you can find us in the #support channel on our Discord. 
