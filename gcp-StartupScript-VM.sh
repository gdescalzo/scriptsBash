# Start of the startup-script
logger -i -p INFO "## Starting startup-script ##"

# User configuration
logger -i -p INFO "## User config ##" ;
useradd -m -s /bin/bash -c "some_user" "some_user" ;
echo "some_user:some_password" | chpasswd ;
echo "root:some_root_password" | chpasswd ; 

# Disable IPv6
logger -i -p INFO "Disable IPv6" ;
sysctl -w net.ipv6.conf.all.disable_ipv6=1 ;
sysctl -w net.ipv6.conf.default.disable_ipv6=1 ;
sysctl -p ; 

# Update time and region
logger -i -p INFO "Update time and region" ; 
timedatectl set-timezone America/Argentina/Buenos_Aires ; 

# Mount NAS file system
logger -i -p INFO "Mount NAS file system." ; 
mkdir -p /mnt/cloudleader_nas
echo "10.166.30.2:/cloudleader_nas /mnt/cloudleader_nas nfs defaults,_netdev 0 0" >> /etc/fstab
chow -R some_user:some_user /mnt/cloudleader_nas
