# Masternode-setup-guide

# 1. Introduction

This guide is for a single masternode, on a Ubuntu 16.04 64bit server (VPS) running headless and will be controlled from the wallet on your local computer (Control wallet). The wallet on the VPS will be referred to as the Remote wallet.
You will need your server details for progressing through this guide.
First the basic requirements:
10,000 ALQO(may need a fraction of a ALQO more to cover for the transaction fee)
A main computer (Your everyday computer) — This will run the control wallet, hold your collateral 10,000 ALQO and can be not running without affecting the masternode.
Masternode Server (VPS — The computer/node that will be on 24/7)
A unique IP address for your VPS / Remote wallet
(For security reasons, you’re are going to need a different IP for each masternode you plan to host)
The basic reasoning for these requirements is that, you get to keep your ALQO in your local wallet and host your masternode remotely, securely..

# 2. Wallet configuration

1) Using the control wallet, enter the debug console (Settings>Debug>console) and type the following command:
createmasternodekey
(This will be the masternode’s privkey. We’ll use this later…)
2) Using the control wallet still, enter the following command:
getaccountaddress <AnyNameForYourMasternode>
3) Still in the control wallet, send 10,000 ALQO to the address you generated in step 2 (Be 100% sure that you entered the address correctly. You can verify this when you paste the address into the “Pay To:” field, the label will autopopulate with the name you chose”, also make sure this is exactly 10,000 ALQO; No less, no more.)
– Be absolutely 100% sure that this is copied correctly. And then check it again. We cannot help you, if you send 10,000 ALQO to an incorrect address.
4) Still in the control wallet, enter the command into the console:
getmasternodeoutputs (This gets the proof of transaction of sending 10,000)
5) Still on the main computer, we need to edit the masternode.conf. You can find the file in the ALQO data directory, by default in Windows: it’ll be%Appdata%/ALQO or Linux:~
Once you have the masternode.conf file open in a text editor, add the following line to it:
<Name of Masternode(Use the name you entered earlier for simplicity)> <Unique IP address>:20480<The result of Step 1> <Result of Step 4> <The number after the long line in Step 4>
Example: MN1 31.14.135.27:20480 892WPpkqbr7sr6Si4fdsfssjjapuFzAXwETCrpPJubnrmU6aKzh c8f4965ea57a68d0e6dd384324dfd28cfbe0c801015b973e7331db8ce018716999 1
Substitute it with your own values and without the “<>”s2.1 Choose your VPS

# 3. VPS Remote wallet install

- [www.vultr.com](https://www.vultr.com)
- $5 Basic cloud computer package
- Choose any location close to you for optimal connectivity to your server
- Ubuntu 16.04.x64
- Server (Name anything you want, i.e matrix)</br>

# 3.1 Start an SSH session

Depending upon which operating system you are using. Download the following software:

- [Windows - PUTTY](https://www.putty.org/)
- Mac/Linux - Terminal ( preinstalled ) - You can find terminal by following the steps: Go to finder, then click on utilities, then you'll find terminal there.

Next:

3.1.1 Load the SSH terminal<br />

3.1.2 Copy your IP from the VPS - And for windows Putty simply put in the IP and press enter. For Mac/Linux, use the command: 
```
ssh root@(yourserveripaddress)
```

3.1.3 It will connect to the server. Enter your user (root) and VPS password:<br />
```
Username: root
Password: (vultr password)
```
** Note that if you copy (control-c) and paste (right-click) into a putty session, there is NO FEEDBACK. That means you won't see the characters being typed or pasted in. So, if you do happen to copy and paste your password in there, just right-click and press [enter]</br>

# 3.2 Installing the Masternode on the VPS

3.2.1 Copy the following text and paste it at the terminal prompt:
```
cd ~ && wget https://github.com/zaemliss/installers/raw/master/atheneum/aeminstall.sh -O aeminstall.sh && chmod +x aeminstall.sh && ./aeminstall.sh (needs to change)
```

3.2.2 Press `ENTER` Then Simply follow the on-screen instructions.

# 4. Questions?

If you have a problem or a question you can find us in the #support channel on our Discord. 
