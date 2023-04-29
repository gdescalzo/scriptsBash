logger -i -p INFO "## Starting startup-script Proxy configuration - wget ##" ; 

logger -i -p INFO "## wget configuration ##" ; 
echo passive_ftp = on > /etc/wgetrc ; 
echo https_proxy = http://some_user:some_password@10.168.11.2:5555/ >> /etc/wgetrc ; 
echo http_proxy = http://some_user:some_password@10.168.11.2:5555/ >> /etc/wgetrc ; 
echo ftp_proxy = http://some_user:some_password@10.168.11.2:5555/ >> /etc/wgetrc ; 
echo use_proxy = on >> /etc/wgetrc ;

logger -i -p INFO "## apt-get configuration ##"; 
echo 'Acquire::http::proxy "http://some_user:some_password@10.168.11.2:5555/";' > /etc/apt/apt.conf.d/60apt-proxy ; 

logger -i -p INFO "## /etc/enviroment configuration ##" ;
cat <<EOF > /etc/environment
http_proxy="http://some_user:some_password@10.168.11.2:5555"
https_proxy="http://some_user:some_password@10.168.11.2:5555"
ftp_proxy="http://some_user:some_password@10.168.11.2:5555"
no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
HTTP_PROXY="http://some_user:some_password@10.168.11.2:5555"
HTTPS_PROXY="http://some_user:some_password@10.168.11.2:5555"
FTP_PROXY="http://some_user:some_password@10.168.11.2:5555"
NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
EOF
source /etc/enviroment ; 

logger -i -p INFO "## -  ~/.bashrc configuration ##" ;
cp ~/.bashrc  ~/.bashrc.bkp ; 

echo "export http_proxy=http://some_user:some_password@10.168.11.2:5555/" >> ~/.bashrc ; 
echo "export https_proxy=http://some_user:some_password@10.168.11.2:5555/" >> ~/.bashrc ; 
echo "export ftp_proxy=http://some_user:some_password@10.168.11.2:5555/" >> ~/.bashrc ; 
echo "export rsync_proxy=http://some_user:some_password@10.168.11.2:5555/" >> ~/.bashrc ; 
echo "export LS_OPTIONS='--color=auto'"  >> ~/.bashrc ;
echo "alias ll='ls $LS_OPTIONS -l'" >> ~/.bashrc ;
echo "alias l='ls $LS_OPTIONS -lA'" >> ~/.bashrc ;
echo "alias rm='rm -i'" >> ~/.bashrc ;
echo "alias cp='cp -i'" >> ~/.bashrc ;
echo "alias mv='mv -i'" >> ~/.bashrc ;

source ~/.bashrc  ;

logger -i -p INFO "## Docker configuration ##" ; 
mkdir /etc/systemd/system/docker.service.d ; 
touch /etc/systemd/system/docker.service.d/http-proxy.conf ; 
echo "[Service]" > /etc/systemd/system/docker.service.d/http-proxy.conf ; 
echo "Environment="HTTP_PROXY=http://10.168.11.2:5555/" " >> 	/etc/systemd/system/docker.service.d/http-proxy.conf ; 

logger -i -p INFO "## Create a configuring 'some_user' ##" ;
useradd -m -s /bin/bash -c "some_user" "some_user"  ;
echo "some_user:some_password" | chpasswd ;

logger -i -p INFO "## Change root password ##" ; 
echo "root:n0T1ad0y" | chpasswd ; 
logger -i -p INFO " " ; 

logger -i -p INFO "## SSH Configuration ##" ; 
cp  /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp ; 

cat <<EOF > /etc/ssh/sshd_config
Port 10666	
ListenAddress 0.0.0.0
SyslogFacility AUTH
LogLevel VERBOSE
LoginGraceTime 10m
PermitRootLogin no
MaxAuthTries 3
MaxSessions 10
PasswordAuthentication yes
PermitEmptyPasswords no
X11Forwarding no
AcceptEnv LANG LC_*
TCPKeepAlive no
AllowTcpForwarding no
ClientAliveCountMax 2
Compression no
ChallengeResponseAuthentication yes
UsePAM yes
EOF

/etc/init.d/ssh restart ;

logger -i -p INFO "## Disable IPv6 ##" ; 
cp /etc/sysctl.d/99-sysctl.conf /etc/sysctl.d/99-sysctl.conf.bkp ; 

echo #Desabilitamos IPV6 > /etc/sysctl.d/99-sysctl.conf ;
echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.d/99-sysctl.conf ;
echo net.ipv6.conf.default.disable_ipv6 = 1 >> /etc/sysctl.d/99-sysctl.conf ;
echo net.ipv6.conf.lo.disable_ipv6 = 1 >> /etc/sysctl.d/99-sysctl.conf ;
echo net.ipv6.conf.eth0.disable_ipv6 = 1 >> /etc/sysctl.d/99-sysctl.conf ;

