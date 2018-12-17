# 1. add up to 2 more IP addresses via settings in the Vultr control pannel for your server.

# 2. edit the network config file to add the adapters
```
nano /etc/network/interfaces
```
add:
```
auto ens3:0
iface ens3:0 inet static
address 2nd_ip_address_here
netmask 255.255.255.0

auto ens3:1
iface ens3:1 inet static
address 3rd_ip_address_here
netmask 255.255.255.0
```
(Obviously, replace 2nd_ip_address_here and 3rd_ip_address_here by your actual new ip addresses)

# 3. Reboot the server
```
sudo reboot now
```
