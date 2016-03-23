#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
CLEARBOOT=$(dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | xargs sudo apt-get -y purge)
SCRIPTS=/var/scripts

# Check if root
if [ "$(whoami)" != "root" ]; then
        echo
        echo -e "\e[31mSorry, you are not root.\n\e[0mYou must type: \e[36msudo \e[0mbash $SCRIPTS/owncloud-startup-script.sh"
        echo
        exit 1
fi
clear
echo "+--------------------------------------------------------------------+"
echo "| This script will configure your machine and do the following:      |"
echo "|                                                                    |"
echo "| - Install Webmin                                                   |"
echo "| - Upgrade your system to latest version                            |"
echo "| - Set new passwords to Ubuntu Server and webmin                    |"
echo "| - Set new keyboard layout                                          |"
echo "| - Change timezone                                                  |"
echo "| - Set static IP to the system (you have to set the same IP in      |"
echo "|   your router) https://www.techandme.se/open-port-80-443/          |"
echo "|   But then for your machines IP and the Teamspeak ports            |"
echo "|                                                                    |"
echo "|   The script will take about 10 minutes to finish,                 |"
echo "|   depending on your internet connection.                           |"
echo "|                                                                    |"
echo "| ####################### Tech and Me - 2016 ####################### |"
echo "+--------------------------------------------------------------------+"
echo -e "\e[32m"
read -p "Press any key to start the script..." -n1 -s
clear
echo -e "\e[0m"

# Set keyboard layout
echo "Current keyboard layout is Swedish"
echo "You must change keyboard layout to your language"
echo -e "\e[32m"
read -p "Press any key to change keyboard layout... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure keyboard-configuration
echo
clear

# Change Timezone
echo "Current Timezone is Europe/Stockholm"
echo "You must change timezone to your timezone"
echo -e "\e[32m"
read -p "Press any key to change timezone... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure tzdata
echo
sleep 3
clear

# Change IP
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
echo -e "\e[0m"
echo "The script will now configure your IP to be static."
echo -e "\e[36m"
echo -e "\e[1m"
echo "Your internal IP is: $ADDRESS"
echo -e "\e[0m"
echo -e "Write this down, you will need it to set static IP"
echo -e "in your router later. It's included in this guide:"
echo -e "https://www.techandme.se/open-port-80-443/ (step 1 - 5)"
echo -e "Also to connect locally to Teamspeak."
echo -e "\e[32m"
read -p "Press any key to set static IP..." -n1 -s
clear
echo -e "\e[0m"
ifdown eth0
sleep 2
ifup eth0
sleep 2
bash $SCRIPTS/ip.sh
ifdown eth0
sleep 2
ifup eth0
sleep 2
echo
echo "Testing if network is OK..."
sleep 1
echo
bash $SCRIPTS/test_connection.sh
sleep 2
echo
echo -e "\e[0mIf the output is \e[32mConnected! \o/\e[0m everything is working."
echo -e "\e[0mIf the output is \e[31mNot Connected!\e[0m you should change\nyour settings manually in the next step."
echo -e "\e[32m"
read -p "Press any key to open /etc/network/interfaces..." -n1 -s
echo -e "\e[0m"
nano /etc/network/interfaces
clear &&
echo "Testing if network is OK..."
ifdown eth0
sleep 2
ifup eth0
sleep 2
echo
bash $SCRIPTS/test_connection.sh
sleep 2
clear

# Change password
echo -e "\e[0m"
echo "For better security, change the Linux password for [teamspeak]"
echo "The current password is [teamspeak]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
sudo passwd teamspeak
if [[ $? > 0 ]]
then
    sudo passwd teamspeak
else
    sleep 2
fi
echo
clear
bash $SCRIPTS/set_hostname.sh
bash $SCRIPTS/set_nameserver.sh
bash $SCRIPTS/ufw.sh
bash $SCRIPTS/webmin.sh
bash $SCRIPTS/teamspeak.sh

# Upgrade system
clear
echo System will now upgrade...
sleep 2
echo
echo
apt-get install aptitude -y
apt-get update
apt-get upgrade -y
aptitude full-upgrade -y

# Set daily updates
cat << UPDATE_DAILY > "/etc/cron.daily"
#!/bin/sh
apt-get update
apt-get upgrade -y
aptitude full-upgrade -y

exit 0

UPDATE_DAILY

# Cleanup 1
apt-get autoremove -y
echo "$CLEARBOOT"
clear

# Success!
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| You have sucessfully installed Teamspeak! System will now reboot... |"
echo    "|                                                                    |"
echo -e "|         \e[0mLogin to Teamspeak locally with adress:\e[36m" $ADDRESS"\e[32m           |"
echo    "|                                                                    |"
echo -e "|         \e[0mPublish your server online! \e[36mhttps://goo.gl/PRdtPC\e[32m          |"
echo    "|                                                                    |"
echo    "|         \e[0m Firewall is enabled ports 22, 9987, 10011,\e[32m     |"
echo    "|                                                                    |"
echo    "|         \e[0m30033 and 10000 are open.\e[32m                       |"
echo    "|                                                                    |"
echo    "|                                                                    |"
echo    "|         \e[0mAccess webmin at $ADDRESS:10000\e[32m                 |"
echo    "|                                                                    |"
echo -e "|    \e[91m#################### Tech and Me - 2016 ####################\e[32m    |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to reboot..." -n1 -s
echo -e "\e[0m"
echo

# Cleanup 2
rm $SCRIPTS/ip*
rm $SCRIPTS/test_connection*
rm $SCRIPTS/teamspeak*
rm $SCRIPTS/webmin*
rm $SCRIPTS/ufw*
rm $SCRIPTS/set_nameserver*
rm $SCRIPTS/set_hostname*
sed -i "s|instruction.sh|techandme.sh|g" /home/ocadmin/.bash_profile
cat /dev/null > ~/.bash_history
cat /dev/null > /var/spool/mail/root
cat /dev/null > /var/spool/mail/teamspeak
cat /dev/null > /var/log/cronjobs_success.log
sed -i 's|sudo -i||g' /home/teamspeak/.bash_profile
cat << RCLOCAL > "/etc/rc.local"
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0

RCLOCAL

## Reboot
reboot
exit 0
