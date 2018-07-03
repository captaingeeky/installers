1. download wallet
2. transfer 30k coins
3. get txid and txoutput
4. prep VPS
5. login to VPS and execute script
6. SCRIPT STEPS
  a) Perform pre-checks
    i) check if existing node (multiple not supported, ask to abort or kill existing node)
    ii) check if avail IP
    iii) check if ubuntu 16.04 / 17.04
  e) get Alias from QT wallet (user input)
  f) get TXhash and TXout from transaction (user input)
  g) get latest ganjacoind from web
  h) start daemon and gen privkey / rpcuser / rpcpassword from daemon
  i) kill daemon and erase conf file
  j) write new conf file with generated values (and user input ones)
  k) start daemon and loop until block synced
  j) loop until status 2
  l) prompt user to start alias in wallet
  k) loop until status 9 showing status description each stage. Times out after 30 minutes
  l) show success message OR error message if times out as well as possible fixes. Tell user to run `./deploy.sh sync` once issue is fixed to skip install and go straight to sync.
  
  
