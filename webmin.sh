#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
# Install Webmin
sed -i '$a deb http://download.webmin.com/download/repository sarge contrib' /etc/apt/sources.list
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
apt-get update
apt-get install --force-yes -y webmin
IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
IFACE=$($IP -o link show | awk '{print $2,$9}' | grep "UP" | cut -d ":" -f 1)
IFCONFIG="/sbin/ifconfig"
ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
echo
echo "Webmin is installed, access it from your browser: https://$ADDRESS:10000"
sleep 2
clear
