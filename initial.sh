#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
SCRIPTS="/var/scripts"
GITHUB_REPO="https://raw.githubusercontent.com/techandme/Teamspeak-VM/master"
IFACE=$(lshw -c network | grep "logical name" | awk '{print $3}')


# Change DNS
if ! [ -x "$(command -v resolvconf)" ]
then
    apt install resolvconf -y -q
    dpkg-reconfigure resolvconf
fi
echo "nameserver 9.9.9.9" > /etc/resolvconf/resolv.conf.d/base
echo "nameserver 149.112.112.112" >> /etc/resolvconf/resolv.conf.d/base

# Set correct interface
sed -i "s|.*|$IFACE|g" /etc/network/interfaces
service networking restart

# Check network
echo "Testing if network is OK..."
sleep 2
sudo ifdown $IFACE && sudo ifup $IFACE
wget -q --spider http://github.com
	if [ $? -eq 0 ]; then
    		echo -e "\e[32mOnline!\e[0m"
	else
		echo
		echo "Network NOT OK. You must have a working Network connection to run this script."
		echo "You could try to change network settings of this VM to 'Bridged Mode'".
		echo "If that doesn't help, please try to un-check 'Replicate physical host' in"
		echo "the network settings of the VM."
	       	exit 1
	fi

      	# Create dir
if 		[ -d $SCRIPTS ];
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