sysctl -p ; 

logger -i -p INFO "## NTP Configuration ##" ; 
cp /etc/ntp.conf /etc/ntp.conf.bkp ; 

cat <<EOF > /etc/ntp.conf
driftfile /var/lib/ntp/ntp.drift
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
server 3.ar.pool.ntp.org
server 1.south-america.pool.ntp.org
server 0.south-america.pool.ntp.org
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
restrict source notrap nomodify noquery
EOF
source /etc/ntp.conf ;
systemctl restart ntp ; 

logger -i -p INFO "## TimeZone tzdata configuration ## ; 
rm -f /etc/localtime ; 
ln -fs /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime ; 
dpkg-reconfigure --frontend noninteractive tzdata ; 
logger -i -p INFO " " ; 

logger -i -p INFO "## IP Tables configuration ##" ; 
touch /etc/init.d/gsv.sh ; 
chmod +x /etc/init.d/gsv.sh ; 
chmod 700 /etc/init.d/gsv.sh ; 

cat <<EOF > /etc/init.d/gsv.sh
#!/bin/bash
### BEGIN INIT INFO
# Provides:             Some Name
# Required-Start:       $network_fs
# Required-Stop:        $network_fs
# Default-Start:        2 3 4 5
# Default-Stop:
# Short-Description:	fw-something  										
### END INIT INFO
  
# Delete all rules
iptables -F
iptables -X
#Establecemos Politica de Drop
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
#Nat and conntrak
modprobe ip_conntrack
modprobe ip_conntrack_ftp
#Activacion de bit de forward
echo 1 > /proc/sys/net/ipv4/ip_forward
# Accept NTP
iptables -A INPUT -i eth0 -m state --state NEW -m udp -p udp --dport 123 -j ACCEPT
  
#### Rules to avoid attacks
###############################
#Bloqueando flood
iptables -A INPUT  -m limit --limit 100/minute --limit-burst 200 -j ACCEPT
  
# Avoid SSH brute force
iptables -I INPUT -i eth0 -p tcp -m tcp --dport 10666 -m state --state NEW -m recent --update --seconds 180 --hitcount 4 --name DEFAULT --rsource -j DROP
#Drop de invalidos extendido  																				
iptables -N drop_invalid  																					
iptables -A OUTPUT  -m state --state INVALID  -j drop_invalid
iptables -A INPUT  -m state --state INVALID  -j drop_invalid
iptables -A INPUT -p tcp -m tcp --sport 1:65535 --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j drop_invalid
iptables -A INPUT -p udp -m udp --sport 1:65535 -j drop_invalid
iptables -A drop_invalid -j LOG --log-level debug --log-prefix 'INVALID state -- DENY'
iptables -A drop_invalid -j DROP
#Falsear parte del fingerprint
iptables -I INPUT -p tcp -m osf --genre Windows --ttl 2 -j DROP
#Bloqueo de Syn flood TCP y DDOS  en el kernel
sysctl -w net/ipv4/tcp_syncookies=1
sysctl -w net/ipv4/tcp_timestamps=1
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
echo 2500000 > /sys/module/nf_conntrack/parameters/hashsize
sysctl -w net/netfilter/nf_conntrack_max=2000000
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
sysctl -w net.ipv4.tcp_max_syn_backlog="2048"
sysctl -w net.ipv4.tcp_synack_retries=2
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
  
# Anti UDP Flooding
iptables -I INPUT -p udp -m length --length 15 -j DROP
iptables -A INPUT -p udp -m length --length 15 -j DROP
#Limitar la cantidad de conexiones concurrentes
iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 3 -j REJECT
#Pasadas las 24 Horas, remover la IP Bloqueada por Escaneo de Puertos
iptables -A INPUT -m recent --name portscan --remove
iptables -A FORWARD -m recent --name portscan --remove
  
# This rule add the scan of port to the list of PortScan and track the event.
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix 'Portscan:'
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
# Invalid Upd bad cheksum
iptables -A INPUT -p udp -m udp --sport 19 -j LOG  --log-prefix 'Ataque 19 udp chargen' --log-level 4
iptables -A INPUT -p udp -m udp --sport 19 -j DROP  																
# Drop policy for timestamp
iptables -A INPUT -p ICMP --icmp-type timestamp-request -j DROP
iptables -A INPUT -p ICMP --icmp-type timestamp-reply -j DROP
# Invalid state
iptables -I INPUT  -m conntrack --ctstate INVALID  -j LOG --log-prefix 'Estado invalido: ' --log-level 4
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p udp -m length --length 0:32 -j LOG --log-prefix 'bad udp 0:32:' --log-level 0
iptables -A INPUT -p udp -m length --length 0:32 -j DROP
iptables -A INPUT -m length --length 270 -j REJECT
# Bad conection ack  																							
iptables -A INPUT -m length --length 270 -j LOG --log-prefix 'Peligro:bad_connection' --log-ip-options
iptables -A INPUT -m length --length 270 -j REJECT
# Filter by string
iptables -I OUTPUT  1  -p udp -m string --string 'in-addr' --algo bm -j DROP
iptables -I OUTPUT  1  -p udp -m string --string 'arpa' --algo bm -j DROP
iptables -I INPUT -p tcp ! --syn -m state --state NEW -j DROP
# Bad conection ack
iptables -A INPUT -m length --length 270 -j LOG --log-prefix 'Peligro:bad_connection' --log-ip-options
iptables -A INPUT -m length --length 270 -j REJECT
EOF

