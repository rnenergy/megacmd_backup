#! /bin/bash
#Define backup file type and VM ID
file_type="tar.zst"
VM_ID="100"
#Define time interval and size to check backups
mtime="+24h" #"+1m12d3h" shows files modified before 1 month, 12 days and 3 hours the current moment
size="+100M" #"+1m12k3B" shows files bigger than 1 Mega, 12 Kbytes and 3Bytes

time=$(date +"%T")
    echo "Current time: $time" 

files=$(mega-find /roman --pattern=*$VM_ID*.$file_type --mtime="$mtime" --size="$size")
SUB=".$file_type"

output=$(echo "$files")

if [[ "$output" == *"$SUB"* ]];
    then 
        telegram-send "Бэкапы в порядке на $HOSTNAME!"
    else
        telegram-send "ТРЕВОГА!!!! Бэкапы не в порядке на $HOSTNAME!!!!"
fi

#If you need check several VMs, you need just copy all above and determine needed vars!
