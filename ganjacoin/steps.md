1. download wallet
2. transfer 30k coins
3. get txid and txoutput
4. prep VPS
5. login to VPS and execute script
6. SCRIPT STEPS</br>
  a) Perform pre-checks</br>
    i) check if existing node (multiple not supported, ask to abort or kill existing node)</br>
    ii) check if avail IP</br>
    iii) check if ubuntu 16.04 / 17.04</br>
  e) get Alias from QT wallet (user input)</br>
  f) get TXhash and TXout from transaction (user input)</br>
  g) get latest ganjacoind from web</br>
  h) start daemon and gen privkey / rpcuser / rpcpassword from daemon</br>
  i) kill daemon and erase conf file</br>
  j) write new conf file with generated values (and user input ones)</br>
  k) start daemon and loop until block synced</br>
  j) loop until status 2</br>
  l) prompt user to start alias in wallet</br>
  k) loop until status 9 showing status description each stage. Times out after 30 minutes</br>
  l) show success message OR error message if times out as well as possible fixes. Tell user to run `./deploy.sh sync` once issue is fixed to skip install and go straight to sync.</br>
  
  