logger -i -p INFO "## Add IPTables at the startup ##" ; 
cd /etc/init.d && update-rc.d gsv.sh defaults ; 
logger -i -p INFO " " ; 


logger -i -p INFO "## Update APT repos ####" ; 
apt-get update ; 

logger -i -p INFO "## Upgrade SO ##" ; 
apt-get dist-upgrade -y ;  

logger -i -p INFO "## Install Kernel Headers on the SO ##" ; 
apt-get install linux-headers-$(uname -r) -y ; 

logger -i -p INFO "## Install some applications ##" ; 
apt-get install dirmngr tcpdump nmap mc mlocate dnsutils rcconf apt-transport-https ca-certificates curl gnupg2 software-properties-common htop -y  ;

logger -i -p INFO "## MEGASync (dependencies) ##" ;
apt-get install libcrypto++-dev libcurl4-openssl-dev libdb5.3++-dev libfreeimage-dev libreadline-dev libfuse-dev git g++ pkg-config make cpp gcc -y ;

logger -i -p INFO "## GIT Proxy configuration ##" ; 
git config --global http.proxy http://some_user:some_password@10.168.11.2:5555/ ; 

logger -i -p INFO "## MEGASync (download MEGASync) ##" ; 
cd /opt ; 
wget https://github.com/matteoserva/MegaFuse/archive/master.zip && unzip /opt/master.zip ; mv /opt/MegaFuse-master /opt/MegaFuse && rm -f master.zip ; 

logger -i -p INFO "## MEGASync (Declare missing variable on file_cache_row.cpp) ##" ; 
sed -i '10,10s/^/#include <cmath> /' /opt/MegaFuse/src/file_cache_row.cpp ; 

logger -i -p INFO "## MEGASync (Backup de megafuse.conf) ##" ; 
cp /opt/MegaFuse/megafuse.conf cp /opt/MegaFuse/megafuse.conf.bkp ; 

logger -i -p INFO "## MEGASync (Configuracion de megafuse.conf) ##" ;
cat <<EOF > /opt/MegaFuse/megafuse.conf
###################
# Config file, please remove the # in front of the variable when you edit it: "#USERNAME" --> "USERNAME"
###################
USERNAME = gsventerprise2018@gmail.com
PASSWORD = Odio33!%
##### create your appkey at https://mega.co.nz/#sdk
#APPKEY = MEGASDK
#### you can specify a mountpoint here, only absolute paths are supported.
MOUNTPOINT = /mnt/Mega
#### path for the cached files; /tmp is the default, change it if your /tmp is small
CACHEPATH = /mnt/Megacache
EOF

logger -i -p INFO "## MEGASync (Creating the MEGASync folders) ##" ;
mkdir /mnt/Mega  ; 
mkdir /mnt/Megacache  ; 

logger -i -p INFO "## MEGASync (Creating startup-script for MegaSync) ##" ;
cat <<EOF > /etc/init.d/megasync.sh
#!/bin/bash
### BEGIN INIT INFO
# Provides:          GSV-Enterprsie
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Mega startup script
# Description:
#
### END INIT INFO
cd /opt/MegaFuse
sh MegaFuse &
EOF

logger -i -p INFO "## MEGASync (Make privilage to run for the startup script) ##" ;
chmod +x /etc/init.d/megasync.sh  ; 
chmod 700 /etc/init.d/megasync.sh ; 

logger -i -p INFO "## MEGASync (Adding to the VM start the megasync.sh script) ####" ; 
cd /etc/init.d && update-rc.d megasync.sh defaults ; 

logger -i -p INFO "## MEGASync (Making the 'make') ##" ; 
cd /opt/MegaFuse && make ; 

logger -i -p INFO "## MEGASync (Rung Mega) ##" ; 
cd /opt/MegaFuse/ MegaFuse & 

logger -i -p INFO "## Docker Installation (adding repo) ##" ;
echo deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable >> /etc/apt/sources.list ; 
curl -x http://10.168.11.2:5555/ --proxy-user some_user::some_password -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - ; 

logger -i -p INFO "## Docker installation (via apt) ##" ; 
apt-get update ; 
apt-get install docker-ce -y ;

logger -i -p INFO "## Startup-script ends ##" ;
