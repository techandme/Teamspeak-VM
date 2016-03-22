
ufw allow 22
ufw allow 9987
ufw allow 10011
ufw allow 30033
ufw allow 10000
ufw enable -y
adduser --disabled-login teamspeak3
wget http://ftp.4players.de/pub/hosted/ts3/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz -p /tmp
tar xzf /tmp/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
sudo mv /tmp/teamspeak3-server_linux-amd64 /usr/local/teamspeak3
sudo chown -R teamspeak3 /usr/local/teamspeak3
sudo ln -s /usr/local/teamspeak3/ts3server_startscript.sh /etc/init.d/teamspeak3
sudo update-rc.d teamspeak3 defaults


enter if your paying attention and are able to copy paste this info
sudo service teamspeak3 start
