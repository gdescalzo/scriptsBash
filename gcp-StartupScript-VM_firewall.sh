logger -i -p INFO "## Starting the startup-script ##"

logger -i -p INFO "## Users config ##" ;
useradd -m -s /bin/bash -c "gsv" "gsv" ;
echo "some_user:some_password" | chpasswd ;
echo "root:some_root_password" | chpasswd ; 

logger -i -p INFO "## SSH config ##" ;
cp  /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp ; 

echo Port 10666 > /etc/ssh/sshd_config ;
echo HostKey /etc/ssh/ssh_host_rsa_key >> /etc/ssh/sshd_config ; 
echo HostKey /etc/ssh/ssh_host_ecdsa_key >> /etc/ssh/sshd_config ; 
echo HostKey /etc/ssh/ssh_host_ed25519_key >> /etc/ssh/sshd_config ; 
echo SyslogFacility AUTHPRIV >> /etc/ssh/sshd_config ; 
echo PermitRootLogin no >> /etc/ssh/sshd_config ; 
echo AuthorizedKeysFile      .ssh/authorized_keys  >> /etc/ssh/sshd_config ; 
echo PasswordAuthentication yes >> /etc/ssh/sshd_config ; 
echo ChallengeResponseAuthentication no >> /etc/ssh/sshd_config ; 
echo GSSAPIAuthentication yes >> /etc/ssh/sshd_config ; 
echo GSSAPICleanupCredentials no >> /etc/ssh/sshd_config ; 
echo UsePAM yes >> /etc/ssh/sshd_config ; 
echo X11Forwarding yes >> /etc/ssh/sshd_config ; 
echo ClientAliveInterval 420 >> /etc/ssh/sshd_config ; 
echo AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES  >> /etc/ssh/sshd_config ; 
echo AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT  >> /etc/ssh/sshd_config ; 
echo AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE  >> /etc/ssh/sshd_config ; 
echo AcceptEnv XMODIFIERS >> /etc/ssh/sshd_config ; 
echo Subsystem       sftp    /usr/libexec/openssh/sftp-server  >> /etc/ssh/sshd_config ; 

logger -i -p INFO "## Enable the SSH on the FW and modify the port number ##" ;
semanage port -a -t ssh_port_t -p tcp 10666 ; 
firewall-cmd --permanent --zone=public --add-port=10666/tcp ; 
firewall-cmd --reload ; 
systemctl restart sshd.service ; 


logger -i -p INFO "## Disable IPv6 ##" ;
sysctl -w net.ipv6.conf.all.disable_ipv6=1 ;
sysctl -w net.ipv6.conf.default.disable_ipv6=1 ;
sysctl -p ; 

logger -i -p INFO "## Update time and region ##" ; 
timedatectl set-timezone America/Argentina/Buenos_Aires ; 

logger -i -p INFO "## update SO ##" ;
yum update ;

logger -i -p INFO "## Install SO headers ##" ;
yum install kernel-devel kernel-headers -y ; 
yum install dirmngr tcpdump nmap mc mlocate dnsutils rcconf ca-certificates curl gnupg2 iotop htop iperf hping3 bmon arptables ebtables -y;

logger -i -p INFO "## Add Nethserver repo ##" ;
yum install -y http://mirror.nethserver.org/nethserver/nethserver-release-7.rpm;

logger -i -p INFO "## Instalamos Nethserver ##"
nethserver-install ;


reboot;

logger -i -p INFO "## Startup-script end ##" ;
