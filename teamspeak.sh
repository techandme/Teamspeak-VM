#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
#PID_TS=(ps -ef | grep "teamspeak3" | awk '{print $2}')

# Add user
NEWUSER=teamspeak3
adduser --disabled-password --gecos "" "$NEWUSER"
sudo usermod -aG sudo "$NEWUSER"
usermod -s /sbin/nologin "$NEWUSER"

# Get Teamspeak
wget http://dl.4players.de/ts/releases/3.1.0/teamspeak3-server_linux_amd64-3.1.0.tar.bz2

# Unpack Teamspeak
tar jxf teamspeak3-server_linux_amd64-3.1.0.tar.bz2

# Move to correct directory
cd teamspeak3-server_linux_amd64 && mv * /home/$NEWUSER && cd .. && rm -rf teamspeak3*
touch /home/$NEWUSER/.ts3server_license_accepted

# Set ownership
chown -R $NEWUSER:$NEWUSER /home/$NEWUSER

# Add service
cat << TEAMSPEAK3 > "/lib/systemd/system/teamspeak.service"
[Unit]
Description=TeamSpeak 3 Server
After=network.target

[Service]
WorkingDirectory=/home/$NEWUSER
User=$NEWUSER
Group=$NEWUSER
Type=forking
ExecStart=/home/$NEWUSER/ts3server_startscript.sh start inifile=ts3server.ini
ExecStop=/home/$NEWUSER/ts3server_startscript.sh stop
PIDFile=/home/$NEWUSER/ts3server.pid
RestartSec=15
Restart=always

[Install]
WantedBy=multi-user.target
TEAMSPEAK3

systemctl --system daemon-reload
systemctl enable teamspeak.service
systemctl start teamspeak.service
systemctl status teamspeak.service

# Show server token
sleep 5
cat /home/$NEWUSER/logs/ts3server_*

# Set firewall rules
SCRIPTS=/var/scripts
bash $SCRIPTS/ufw.sh

# Warning
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| Next you will need to copy/paste 3 things to a safe location       |"
echo    "|                                                                    |"
echo -e "|         \e[0mLOGIN, PASSWORD, SECURITY TOKEN\e[32m                            |"
echo    "|                                                                    |"
echo -e "|         \e[0mIF YOU FAIL TO DO SO, YOU HAVE TO REINSTALL YOUR SYSTEM\e[32m    |"
echo    "|                                                                    |"
echo    "+--------------------------------------------------------------------+"
echo

any_key() {
    local PROMPT="$@"
    read -r -p "$(printf "${PROMPT}")" -n1 -s
    echo
}
any_key Press any key to reboot...
echo -e "\e[32m"
reboot

