#! /bin/bash

echo "update cashe"
apt update

echo "install Git"
apt install git -y

echo "clone git with megacmd"
git clone https://github.com/rnenergy/megacmd_backup.git
cd megacmd_backup

str1=$(grep "\"Ubuntu 22.04 LTS\""* /etc/os-release)
str2=$(grep "\"Debian GNU/Linux 10 (buster)\""* /etc/os-release)
str3=$(grep "\"Debian GNU/Linux 11 (bullseye)\""* /etc/os-release)

if str1=$(grep "\"Ubuntu 22.04 LTS\""* /etc/os-release)
    then
        dpkg -i ./megacmd-xUbuntu_22.04_amd64.deb
    elif str2=$(grep "\"Debian GNU/Linux 10 (buster)\""* /etc/os-release)
    then
        dpkg -i ./megacmd-Debian_10.0_amd64.deb
    elif str3=$(grep "\"Debian GNU/Linux 11 (bullseye)\""* /etc/os-release)
    then
        dpkg -i ./megacmd-Debian_11_amd64.deb
    else
        echo "You need Deb10 or Deb11 Distro"
fi

echo "install python3-pip and telegram-send"
apt install python3-pip -y
pip3 install telegram-send
    #Insert your t_bot token and send code
    telegram-send --configure

