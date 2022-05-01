#! /bin/bash
#Import vars
. comm_vars.txt
#VM ID (optional)
#VM_ID="100"
#Define Mega.io path/folder, time interval and size to check backups
#folder="/roman" #Enter full path to folder where you want to check if backup files exist
#mtime="+24h" #"+1m12d3h" shows files modified before 1 month, 12 days and 3 hours the current moment
#size="+100m" #"+1m12k3B" shows files bigger than 1 Mega, 12 Kbytes and 3Bytes

time=$(date +"%T")
    echo "Current time: $time" 

files=$(mega-find $b_folder --pattern=*.tar.* --mtime="$b_time" --size="$b_size")
SUB=".tar."

output=$(echo "$files")

if [[ "$output" == *"$SUB"* ]];
    then 
        telegram-send "Бэкапы Proxmox VE на $HOSTNAME успешно залиты на Мега.іо!"
    else
        telegram-send "ТРЕВОГА!!!! Бэкапы Proxmox VE на $HOSTNAME НЕ ЗАЛИТЫ на Мега.іо!!!!"
fi

#If you need check exact VM's backup, you need just add another check_backups.sh script 
#where you need to determine VM_ID var and add it in a string "--pattern=$VM_ID*.$file_type" and then 
#create cron job for this script as you want.
