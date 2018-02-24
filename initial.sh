#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
SCRIPTS="/var/scripts"
GITHUB_REPO="https://raw.githubusercontent.com/techandme/Teamspeak-VM/master"
IFACE=$(lshw -c network | grep "logical name" | awk '{print $3; exit}')

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

# Change DNS
if ! [ -x "$(command -v resolvconf)" ]
then
    apt update && apt install resolvconf -y -q
    dpkg-reconfigure resolvconf
fi
echo "nameserver 9.9.9.9" > /etc/resolvconf/resolv.conf.d/base
echo "nameserver 149.112.112.112" >> /etc/resolvconf/resolv.conf.d/base

if [ -d $SCRIPTS ];
then
    sleep 1
else
    mkdir $SCRIPTS
fi

sleep 2 # Avoid latency in messages

echo
echo "Getting all the latest scripts from GitHub..."
echo

# Get setup script
if 		[ -f $SCRIPTS/setup.sh ];
        then
                echo "setup.sh exists"
        else
        	wget -q $GITHUB_REPO/setup.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded setup.sh."
	sleep 1
fi

# Get Teamspeak install script
if 		[ -f $SCRIPTS/teamspeak.sh ];
        then
                echo "teamspeak.sh exists"
        else
        	wget -q $GITHUB_REPO/teamspeak.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded teamspeak.sh."
	sleep 1
fi

# Enable ufw and allow needed ports
if 		[ -f $SCRIPTS/ufw.sh ];
        then
                echo "ufw.sh exists"
        else
        	wget -q $GITHUB_REPO/ufw.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded ufw.sh."
	sleep 1
fi

# Install webmin
if 		[ -f $SCRIPTS/webmin.sh ];
        then
                echo "webmin.sh exists"
        else
        	wget -q $GITHUB_REPO/webmin.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded webmin.sh."
	sleep 1
fi

# The update script
if 		[ -f $SCRIPTS/teamspeak_update.sh ];
        then
        	echo "teamspeak_update.sh exists"
        else
        	wget -q $GITHUB_REPO/teamspeak_update.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded teamspeak_update.sh."
	sleep 1
fi

# Sets static IP to UNIX
if 		[ -f $SCRIPTS/ip.sh ];
        then
                echo "ip.sh exists"
        else
      		wget -q $GITHUB_REPO/ip.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded ip.sh."
	sleep 1
fi

# Tests connection after static IP is set
if 		[ -f $SCRIPTS/test_connection.sh ];
        then
                echo "test_connection.sh exists"
        else
        	wget -q $GITHUB_REPO/test_connection.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded test_connection.sh."
	sleep 1
fi

# Welcome message after login (change in /home/ocadmin/.profile
if 		[ -f $SCRIPTS/instruction.sh ];
        then
                echo "instruction.sh exists"
        else
        	wget -q $GITHUB_REPO/instruction.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded instruction.sh."
	sleep 1
fi

# Tech and Me figlet
if              [ -f $SCRIPTS/techandme.sh ];
        then
                echo "techandme.sh exists"
        else
                wget -q $GITHUB_REPO/techandme.se -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded techandme.sh."
	sleep 1
fi

# Change teamspeak .bash_profile
if 		[ -f $SCRIPTS/change-teamspeak-profile.sh ];
        then
        	echo "change-teamspeak-profile.sh  exists"
        else
        	wget -q $GITHUB_REPO/change-teamspeak-profile.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded change-teamspeak-profile.sh."
	sleep 1
fi

# Change root .bash_profile
if 		[ -f $SCRIPTS/change-root-profile.sh ];
        then
        	echo "change-root-profile.sh  exists"
        else
        	wget -q $GITHUB_REPO/change-root-profile.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded change-root-profile.sh."
	sleep 1
fi

# Get welcome message
if 		[ -f $SCRIPTS/welcome.sh ];
        then
                echo "welcome.sh exists"
        else
        	wget -q $GITHUB_REPO/welcome.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "welcome.sh."
	sleep 1
fi
# Make $SCRIPTS excutable
        	chmod +x -R $SCRIPTS
        	chown root:root -R $SCRIPTS

# Allow teamspeak to run these scripts
        	chown teamspeak:teamspeak $SCRIPTS/instruction.sh
		chown teamspeak:teamspeak $SCRIPTS/techandme.se

#-----------------------------------------------------------
# Change root profile
        	bash $SCRIPTS/change-root-profile.sh
if [[ $? > 0 ]]
then
	echo "change-root-profile.sh were not executed correctly. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "change-root-profile.sh script executed OK."
	sleep 1
fi
# Change ocadmin profile
        	bash $SCRIPTS/change-teamspeak-profile.sh
if [[ $? > 0 ]]
then
	echo "change-teamspeak-profile.sh were not executed correctly. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "change-teamspeak-profile.sh executed OK."
	sleep 1
fi

# Update system
apt update
apt upgrade -y
apt dist-upgrade -y

echo "Rebooting..."
reboot

