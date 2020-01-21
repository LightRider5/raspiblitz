#!/bin/bash

# command info
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
 echo "config script to install or uninstall lndmanage"
 echo "bonus.lndmanage.sh [on|off]"
 exit 1
fi

source /mnt/hdd/raspiblitz.conf

# add default value to raspi config if needed
if ! grep -Eq "^lndmanage=" /mnt/hdd/raspiblitz.conf; then
  echo "lndmanage=off" >> /mnt/hdd/raspiblitz.conf
fi

# install
if [ "$1" = "1" ] || [ "$1" = "on" ]; then

  if [ -d "/home/admin/lndmanage" ]; then
    echo "LNDMANAGE already installed"
    exit 1
  fi
  
  echo "*** INSTALL LNDMANAGE ***"
  mkdir /home/admin/lndmanage
  sudo chown admin:admin /home/admin/lndmanage
  cd /home/admin/lndmanage
  # activate virtual environment
  python3 -m venv venv
  source /home/admin/lndmanage/venv/bin/activate
  # get dependencies
  sudo apt install -y python3-dev libatlas-base-dev
  python3 -m pip install wheel
  python3 -m pip install lndmanage==0.8.0.1

  # setting value in raspi blitz config
  sudo sed -i "s/^lndmanage=.*/lndmanage=on/g" /mnt/hdd/raspiblitz.conf

  echo "usage: https://github.com/bitromortac/lndmanage/blob/master/README.md"
  echo "To start type: 'manage' in the command line."
  echo "To exit the venv - type 'deactivate' and press ENTER"

  exit 0
fi

# switch off
if [ "$1" = "0" ] || [ "$1" = "off" ]; then

  # setting value in raspi blitz config
  sudo sed -i "s/^lndmanage=.*/lndmanage=off/g" /mnt/hdd/raspiblitz.conf
  
  echo "*** REMOVING LNDMANAGE ***"
  sudo rm -rf /home/admin/lndmanage
  echo "OK, lndmanage is removed."
  exit 0

fi

echo "FAIL - Unknown Parameter $1"
exit 1