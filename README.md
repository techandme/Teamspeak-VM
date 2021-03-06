# Teamspeak-VM

* VM includes:
* Base OS Ubuntu Server 16.04 LTS
* Webmin
* Teamspeak

# How to:
- Download the vm here: https://techandme.fsgo.se/teamspeak-vm/
- Mount the .vmdk in VBox or VMWare start the machine windowed, or headless and use ssh.
- Login using: teamspeak////teamspeak
- type in the sudo password: teamspeak
- Sit back and let the machine do the rest
- At the end you will be notified that you need to copy/paste or take a screenshot or write down these things that are displayed:
- USER PASSWORD TOKEN 
- PLEASE DO THIS ELSE YOU WILL NEED TO REINSTALL THE VM UNTILL YOU MANAGE TO COPY/PASTE IT.
- Finally connect using the client, using your internal LAN IP or if you want to make it public, see below.

# How to install on clean vm you already have:
- wget https://raw.githubusercontent.com/techandme/Teamspeak-VM/master/initial.sh
- bash initial.sh
- exit, ssh back in / log back in and follow the instructions

If you want to access your Teamspeak server from WAN make sure to port forward these ports to your Lan machine:
Per default, the TS3 server creates a virtual voice server on port 9987 (UDP). The ServerQuery is listening on port 10011 (TCP) and file transfers will use port 30033 (TCP).

# https://www.techandme.se for more virtual machines, guides, news and more
Please use this issue tracker https://github.com/techandme/Teamspeak-VM/issues if something went wrong, but before that, please read the README to check if you have done everything right.
