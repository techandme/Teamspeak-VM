#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
#PID_TS=(ps -ef | grep "teamspeak3" | awk '{print $2}')

# Add user
useradd teamspeak3
sed -i 's|:/home/teamspeak3:|:/home/teamspeak3:/usr/sbin/nologin|g' /etc/passwd

# Get Teamspeak
wget http://ftp.4players.de/pub/hosted/ts3/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz -P /tmp

# Unpack Teamspeak
tar xzf /tmp/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz

# Move to right directory
mv /tmp/teamspeak3-server_linux-amd64 /usr/local/teamspeak3

# Set ownership
chown -R teamspeak3 /usr/local/teamspeak3

# Add to upstart
ln -s /usr/local/teamspeak3/ts3server_startscript.sh /etc/init.d/teamspeak3
update-rc.d teamspeak3 defaults

# Warning
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| Next you will need to copy/paste 3 things to a safe location       |"
echo    "|                                                                    |"
echo -e "|         \e[0mLogin, password, security token\e[32m                            |"
echo    "|                                                                    |"
echo -e "|         \e[0mIF YOU FAIL TO DO SO, YOU HAVE TO REINSTALL YOUR SYSTEM\e[32m    |"
echo    "|                                                                    |"
echo -e "|    \e[91mPress Ctrl + C when your done and please reboot                  |"
echo    "|    With the command "reboot" to finish the install.          |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to start copying the important stuff to a safe location..." -n1 -s
echo -e "\e[0m"
echo

# Start service
service teamspeak3 start && sleep 120 && reboot
#sleep 60 && kill -INT $PID_TS | service teamspeak3 start
