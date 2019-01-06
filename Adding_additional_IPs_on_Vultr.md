## 1. add up to 2 more IP addresses via settings in the Vultr control pannel for your server.

## 2. edit the network config file to add the adapters
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

## 3. Reboot the server OR restart the networking service
```
sudo reboot now

or

systemctl restart networking.service
```
____________

# Adding IPv6 to Vultr based servers

## 1. Enable IPv6 through settings on the VPS server management

## 2. edit the network config file to add the adapters
```
nano /etc/network/interfaces
```
add:
```
iface ens3 inet6 static
        address 2501:1140:5:5734:5103:01ff:ff12:1c07
        netmask 64
        dns-nameservers 2001:19f0:300:1704::6
        up /sbin/ip -6 addr add dev ens3 2501:1140:5:5734:5103:01ff:ff12:1c08
```
Add an ` up /sbin/ip -6 addr add dev ens3 2501:1140:5:5734:5103:01ff:ff12:1c08 ` for each new IP address (incrementing the HEX value)

## 3. Reboot the server OR restart the networking service
```
sudo reboot now

or

systemctl restart networking.service
```
