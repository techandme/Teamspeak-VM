#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#

IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
IFACE=$($IP -o link show | awk '{print $2,$9}' | grep "UP" | cut -d ":" -f 1)
IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
INTERFACES="/etc/network/interfaces"

ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
NETMASK=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $8; exit}')
GATEWAY=$($IP route | awk '/\<default\>/ {print $3; exit}')

cat <<-IPCONFIG > "$INTERFACES"
        auto lo $IFACE
        iface lo inet loopback
        iface $IFACE inet static
                address $ADDRESS
                netmask $NETMASK
                gateway $GATEWAY
                pre-up /sbin/ethtool -K $IFACE tso off
                pre-up /sbin/ethtool -K $IFACE gso off

# Exit and save:	[CTRL+X] + [Y] + [ENTER]
# Exit without saving:	[CTRL+X]
IPCONFIG

exit 0
