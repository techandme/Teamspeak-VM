# Teamspeak-VM

* VM includes:
* Base OS Ubuntu Server 14.04.04 LTS
* Webmin
* Teamspeak

# How to:
- Download the vm here: link.url.se
- Mount the .vmdk in vbox or xxx start the machine windowed
- Login using: teamspeak////teamspeak
- type in the sudo password: teamspeak
- Sit back and let the machine do the rest
- At the end you will be notified that you need to copy/paste or take a screenshot or write down these things that are displayed:
- USER PASSWORD TOKEN 
- PLEASE DO THIS ELSE YOU WILL NEED TO REINSTALL THE VM UNTILL YOU MANAGE TO COPY/PASTE IT.
- Finally connect using the client, using your internal LAN IP or if you want to make it public, see below.


If you want to access your Teamspeak server from WAN make sure to port forward these ports to your Lan machine:
Per default, the TS3 server creates a virtual voice server on port 9987 (UDP). The ServerQuery is listening on port 10011 (TCP) and file transfers will use port 30033 (TCP).
