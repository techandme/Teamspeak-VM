#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
CLEARBOOT=$(dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | xargs sudo apt-get -y purge)
SCRIPTS=/var/scripts

ask_yes_or_no() {
    read -r -p "$1 ([y]es or [N]o): "
    case ${REPLY,,} in
        y|yes)
            echo "yes"
        ;;
        *)
            echo "no"
        ;;
    esac
}

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
echo "| - Install Teamspeak                                                |"
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

network_ok() {
    echo "Testing if network is OK..."
    service networking restart
    if wget -q -T 20 -t 2 http://github.com -O /dev/null
    then
        return 0
    else
        return 1
    fi
}

# Check network
if network_ok
then
    printf "Online!\n"
else
    echo "Setting correct interface..."
    [ -z "$IFACE" ] && IFACE=$(lshw -c network | grep "logical name" | awk '{print $3; exit}')
    # Set correct interface
    {
        sed '/# The primary network interface/q' /etc/network/interfaces
        printf 'auto %s\niface %s inet dhcp\n# This is an autoconfigured IPv6 interface\niface %s inet6 auto\n' "$IFACE" "$IFACE" "$IFACE"
    } > /etc/network/interfaces.new
    mv /etc/network/interfaces.new /etc/network/interfaces
    service networking restart
    # shellcheck source=lib.sh
    CHECK_CURRENT_REPO=1 . <(curl -sL https://raw.githubusercontent.com/nextcloud/vm/master/lib.sh)
    unset CHECK_CURRENT_REPO
fi

# Check network
if network_ok
then
    printf "Online!\n"
else
    echo "Network NOT OK!"
    echo "You must have a working Network connection to run this script."
    echo "Please report this issue here: https://github.com/techandme/Teamspeak-VM"
    exit 1
fi

# Set keyboard layout
echo "Current keyboard layout is $(localectl status | grep "Layout" | awk '{print $3}')"
if [[ "no" == $(ask_yes_or_no "Do you want to change keyboard layout?") ]]
then
    echo "Not changing keyboard layout..."
    sleep 1
    clear
else
    dpkg-reconfigure keyboard-configuration
    clear
fi

# Change Timezone
echo "Current timezone is $(cat /etc/timezone)"
if [[ "no" == $(ask_yes_or_no "Do you want to change the timezone?") ]]
then
    echo "Not changing timezone..."
    sleep 1
    clear
else
    dpkg-reconfigure tzdata
clear
fi

# Update system
apt update
apt upgrade -y
apt dist-upgrade -y
clear

# Install figlet
apt-get install figlet -y
clear

# Change IP
IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
INTERFACES="/etc/network/interfaces"
IFACE=$($IP -o link show | awk '{print $2,$9}' | grep "UP" | cut -d ":" -f 1)
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
ifdown $IFACE
sleep 2
ifup $IFACE
sleep 2
bash $SCRIPTS/ip.sh
ifdown $IFACE
sleep 2
ifup $IFACE
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
ifdown $IFACE
sleep 2
ifup $IFACE
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
bash $SCRIPTS/ufw.sh
bash $SCRIPTS/webmin.sh

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

# Cleanup 2
rm $SCRIPTS/ip*
rm $SCRIPTS/test_connection*
rm $SCRIPTS/webmin*
rm $SCRIPTS/ufw*
sed -i "s|instruction.sh|techandme.se|g" /home/teamspeak/.bash_profile
sed -i 's|sudo -i||g' /home/teamspeak/.bash_profile
cat /dev/null > ~/.bash_history
cat /dev/null > /var/spool/mail/root
cat /dev/null > /var/spool/mail/teamspeak
cat /dev/null > /var/log/cronjobs_success.log

# Reset root's .bash_profile
cat /dev/null > /root/.bash_profile
cat << BASHROOT > "/root/.bash_profile"
# ~/.profile: executed by Bourne-compatible login shells.
if [ "/bin/bash" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n

BASHROOT
# Reset rc.local
cat /dev/null > /etc/rc.local
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

bash $SCRIPTS/teamspeak.sh

find /root /home/"$SUDO_USER" -type f \( -name '*.sh*' -o -name '*.html*' -o -name '*.tar*' -o -name '*.zip*' \) -delete

## Reboot
reboot
exit 0
