#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
# Change DNS
echo "nameserver 8.26.56.26" > /etc/resolvconf/resolv.conf.d/base
echo "nameserver 8.20.247.20" >> /etc/resolvconf/resolv.conf.d/base
