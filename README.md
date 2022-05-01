# megacmd_backup
Backup app to create backups of backup images in Proxmox VE 6.* or Proxmox VE 7.* with Mega.io Cloud

Installation:
The better way is to run all scripts as root user (default user in Proxmox VE is root).
#Install Git
apt install git
#Clone git repository mega_backup
git clone https://github.com/rnenergy/megacmd_backup.git
#cd to megacmd_backup folder
cd ./megacmd_backup
#make scripts executable
chmod +x Install_apps.sh check_backups.sh
#Run script Install_apps.sh and follow few steps to end the setup
./Install_apps.sh

