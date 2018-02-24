#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
#PID_TS=(ps -ef | grep "teamspeak3" | awk '{print $2}')

# Add user
useradd teamspeak3
sed -i 's|:/home/teamspeak3:|:/home/teamspeak3:/usr/sbin/nologin|g' /etc/passwd

# Get Teamspeak
wget http://dl.4players.de/ts/releases/3.1.0/teamspeak3-server_linux_amd64-3.1.0.tar.bz2 -P /tmp

# Unpack Teamspeak
cd /tmp
tar jxf teamspeak3-server_linux_amd64-3.1.0.tar.bz2
touch .ts3server_license_accepted
cd

# Move to correct directory
mv /tmp/teamspeak3-server_linux_amd64 /usr/local/teamspeak3

# Set ownership
chown -R teamspeak3:root /usr/local/teamspeak3

# Add to upstart
ln -s /usr/local/teamspeak3/ts3server_startscript.sh /etc/init.d/teamspeak3
update-rc.d teamspeak3 defaults

iptables -A INPUT -p udp --dport 9987 -j ACCEPT
iptables -A INPUT -p udp --sport 9987 -j ACCEPT
iptables -A INPUT -p tcp --dport 30033 -j ACCEPT
iptables -A INPUT -p tcp --sport 30033 -j ACCEPT
iptables -A INPUT -p tcp --dport 10011 -j ACCEPT
iptables -A INPUT -p tcp --sport 10011 -j ACCEPT

# Warning
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| Next you will need to copy/paste 3 things to a safe location       |"
echo    "|                                                                    |"
echo -e "|         \e[0mLOGIN, PASSWORD, SECURITY TOKEN\e[32m                            |"
echo    "|                                                                    |"
echo -e "|         \e[0mIF YOU FAIL TO DO SO, YOU HAVE TO REINSTALL YOUR SYSTEM\e[32m    |"
echo    "|                                                                    |"
echo -e "|    \e[91mPress Ctrl + C when your done and please reboot\e[32m                 |"
echo -e "|    \e[91mWith the command "reboot" to finish the install.\e[32m                  |"
echo -e "|    \e[91mWithin 2 minutes the system reboots, after you press enter.\e[32m     |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to start copying the important stuff to a safe location..." -n1 -s
echo -e "\e[0m"
echo

# Start service
service teamspeak3 start && sleep 120 && reboot
#sleep 60 && kill -INT $PID_TS | service teamspeak3 start
