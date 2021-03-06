#!/bin/bash

echo "update cashe"
apt update
echo "MegaCMD installation!"
str1=$(grep "\"Ubuntu 22.04 LTS\""* /etc/os-release)
str2=$(grep "\"Debian GNU/Linux 10 (buster)\""* /etc/os-release)
str3=$(grep "\"Debian GNU/Linux 11 (bullseye)\""* /etc/os-release)

if str1=$(grep "\"Ubuntu 22.04 LTS\""* /etc/os-release)
    then
        dpkg -i ./megacmd-xUbuntu_22.04_amd64.deb
    elif str2=$(grep "\"Debian GNU/Linux 10 (buster)\""* /etc/os-release)
    then
        #Depend
        apt install -y libc-ares2 libpcrecpp0v5 python3-pip  python3-distutils python3-setuptools python3-wheel python-pip-whl python3-dev
        apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
        apt install -y libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc
        dpkg -i ./megacmd-Debian_10.0_amd64.deb
    elif str3=$(grep "\"Debian GNU/Linux 11 (bullseye)\""* /etc/os-release)
    then
        apt install -y libc-ares2 libpcrecpp0v5 python3-pip  python3-distutils python3-setuptools python3-wheel python-pip-whl python3-dev
        apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
        apt install -y libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc
        dpkg -i ./megacmd-Debian_11_amd64.deb
    else
        echo "You need Deb10 or Deb11 Distro"
fi

echo "install python3-pip and telegram-send"
    wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
    tar -xf Python-3.10.*.tgz
    cd Python-3.10.*/
    ./configure --enable-optimizations
    make -j 4
    make altinstall
    apt install python3-pip -y
    pip3 install telegram-send
    #Insert your t_bot token and send code
    telegram-send --configure
    
#megacmd setup
blue=`tput setaf 4`
white=`tput setab 7`
clear=`tput sgr0`
echo "${blue}${white}Now you need to login  to your Mega.io account!${clear}"
until [ "$whoi" = "Account e-mail: $login" ]
    do
    echo "Paste your login (e.g. email):"
    read login
    read -s -p 'Password please: ' password 
    mega-login $login $password
    whoi=$(mega-whoami)
    done
    echo "Done!"
#backup folder creation
backup_folder=$(mega-mkdir -p /PROXMOX-backups/$HOSTNAME-backup)
remote_path=/PROXMOX-backups/$HOSTNAME-backup

#Backupconf
    echo "${blue}${white}Now you need to configure backup.${clear}"
    echo "${blue}${white}Make sure you know path to dump. Check in Proxmox GUI (default is /var/lib/vz/dump)${clear}"
    read local_path
    echo "$local_path defined!"
    #echo "${blue}${white}Define remote path in Mega.io cloud (/your_path)${clear}"
    #read remote_path 
        #echo "$remote_path defined!"
    echo "${blue}${white}Define interval/period within backup may be done (e.g. 1m12d3h or cron like format)${clear}"
    read time_int
        echo "$time_init defined!"
    #echo "${blue}${white}Finally, define number of backups you would like to store${clear}"
    #read num_b
        #echo "$num_b defined!"
    mega-backup $local_path $remote_path --period="$time_int" --num-backups=1

    echo "${blue}${white}Everything is OK!!!${clear}"

#SET UP Monitoring via Telegra_Bot
echo "${blue}${white}Now you need to configure backup checking.${clear}"

#Mega.io backup folder
#echo "${blue}${white}Specify Mega.io backup folder (/your/folder)${clear}"
#read ba_folder

#Time interval to check if backups exists
echo "${blue}${white}Specify Time Interval to check if backups exists (-12h+1h - checks files uploaded in the last 12 hours prior to the last hour)${clear}"
read ba_time

#Approx size of backup file
echo "${blue}${white}Specify Approx size of backup file (+1m12k3B - means no less then 1Mb12Kb3byte)${clear}"
read ba_size

cat << EOF >> /root/megacmd_backup/comm_vars.txt
export b_folder="$remote_path"
export b_time="$ba_time"
export b_size="$ba_size"
EOF

#CRON JOB SETUP
echo "${blue}${white}Add to the end of file the CRON Like format period e.g. < 0 12 * * * > /root/megacmd_backup/check_backups.sh (copy this path) means run script at 12 oclock every day UTC format, take into account your time zone. ARE YOU READY??? (type 'y' or 'n')${clear}"
read answer
if [ $answer = y ]
    then
        crontab -e
        crontab -l
    else
        echo "${blue}${white}You will not monitor your backups${clear}"
fi

cd ~/
