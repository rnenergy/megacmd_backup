#! /bin/bash

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

#megacmd setup
blue=`tput setaf 4`
white=`tput setab 7`
clear=`tput sgr0`
echo "${blue}${white}Now you need to login  to your Mega.io account!${clear}"
echo "Paste your login (e.g. email):"
read login

read -s -p 'Password please: ' password 
mega-login $login $password
if mega-login $login $password
then
    echo "Ok"

    echo "${blue}${white}Now you need to configure backup.${clear}"
    echo "${blue}Make sure you know path to dump. Check in Proxmox GUI (default is /var/lib/vz/dump)${clear}"
    read local_path
    echo "${blue}${white}Define remote path in Mega.io cloud (/your_path)${clear}"
    read remote_path 

    echo "${blue}${white}Define interval/period within backup may be done (e.g. 1m12d3h or cron like format)${clear}"
    read time_int

    echo "${blue}${white}Finally, define number of backups you would like to store${clear}"
    read num_b

    mega-backup $local_path $remote_path --period="$time_int" --num-backups=$num_b

    echo "${blue}${white}Everything is OK!!!${clear}"
    else
        echo "${blue}${white}Wrong password or login! Try to run script again!${clear}"
fi

#SET UP Monitoring via Telegra_Bot
echo "${blue}${white}Now you need to configure backup checking.${clear}"

#Mega.io backup folder
echo "${blue}${white}Specify Mega.io backup folder (/your/folder)${clear}"
read ba_folder

#Time interval to check if backups exists
echo "${blue}${white}Specify Time Interval to check if backups exists (cron type or +1m12d3h - means is there any backups were made duaring  1Month 12Days 3Hours)${clear}"
read ba_time

#Approx size of backup file
echo "${blue}${white}Specify Approx size of backup file (+1m12k3B - means no less then 1Mb12Kb3byte)${clear}"
read ba_size

cat << EOF >> comm_vars.txt
export b_folder="$ba_folder"
export b_time="$ba_time"
export b_size="$ba_size"
EOF

#CRON JOB SETUP
echo "${blue}${white}Add to the end of file the CRON Like format period e.g. < 0 12 * * * ./check_backups.sh means run script at 12 oclock every day. ARE YOU READY??? (type 'y' or 'n')${clear}"
read answer
if [ $answer = y ]
    then
        crontab -e
        crontab -l
    else
        echo "${blue}${white}You will not monitor your backups${clear}"
fi


