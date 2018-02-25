#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
#PID_TS=(ps -ef | grep "teamspeak3" | awk '{print $2}')

# Add user
NEWUSER=teamspeak3
adduser --disabled-password --gecos "" "$NEWUSER"
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

# Set firewall rules
SCRIPTS=/var/scripts
bash $SCRIPTS/ufw.sh
clear

msg_box() {
local PROMPT="$1"
    whiptail --msgbox "${PROMPT}" "$WT_HEIGHT" "$WT_WIDTH"
}
msg_box "TeamSpeak is now installed and enabled. 
Please copy the following to a safe location:

SERVERTOKEN = $(cd /home/$NEWUSER/logs && grep -r "token" | awk '{ print $5 }' | cut -d "=" -f 2)
LOGIN = serveradmin
PASSWORD = Please see this site on how to set a password: https://goo.gl/5rahB2"

any_key() {
    local PROMPT="$@"
    read -r -p "$(printf "${PROMPT}")" -n1 -s
    echo
}
any_key Press any key to reboot...
echo -e "\e[32m"
reboot

