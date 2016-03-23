#!/bin/bash
#
## Tech and Me ## - ©2016, https://www.techandme.se/
#
ROOT_PROFILE="/root/.bash_profile"

rm /root/.profile

cat <<-ROOT-PROFILE > "$ROOT_PROFILE"
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
if [ -x /var/scripts/setup.sh ]; then
        /var/scripts/setup.sh
fi
mesg n
ROOT-PROFILE
